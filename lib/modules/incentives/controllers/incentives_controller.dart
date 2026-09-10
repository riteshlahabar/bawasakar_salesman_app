import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Month-by-month incentive, commission and bonus earnings.
class IncentivesController extends RemoteModuleController {
  IncentivesController(this._api)
    : super(
        title: 'Incentive & Commission',
        subtitle:
            'What you earned beyond basic salary each month: incentives, commission and bonuses.',
      );

  final SalesmanFinanceService _api;

  static const _months = <String>[
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.incentives();
    final months = ModuleRowMapper.listFrom(response, 'months');
    final totals = ModuleRowMapper.mapFrom(response, 'totals');

    return (
      rows: months.map((month) {
        final incentive = ModuleRowMapper.toDouble(month['incentives']);
        final commission = ModuleRowMapper.toDouble(month['commission']);
        final bonus = ModuleRowMapper.toDouble(month['bonus']);

        return ModuleRowMapper.row(
          title: '${_monthName(month['salary_month'])} ${month['salary_year']}',
          subtitle:
              'Incentive ${ModuleRowMapper.money(incentive)}'
              ' • Commission ${ModuleRowMapper.money(commission)}'
              ' • Bonus ${ModuleRowMapper.money(bonus)}',
          trailing: ModuleRowMapper.money(incentive + commission + bonus),
          icon: Icons.emoji_events_outlined,
          // Nothing earned in a month is not a failure, but it should read
          // differently from a month that paid out.
          status: (incentive + commission + bonus) > 0 ? 'paid' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Incentives',
          value: ModuleRowMapper.money(totals['incentives']),
          icon: Icons.emoji_events,
          color: AppColors.primary,
          subtitle: 'This year',
        ),
        ModuleRowMapper.stat(
          title: 'Commission',
          value: ModuleRowMapper.money(totals['commission']),
          icon: Icons.percent,
          color: AppColors.success,
          subtitle: 'This year',
        ),
        ModuleRowMapper.stat(
          title: 'Bonus',
          value: ModuleRowMapper.money(totals['bonus']),
          icon: Icons.card_giftcard,
          color: AppColors.info,
          subtitle: 'This year',
        ),
      ],
    );
  }

  String _monthName(Object? month) {
    final index = ModuleRowMapper.toInt(month);
    return index >= 1 && index <= 12 ? _months[index] : '';
  }
}
