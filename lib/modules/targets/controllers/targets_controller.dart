import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Sales targets for the salesman and how far each one has been achieved.
class TargetsController extends RemoteModuleController {
  TargetsController(this._api)
    : super(
        title: 'Sales Targets',
        subtitle:
            'Monthly and period targets with achievement, shortfall and the commission rate attached to each.',
      );

  final SalesmanFinanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final targets = ModuleRowMapper.listFrom(await _api.targets(), 'targets');

    final targetTotal = targets.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['target_amount']),
    );
    final achievedTotal = targets.fold<double>(
      0,
      (sum, row) => sum + ModuleRowMapper.toDouble(row['achieved_amount']),
    );
    final percent = targetTotal <= 0 ? 0 : (achievedTotal / targetTotal * 100);

    return (
      rows: targets.map((target) {
        final goal = ModuleRowMapper.toDouble(target['target_amount']);
        final done = ModuleRowMapper.toDouble(target['achieved_amount']);
        final hit = goal > 0 && done >= goal;

        return ModuleRowMapper.row(
          title:
              '${ModuleRowMapper.date(target['period_start'])} to ${ModuleRowMapper.date(target['period_end'])}',
          subtitle:
              'Achieved ${ModuleRowMapper.money(done)} of ${ModuleRowMapper.money(goal)}'
              ' • Commission ${ModuleRowMapper.toDouble(target['commission_percent'])}%',
          trailing: goal <= 0
              ? '-'
              : '${(done / goal * 100).toStringAsFixed(0)}%',
          icon: Icons.track_changes,
          // Achievement is not a workflow status, so it is phrased as one here
          // to reuse the shared status colouring.
          status: hit ? 'approved' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Target',
          value: ModuleRowMapper.money(targetTotal),
          icon: Icons.flag,
          color: AppColors.primary,
          subtitle: 'All periods',
        ),
        ModuleRowMapper.stat(
          title: 'Achieved',
          value: ModuleRowMapper.money(achievedTotal),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: 'All periods',
        ),
        ModuleRowMapper.stat(
          title: 'Progress',
          value: '${percent.toStringAsFixed(0)}%',
          icon: Icons.donut_large,
          color: AppColors.info,
          subtitle: 'Overall',
        ),
      ],
    );
  }
}
