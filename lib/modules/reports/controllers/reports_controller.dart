import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// A single roll-up across the salesman's own modules.
///
/// This screen deliberately reads the existing per-module endpoints rather
/// than a bespoke reporting one: the figures a salesman needs are already
/// exposed, and duplicating them server side would create a second source of
/// truth that could drift from the module screens.
class ReportsController extends RemoteModuleController {
  ReportsController(this._dashboard, this._finance)
    : super(
        title: t('reports.reports'),
        subtitle: t('reports.your_field_performance_at_a_glance'),
      );

  final SalesmanDashboardService _dashboard;
  final SalesmanFinanceService _finance;

  @override
  Future<ModuleData> fetch() async {
    final responses = await Future.wait([
      _dashboard.dashboard(),
      _finance.targets(),
      _finance.expenses(),
    ]);

    final summary = responses[0]['data'];
    final summaryMap = summary is Map<String, dynamic>
        ? summary
        : const <String, dynamic>{};
    final targets = ModuleRowMapper.listFrom(responses[1], 'targets');
    final expenses = ModuleRowMapper.listFrom(responses[2], 'expenses');

    final targetTotal = targets.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['target_amount']),
    );
    final achievedTotal = targets.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['achieved_amount']),
    );
    final expenseTotal = expenses.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['amount']),
    );
    final pendingExpenses = expenses
        .where((row) => row['status'] == 'pending')
        .length;

    return (
      rows: [
        ModuleRowMapper.row(
          title: t('reports.target_achievement'),
          subtitle: t('reports.achieved_against', {
            'achieved': ModuleRowMapper.money(achievedTotal),
            'target': ModuleRowMapper.money(targetTotal),
          }),
          trailing: targetTotal <= 0
              ? '-'
              : '${(achievedTotal / targetTotal * 100).toStringAsFixed(0)}%',
          icon: Icons.track_changes,
          status: achievedTotal >= targetTotal && targetTotal > 0
              ? 'approved'
              : 'pending',
        ),
        ModuleRowMapper.row(
          title: t('reports.expense_claims'),
          subtitle:
              '${t('reports.claims_worth', {'n': '${expenses.length}', 'amount': ModuleRowMapper.money(expenseTotal)})}'
              ' • ${t('reports.awaiting_approval', {'n': '$pendingExpenses'})}',
          trailing: ModuleRowMapper.money(expenseTotal),
          icon: Icons.receipt_long,
          status: pendingExpenses == 0 ? 'approved' : 'pending',
        ),
        ModuleRowMapper.row(
          title: t('reports.assigned_dealers'),
          subtitle: t('reports.dealers_currently_mapped_to_your_territory'),
          trailing: ModuleRowMapper.toInt(
            summaryMap['assigned_dealers'],
          ).toString(),
          icon: Icons.storefront,
          status: 'active',
        ),
      ],
      stats: [
        ModuleRowMapper.stat(
          title: t('common.pending'),
          value: ModuleRowMapper.toInt(summaryMap['pending_orders']).toString(),
          icon: Icons.shopping_bag,
          color: AppColors.primary,
          subtitle: t('common.orders'),
        ),
        ModuleRowMapper.stat(
          title: t('common.dealers'),
          value: ModuleRowMapper.toInt(
            summaryMap['assigned_dealers'],
          ).toString(),
          icon: Icons.groups,
          color: AppColors.info,
          subtitle: t('reports.assigned'),
        ),
        ModuleRowMapper.stat(
          title: t('common.achieved'),
          value: ModuleRowMapper.money(achievedTotal),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: t('common.sales'),
        ),
        ModuleRowMapper.stat(
          title: t('common.expenses'),
          value: ModuleRowMapper.money(expenseTotal),
          icon: Icons.payments,
          color: AppColors.orange,
          subtitle: t('common.claimed'),
        ),
      ],
    );
  }
}
