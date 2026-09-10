import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Salary advances and employee loans, with their EMI recovery schedule.
class AdvancesController extends RemoteModuleController {
  AdvancesController(this._api)
    : super(
        title: 'Advance & Loan',
        subtitle:
            'Request a salary advance or a loan, and track how much has been recovered from your salary.',
        actionLabel: 'Request Advance',
        actionIcon: Icons.request_quote_outlined,
      );

  final SalesmanFinanceService _api;

  final isSubmitting = false.obs;

  @override
  Future<ModuleData> fetch() async {
    // Advances and loans are separate record types on the same endpoint, so
    // both are fetched and shown together.
    final responses = await Future.wait([_api.advances(), _api.loans()]);

    final advances = ModuleRowMapper.listFrom(responses[0], 'records');
    final loans = ModuleRowMapper.listFrom(responses[1], 'records');
    final all = [...advances, ...loans];

    final sanctioned = all.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['amount']),
    );
    final recovered = all.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['recovered_amount']),
    );

    return (
      rows: all.map((record) {
        final amount = ModuleRowMapper.toDouble(record['amount']);
        final done = ModuleRowMapper.toDouble(record['recovered_amount']);
        final installments = ModuleRowMapper.toInt(record['installments']);

        return ModuleRowMapper.row(
          title: record['reference_no']?.toString() ?? '',
          subtitle:
              '${record['advance_type']?.toString().toUpperCase()}'
              ' • ${ModuleRowMapper.money(amount)}'
              '${installments > 1 ? ' over $installments EMIs of ${ModuleRowMapper.money(record['emi_amount'])}' : ''}'
              ' • Recovered ${ModuleRowMapper.money(done)}',
          trailing: ModuleRowMapper.money(amount - done),
          icon: record['advance_type'] == 'loan'
              ? Icons.account_balance
              : Icons.savings_outlined,
          status: record['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Sanctioned',
          value: ModuleRowMapper.money(sanctioned),
          icon: Icons.request_quote,
          color: AppColors.primary,
          subtitle: 'Total',
        ),
        ModuleRowMapper.stat(
          title: 'Recovered',
          value: ModuleRowMapper.money(recovered),
          icon: Icons.done_all,
          color: AppColors.success,
          subtitle: 'Repaid',
        ),
        ModuleRowMapper.stat(
          title: 'Outstanding',
          value: ModuleRowMapper.money(sanctioned - recovered),
          icon: Icons.pending_actions,
          color: AppColors.orange,
          subtitle: 'Remaining',
        ),
      ],
    );
  }

  /// Eligibility (how many requests may be open at once) is enforced server
  /// side; a refusal comes back as a message shown verbatim.
  Future<void> request({
    required String type,
    required double amount,
    int installments = 1,
    String? reason,
  }) async {
    isSubmitting.value = true;
    try {
      await _api.requestAdvance({
        'advance_type': type,
        'amount': amount,
        'installments': installments,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      });
      await load();
      Get.snackbar(title, 'Request submitted for approval.');
    } catch (failure) {
      Get.snackbar(title, failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
