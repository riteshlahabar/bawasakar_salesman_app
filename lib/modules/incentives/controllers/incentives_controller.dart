import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Month-by-month incentive, commission and bonus earnings.
class IncentivesController extends RemoteModuleController {
  IncentivesController(this._api)
    : super(
        title: t('incentives.incentive_and_commission'),
        subtitle:
            t('incentives.what_you_earned_beyond_basic_salary'),
      );

  final SalesmanFinanceService _api;

  static List<String> get _months => <String>[
    '',
    t('common.jan'), t('common.feb'), t('common.mar'), t('common.apr'), t('common.may'), t('common.jun'),
    t('common.jul'), t('common.aug'), t('common.sep'), t('common.oct'), t('common.nov'), t('common.dec'),
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
              t('incentives.row', {
                'incentive': ModuleRowMapper.money(incentive),
                'commission': ModuleRowMapper.money(commission),
                'bonus': ModuleRowMapper.money(bonus),
              }),
          trailing: ModuleRowMapper.money(incentive + commission + bonus),
          icon: Icons.emoji_events_outlined,
          // Nothing earned in a month is not a failure, but it should read
          // differently from a month that paid out.
          status: (incentive + commission + bonus) > 0 ? 'paid' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.incentives'),
          value: ModuleRowMapper.money(totals['incentives']),
          icon: Icons.emoji_events,
          color: AppColors.primary,
          subtitle: t('common.this_year'),
        ),
        ModuleRowMapper.stat(
          title: t('incentives.commission'),
          value: ModuleRowMapper.money(totals['commission']),
          icon: Icons.percent,
          color: AppColors.success,
          subtitle: t('common.this_year'),
        ),
        ModuleRowMapper.stat(
          title: t('incentives.bonus'),
          value: ModuleRowMapper.money(totals['bonus']),
          icon: Icons.card_giftcard,
          color: AppColors.info,
          subtitle: t('common.this_year'),
        ),
      ],
    );
  }

  String _monthName(Object? month) {
    final index = ModuleRowMapper.toInt(month);
    return index >= 1 && index <= 12 ? _months[index] : '';
  }
}
