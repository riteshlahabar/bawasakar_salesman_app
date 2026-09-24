import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/status_filter_bar.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/request_advance_sheet.dart';

/// Salary advances and employee loans, with their EMI recovery schedule.
///
/// The two are one `salary_advances` table told apart by `advance_type`, and
/// both API paths reach the same controller method — see
/// [SalesmanFinanceService.advances] for why the type must be sent explicitly.
class AdvancesController extends RemoteModuleController {
  AdvancesController(this._api)
    : super(
        title: t('common.advance_and_loan'),
        subtitle: t('advances.request_a_salary_advance_or_a'),
        actionLabel: t('advances.request_advance'),
        actionIcon: Icons.request_quote_outlined,
      );

  final SalesmanFinanceService _api;

  static const typeAdvance = 'advance';
  static const typeLoan = 'loan';

  /// Both kinds a salesman may raise.
  static const requestTypes = <String>[typeAdvance, typeLoan];

  final isSubmitting = false.obs;

  /// Which state is being listed; empty is "all".
  final statusFilter = ''.obs;

  /// The request form's fields.
  final selectedType = typeAdvance.obs;
  final amountController = TextEditingController();
  final installmentsController = TextEditingController(text: '1');
  final reasonController = TextEditingController();

  /// Every record, kept so a chip change re-maps what is already held instead
  /// of going back to the network. [load] always drops it first.
  List<Map<String, dynamic>>? _cache;

  /// Instalments only mean something for a loan: [SalaryAdvanceService] forces
  /// `installments = 1` on an advance, which is recovered from the next salary
  /// in one go.
  bool get isLoanRequest => selectedType.value == typeLoan;

  List<StatusFilterOption> get filterOptions => [
    (value: '', label: t('common.all')),
    (value: 'pending', label: t('advances.pending')),
    (value: 'approved', label: t('advances.approved')),
    (value: 'disbursed', label: t('advances.disbursed')),
    (value: 'closed', label: t('advances.closed')),
  ];

  String typeLabel(String value) =>
      value == typeLoan ? t('advances.loan') : t('advances.advance');

  @override
  void onClose() {
    amountController.dispose();
    installmentsController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  /// A refresh must really go back to the server: an advance is approved and
  /// disbursed by an admin, so a status change is something this screen can
  /// only learn by refetching.
  @override
  Future<void> load() {
    _cache = null;

    return super.load();
  }

  void selectStatus(String value) {
    if (statusFilter.value == value) return;

    statusFilter.value = value;
    _refilter();
  }

  /// Re-maps what is already held for the newly picked chip. [fetch] finds the
  /// cache warm, so this never hits the network.
  Future<void> _refilter() async {
    final data = await fetch();

    rows.assignAll(data.rows);
    stats.assignAll(data.stats);
  }

  @override
  Future<ModuleData> fetch() async {
    final all = _cache ??= await _allRecords();

    final filter = statusFilter.value;
    final shown = filter.isEmpty
        ? all
        : all.where((record) => record['status'] == filter).toList();

    // The tiles total every record, not the filtered ones: they are what the
    // chips are chosen from, so narrowing them would leave the selected state
    // reading its own figure and every other one zero.
    final sanctioned = _sum(all, 'amount');
    final recovered = _sum(all, 'recovered_amount');

    return (
      rows: shown.map(_row).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('advances.sanctioned'),
          value: ModuleRowMapper.money(sanctioned),
          icon: Icons.request_quote,
          color: AppColors.primary,
          subtitle: t('common.total'),
        ),
        ModuleRowMapper.stat(
          title: t('advances.recovered'),
          value: ModuleRowMapper.money(recovered),
          icon: Icons.done_all,
          color: AppColors.success,
          subtitle: t('advances.repaid'),
        ),
        ModuleRowMapper.stat(
          title: t('common.outstanding'),
          value: ModuleRowMapper.money(sanctioned - recovered),
          icon: Icons.pending_actions,
          color: AppColors.orange,
          subtitle: t('common.remaining'),
        ),
      ],
    );
  }

  /// Advances and loans are separate record types on the same endpoint, so
  /// both are fetched and listed together — each with its own `type`, or the
  /// second call just returns the first one's rows again.
  Future<List<Map<String, dynamic>>> _allRecords() async {
    final responses = await Future.wait([_api.advances(), _api.loans()]);

    return [
      ...ModuleRowMapper.listFrom(responses[0], 'records'),
      ...ModuleRowMapper.listFrom(responses[1], 'records'),
    ];
  }

  ListRowModel _row(Map<String, dynamic> record) {
    final amount = ModuleRowMapper.toDouble(record['amount']);
    final done = ModuleRowMapper.toDouble(record['recovered_amount']);
    final installments = ModuleRowMapper.toInt(record['installments']);
    final type = record['advance_type']?.toString() ?? typeAdvance;
    final id = ModuleRowMapper.toInt(record['id']);

    return ModuleRowMapper.row(
      title: record['reference_no']?.toString() ?? '',
      titleTrailing: typeLabel(type),
      subtitle:
          '${ModuleRowMapper.money(amount)}'
          '${installments > 1 ? ' ${t('advances.over_emis', {'n': '$installments', 'amount': ModuleRowMapper.money(record['emi_amount'])})}' : ''}'
          ' • ${t('advances.recovered_amount', {'amount': ModuleRowMapper.money(done)})}',
      trailing: ModuleRowMapper.money(amount - done),
      icon: type == typeLoan ? Icons.account_balance : Icons.savings_outlined,
      status: record['status']?.toString(),
      // The EMI schedule travels with the record, so the detail screen needs
      // no second request — it is passed as the route argument.
      onTap: id > 0
          ? () => Get.toNamed<void>(
              AppRoutes.advanceDetail,
              arguments: record,
            )
          : null,
    );
  }

  /// Opens the request form. `RemoteModuleView` wires this to the screen's
  /// primary button because [actionLabel] is set — it was never overridden
  /// before, so the button only ever said the action was unavailable.
  @override
  void primaryAction() {
    selectedType.value = typeAdvance;
    amountController.clear();
    installmentsController.text = '1';
    reasonController.clear();

    Get.bottomSheet<void>(
      RequestAdvanceSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Eligibility (how many requests may be open at once) is enforced server
  /// side; a refusal comes back as a message shown verbatim.
  Future<void> submitRequest() async {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      Get.snackbar(title, t('advances.enter_a_valid_amount'));
      return;
    }

    // Only a loan carries instalments; an advance is always a single one.
    final installments = isLoanRequest
        ? (int.tryParse(installmentsController.text.trim()) ?? 1).clamp(1, 60)
        : 1;

    isSubmitting.value = true;
    try {
      await _api.requestAdvance({
        'advance_type': selectedType.value,
        'amount': amount,
        'installments': installments,
        if (reasonController.text.trim().isNotEmpty)
          'reason': reasonController.text.trim(),
      });
      Get.back<void>();
      await load();
      Get.snackbar(title, t('advances.request_submitted_for_approval'));
    } catch (failure) {
      Get.snackbar(title, failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  double _sum(List<Map<String, dynamic>> rows, String key) => rows.fold(
    0,
    (total, row) => total + ModuleRowMapper.toDouble(row[key]),
  );
}
