import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/add_expense_sheet.dart';

/// Expense claims raised by the salesman and their approval state.
class ExpensesController extends RemoteModuleController with DateFilterMixin {
  ExpensesController(this._api)
    : super(
        title: t('expenses.expense_management'),
        subtitle: t('expenses.travel_fuel_food_and_other_field'),
        actionLabel: t('expenses.add_expense'),
        actionIcon: Icons.add_card,
      );

  /// The same six kinds the admin Expenses module offers, in the same order.
  /// They are sent as these codes and only translated for display.
  static const expenseTypes = <String>[
    'travel',
    'fuel',
    'food',
    'hotel',
    'mobile',
    'other',
  ];

  static String expenseTypeLabel(String code) => t('expenses.type_$code');

  final SalesmanFinanceService _api;

  final isSubmitting = false.obs;

  /// The form's fields.
  final expenseType = ''.obs;
  final amountController = TextEditingController();
  final expenseDate = Rx<DateTime>(DateTime.now());
  final remarksController = TextEditingController();

  /// Every claim, kept so changing the filter re-reads this list instead of
  /// going back to the network. Cleared whenever a claim is submitted.
  List<Map<String, dynamic>>? _cache;

  /// The screen opens on today's claims, like Dealer Visits.
  @override
  DateFilterMode get initialFilterMode => DateFilterMode.today;

  @override
  void onClose() {
    amountController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  /// Every page, not just the first — the endpoint paginates 20 at a time, so
  /// reading page 1 alone would both truncate the list and cap the totals.
  Future<List<Map<String, dynamic>>> _allExpenses() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.expenses(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'expenses');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'expenses');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    final all = _cache ??= await _allExpenses();

    final expenses = all
        .where(
          (expense) => isInWindow(
            DateTime.tryParse('${expense['expense_date']}')?.toLocal(),
          ),
        )
        .toList();

    // The tiles follow the filter, so they always describe the rows listed
    // underneath them.
    double sumWhere(bool Function(Map<String, dynamic>) test) => expenses
        .where(test)
        .fold(
          0,
          (total, row) => total + ModuleRowMapper.toDouble(row['amount']),
        );

    return (
      rows: expenses
          .map(
            (expense) => ModuleRowMapper.row(
              title: expenseTypeLabel(
                expense['expense_type']?.toString() ?? 'other',
              ),
              titleTrailing: ModuleRowMapper.date(expense['expense_date']),
              subtitle: expense['remarks']?.toString() ?? '',
              trailing: ModuleRowMapper.money(expense['amount']),
              icon: Icons.account_balance_wallet_outlined,
              status: expense['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.claimed'),
          value: ModuleRowMapper.money(sumWhere((_) => true)),
          icon: Icons.summarize,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.approved'),
          value: ModuleRowMapper.money(
            sumWhere((e) => e['status'] == 'approved'),
          ),
          icon: Icons.verified,
          color: AppColors.success,
          subtitle: t('expenses.reimbursable'),
        ),
        ModuleRowMapper.stat(
          title: t('common.pending'),
          value: ModuleRowMapper.money(
            sumWhere((e) => e['status'] == 'pending'),
          ),
          icon: Icons.hourglass_bottom,
          color: AppColors.orange,
          subtitle: t('expenses.awaiting'),
        ),
      ],
    );
  }

  /// Opens the claim form. `RemoteModuleView` wires this to the screen's
  /// primary button because [actionLabel] is set — without this override the
  /// button fell through to the base class and only said the action was not
  /// available yet, which is why Add Expense did nothing.
  @override
  void primaryAction() {
    expenseType.value = '';
    amountController.clear();
    remarksController.clear();
    expenseDate.value = DateTime.now();

    Get.bottomSheet<void>(
      AddExpenseSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> saveExpense() async {
    if (isSubmitting.value) return;

    if (expenseType.value.isEmpty) {
      Get.snackbar(t('expenses.expense_type'), t('expenses.type_required'));
      return;
    }

    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      Get.snackbar(t('expenses.amount'), t('expenses.amount_required'));
      return;
    }

    isSubmitting.value = true;

    try {
      await _api.submitExpense({
        'expense_type': expenseType.value,
        'amount': amount,
        'expense_date': DateFilterMixin.apiDay(expenseDate.value),
        if (remarksController.text.trim().isNotEmpty)
          'remarks': remarksController.text.trim(),
      });

      Get.back<void>();
      Get.snackbar(title, t('expenses.expense_submitted_for_approval'));

      // The new claim is not in the cached list, so drop it and refetch.
      _cache = null;
      await load();
    } catch (failure) {
      Get.snackbar(
        t('expenses.expense_not_saved'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
