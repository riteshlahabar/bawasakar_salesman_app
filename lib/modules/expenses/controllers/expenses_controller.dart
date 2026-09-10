import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Expense claims raised by the salesman and their approval state.
class ExpensesController extends RemoteModuleController {
  ExpensesController(this._api)
    : super(
        title: 'Expense Management',
        subtitle:
            'Travel, fuel, food and other field expenses, with approval and reimbursement status.',
        actionLabel: 'Add Expense',
        actionIcon: Icons.add_card,
      );

  final SalesmanFinanceService _api;

  final isSubmitting = false.obs;

  @override
  Future<ModuleData> fetch() async {
    final expenses = ModuleRowMapper.listFrom(await _api.expenses(), 'expenses');

    double sumWhere(bool Function(Map<String, dynamic>) test) => expenses
        .where(test)
        .fold(0, (total, row) => total + ModuleRowMapper.toDouble(row['amount']));

    return (
      rows: expenses
          .map(
            (expense) => ModuleRowMapper.row(
              title: expense['expense_type']?.toString().toUpperCase() ?? '',
              subtitle:
                  '${ModuleRowMapper.date(expense['expense_date'])}'
                  '${(expense['remarks']?.toString() ?? '').isEmpty ? '' : ' • ${expense['remarks']}'}',
              trailing: ModuleRowMapper.money(expense['amount']),
              icon: Icons.receipt_long,
              status: expense['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Claimed',
          value: ModuleRowMapper.money(sumWhere((_) => true)),
          icon: Icons.summarize,
          color: AppColors.primary,
          subtitle: 'Total',
        ),
        ModuleRowMapper.stat(
          title: 'Approved',
          value: ModuleRowMapper.money(sumWhere((e) => e['status'] == 'approved')),
          icon: Icons.verified,
          color: AppColors.success,
          subtitle: 'Reimbursable',
        ),
        ModuleRowMapper.stat(
          title: 'Pending',
          value: ModuleRowMapper.money(sumWhere((e) => e['status'] == 'pending')),
          icon: Icons.hourglass_bottom,
          color: AppColors.orange,
          subtitle: 'Awaiting',
        ),
      ],
    );
  }

  Future<void> submit({
    required String expenseType,
    required double amount,
    required DateTime date,
    String? remarks,
  }) async {
    isSubmitting.value = true;
    try {
      await _api.submitExpense({
        'expense_type': expenseType,
        'amount': amount,
        'expense_date': date.toIso8601String().substring(0, 10),
        if (remarks != null && remarks.trim().isNotEmpty)
          'remarks': remarks.trim(),
      });
      await load();
      Get.snackbar(title, 'Expense submitted for approval.');
    } catch (failure) {
      Get.snackbar(title, failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
