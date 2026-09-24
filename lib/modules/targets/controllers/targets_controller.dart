import 'package:flutter/material.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Sales targets for the salesman and how far each one has been achieved.
///
/// `achieved_amount` is computed server-side from the salesman's delivered
/// orders inside each period, so these figures move on their own — nothing
/// here needs to add anything up.
class TargetsController extends RemoteModuleController with DateFilterMixin {
  TargetsController(this._api)
    : super(
        title: t('targets.sales_targets'),
        subtitle: t('targets.monthly_and_period_targets_with_achievement'),
      );

  final SalesmanFinanceService _api;

  /// Every target, kept so changing the filter re-reads this list instead of
  /// going back to the network.
  List<Map<String, dynamic>>? _cache;

  /// Every page — the endpoint paginates 12 at a time.
  Future<List<Map<String, dynamic>>> _allTargets() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.targets(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'targets');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'targets');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    final all = _cache ??= await _allTargets();

    // A target belongs to the window its period starts in.
    final targets = all
        .where(
          (target) => isInWindow(
            DateTime.tryParse('${target['period_start']}')?.toLocal(),
          ),
        )
        .toList();

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
          title: t('common.date_range', {
            'from': ModuleRowMapper.date(target['period_start']),
            'to': ModuleRowMapper.date(target['period_end']),
          }),
          subtitle:
              '${t('targets.achieved_of', {'done': ModuleRowMapper.money(done), 'goal': ModuleRowMapper.money(goal)})}'
              ' • ${t('targets.commission_percent', {'n': '${ModuleRowMapper.toDouble(target['commission_percent'])}'})}',
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
          title: t('targets.target'),
          value: ModuleRowMapper.money(targetTotal),
          icon: Icons.flag,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.achieved'),
          value: ModuleRowMapper.money(achievedTotal),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('targets.progress'),
          value: '${percent.toStringAsFixed(0)}%',
          icon: Icons.donut_large,
          color: AppColors.info,
          subtitle: t('common.overall'),
        ),
      ],
    );
  }
}
