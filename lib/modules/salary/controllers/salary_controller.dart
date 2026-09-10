import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Salary structure and the most recent finalised slips.
class SalaryController extends RemoteModuleController {
  SalaryController(this._api)
    : super(
        title: 'Salary',
        subtitle:
            'Your salary structure, monthly earnings, allowances and deductions.',
      );

  final SalesmanFinanceService _api;

  static const _months = <String>[
    '',
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.salary();
    final slips = ModuleRowMapper.listFrom(response, 'salary_slips');
    final latest = slips.isEmpty ? const <String, dynamic>{} : slips.first;

    return (
      rows: slips
          .map(
            (slip) => ModuleRowMapper.row(
              title: '${_monthName(slip['salary_month'])} ${slip['salary_year']}',
              subtitle:
                  'Basic ${ModuleRowMapper.money(slip['basic_salary'])}'
                  ' • Allowances ${ModuleRowMapper.money(slip['allowances'])}'
                  ' • Deductions ${ModuleRowMapper.money(slip['deductions'])}',
              trailing: ModuleRowMapper.money(slip['net_salary']),
              icon: Icons.account_balance_wallet,
              status: slip['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Latest net',
          value: ModuleRowMapper.money(latest['net_salary']),
          icon: Icons.payments,
          color: AppColors.primary,
          subtitle: _monthName(latest['salary_month']),
        ),
        ModuleRowMapper.stat(
          title: 'Incentives',
          value: ModuleRowMapper.money(latest['incentives']),
          icon: Icons.emoji_events,
          color: AppColors.success,
          subtitle: 'This slip',
        ),
        ModuleRowMapper.stat(
          title: 'Deductions',
          value: ModuleRowMapper.money(latest['deductions']),
          icon: Icons.remove_circle_outline,
          color: AppColors.orange,
          subtitle: 'This slip',
        ),
      ],
    );
  }

  String _monthName(Object? month) {
    final index = ModuleRowMapper.toInt(month);
    return index >= 1 && index <= 12 ? _months[index] : '';
  }
}
