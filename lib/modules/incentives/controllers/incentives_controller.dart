import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/controllers/year_month_filter_mixin.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Month-by-month incentive, commission and bonus earnings.
///
/// Reads the same released `salary_slips` as Salary, but split the other way:
/// Salary lists basic/allowances/deductions per month, this lists what was
/// earned on top of them. The Phase 1 spec names Incentives and Commission as
/// two separate salesman items, so this is not the duplicate that the old
/// Payslips menu was.
///
/// The incentive and commission *rules* stay out of the app on purpose: the
/// spec lists Incentive Rules and Commission Rules under the admin panel's
/// HRMS module 11, not with the salesman.
class IncentivesController extends RemoteModuleController
    with YearMonthFilterMixin {
  IncentivesController(this._api)
    : super(
        title: t('incentives.incentive_and_commission'),
        subtitle: t('incentives.what_you_earned_beyond_basic_salary'),
      );

  final SalesmanFinanceService _api;

  /// Every month the selected year returned, before the month chip narrows
  /// it. Held so changing the month never hits the network.
  List<Map<String, dynamic>> _yearMonths = const [];

  /// A pull-to-refresh must really refetch — a slip is released by HR, so
  /// that is the only way this screen learns of a new one. The mixin's
  /// `selectMonth` calls `super.load()` instead, so a chip change keeps this
  /// cache warm.
  @override
  Future<void> load() {
    _yearMonths = const [];

    return super.load();
  }

  @override
  Future<ModuleData> fetch() async {
    var all = _yearMonths;
    var totals = const <String, dynamic>{};

    if (all.isEmpty) {
      final response = await _api.incentives(year: year.value.toString());
      all = ModuleRowMapper.listFrom(response, 'months');
      totals = ModuleRowMapper.mapFrom(response, 'totals');
      _yearMonths = all;
    }

    final month = selectedMonth.value;
    final shown = all.where(isInMonth).toList();

    // The year's own totals are only right when every month is shown; a month
    // chip has to add up what is actually listed.
    final incentives = month == null
        ? ModuleRowMapper.toDouble(totals['incentives'])
        : _sum(shown, 'incentives');
    final commission = month == null
        ? ModuleRowMapper.toDouble(totals['commission'])
        : _sum(shown, 'commission');
    final bonus = month == null
        ? ModuleRowMapper.toDouble(totals['bonus'])
        : _sum(shown, 'bonus');

    return (
      rows: shown.map((record) {
        final earned =
            ModuleRowMapper.toDouble(record['incentives']) +
            ModuleRowMapper.toDouble(record['commission']) +
            ModuleRowMapper.toDouble(record['bonus']);

        return ModuleRowMapper.row(
          title:
              '${YearMonthFilterMixin.rowMonth(record['salary_month'])}'
                      ' ${record['salary_year']}'
                  .trim(),
          subtitle: t('incentives.row', {
            'incentive': ModuleRowMapper.money(record['incentives']),
            'commission': ModuleRowMapper.money(record['commission']),
            'bonus': ModuleRowMapper.money(record['bonus']),
          }),
          trailing: ModuleRowMapper.money(earned),
          icon: Icons.emoji_events_outlined,
          // No status badge. Every month listed here is a released slip, so
          // nothing is pending — the old code marked a month "pending" purely
          // because it had earned nothing, which read as an unpaid month. A
          // zero month shows ₹0, which says it honestly.
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.incentives'),
          value: ModuleRowMapper.money(incentives),
          icon: Icons.emoji_events,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('incentives.commission'),
          value: ModuleRowMapper.money(commission),
          icon: Icons.percent,
          color: AppColors.success,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('incentives.bonus'),
          value: ModuleRowMapper.money(bonus),
          icon: Icons.card_giftcard,
          color: AppColors.info,
          subtitle: windowLabel,
        ),
      ],
    );
  }

  double _sum(List<Map<String, dynamic>> rows, String key) => rows.fold(
    0,
    (total, row) => total + ModuleRowMapper.toDouble(row[key]),
  );
}
