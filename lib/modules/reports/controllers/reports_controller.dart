import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// A single roll-up across the salesman's own modules.
///
/// This screen deliberately reads the existing per-module endpoints rather
/// than a bespoke reporting one: the figures a salesman needs are already
/// exposed, and duplicating them server side would create a second source of
/// truth that could drift from the module screens.
class ReportsController extends RemoteModuleController {
  ReportsController(this._dashboard, this._finance)
    : super(
        title: 'Reports',
        subtitle:
            'Your field performance at a glance: dealers, targets, expenses and earnings.',
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
          title: 'Target achievement',
          subtitle:
              'Achieved ${ModuleRowMapper.money(achievedTotal)} against ${ModuleRowMapper.money(targetTotal)}',
          trailing: targetTotal <= 0
              ? '-'
              : '${(achievedTotal / targetTotal * 100).toStringAsFixed(0)}%',
          icon: Icons.track_changes,
          status: achievedTotal >= targetTotal && targetTotal > 0
              ? 'approved'
              : 'pending',
        ),
        ModuleRowMapper.row(
          title: 'Expense claims',
          subtitle:
              '${expenses.length} claims worth ${ModuleRowMapper.money(expenseTotal)}'
              ' • $pendingExpenses awaiting approval',
          trailing: ModuleRowMapper.money(expenseTotal),
          icon: Icons.receipt_long,
          status: pendingExpenses == 0 ? 'approved' : 'pending',
        ),
        ModuleRowMapper.row(
          title: 'Assigned dealers',
          subtitle: 'Dealers currently mapped to your territory',
          trailing: ModuleRowMapper.toInt(summaryMap['assigned_dealers']).toString(),
          icon: Icons.storefront,
          status: 'active',
        ),
      ],
      stats: [
        ModuleRowMapper.stat(
          title: 'Pending',
          value: ModuleRowMapper.toInt(summaryMap['pending_orders']).toString(),
          icon: Icons.shopping_bag,
          color: AppColors.primary,
          subtitle: 'Orders',
        ),
        ModuleRowMapper.stat(
          title: 'Dealers',
          value: ModuleRowMapper.toInt(summaryMap['assigned_dealers']).toString(),
          icon: Icons.groups,
          color: AppColors.info,
          subtitle: 'Assigned',
        ),
        ModuleRowMapper.stat(
          title: 'Achieved',
          value: ModuleRowMapper.money(achievedTotal),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: 'Sales',
        ),
        ModuleRowMapper.stat(
          title: 'Expenses',
          value: ModuleRowMapper.money(expenseTotal),
          icon: Icons.payments,
          color: AppColors.orange,
          subtitle: 'Claimed',
        ),
      ],
    );
  }
}
