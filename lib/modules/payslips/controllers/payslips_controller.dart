import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Finalised payslips for one year.
///
/// Draft slips are filtered out server side, so anything listed here is a
/// payslip HR has actually released.
class PayslipsController extends RemoteModuleController {
  PayslipsController(this._api)
    : super(
        title: 'Payslips',
        subtitle:
            'Your released payslips with net pay, incentives and deductions for each month.',
      );

  final SalesmanFinanceService _api;

  static const _months = <String>[
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.payslips();
    final slips = ModuleRowMapper.listFrom(response, 'payslips');
    final totals = ModuleRowMapper.mapFrom(response, 'totals');

    return (
      rows: slips
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
          title: 'Net paid',
          value: ModuleRowMapper.money(totals['net_paid']),
          icon: Icons.account_balance_wallet,
          color: AppColors.primary,
          subtitle: 'This year',
        ),
        ModuleRowMapper.stat(
          title: 'Incentives',
          value: ModuleRowMapper.money(totals['incentives']),
          icon: Icons.emoji_events,
          color: AppColors.success,
          subtitle: 'This year',
        ),
        ModuleRowMapper.stat(
          title: 'Deductions',
          value: ModuleRowMapper.money(totals['deductions']),
          icon: Icons.remove_circle_outline,
          color: AppColors.orange,
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
