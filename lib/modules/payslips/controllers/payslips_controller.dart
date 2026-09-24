import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Finalised payslips for one year.
///
/// Draft slips are filtered out server side, so anything listed here is a
/// payslip HR has actually released.
class PayslipsController extends RemoteModuleController {
  PayslipsController(this._api)
    : super(
        title: t('common.payslips'),
        subtitle: t('payslips.your_released_payslips_with_net_pay'),
      );

  final SalesmanFinanceService _api;

  /// Kept alongside the display rows so a tap can open the matching payslip's
  /// breakdown — [ListRowModel] carries no id, only what is shown.
  final slips = <Map<String, dynamic>>[].obs;

  static List<String> get _months => <String>[
    '',
    t('common.jan'),
    t('common.feb'),
    t('common.mar'),
    t('common.apr'),
    t('common.may'),
    t('common.jun'),
    t('common.jul'),
    t('common.aug'),
    t('common.sep'),
    t('common.oct'),
    t('common.nov'),
    t('common.dec'),
  ];

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.payslips();
    final slipRows = ModuleRowMapper.listFrom(response, 'payslips');
    final totals = ModuleRowMapper.mapFrom(response, 'totals');

    slips.assignAll(slipRows);

    return (
      rows: slipRows
          .map(
            (slip) => ModuleRowMapper.row(
              title:
                  '${_monthName(slip['salary_month'])} ${slip['salary_year']}',
              subtitle:
                  'Basic ${ModuleRowMapper.money(slip['basic_salary'])}'
                  ' • Incentive ${ModuleRowMapper.money(slip['incentives'])}'
                  ' • Deduction ${ModuleRowMapper.money(slip['deductions'])}',
              trailing: ModuleRowMapper.money(slip['net_salary']),
              icon: Icons.description_outlined,
              status: slip['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('payslips.net_paid'),
          value: ModuleRowMapper.money(totals['net_paid']),
          icon: Icons.account_balance_wallet,
          color: AppColors.primary,
          subtitle: t('common.this_year'),
        ),
        ModuleRowMapper.stat(
          title: t('common.incentives'),
          value: ModuleRowMapper.money(totals['incentives']),
          icon: Icons.emoji_events,
          color: AppColors.success,
          subtitle: t('common.this_year'),
        ),
        ModuleRowMapper.stat(
          title: t('common.deductions'),
          value: ModuleRowMapper.money(totals['deductions']),
          icon: Icons.remove_circle_outline,
          color: AppColors.orange,
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
