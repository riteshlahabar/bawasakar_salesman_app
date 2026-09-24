import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/controllers/year_month_filter_mixin.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// The salesman's released payslips, a year at a time.
///
/// Reads `/salesman/payslips` rather than `/salesman/salary`: that endpoint
/// hides draft slips, returns the year's totals and carries the allowance and
/// deduction lines behind each slip. The separate Payslips menu that used to
/// own it was commented out on 2026-09-24 — the two screens listed the same
/// `SalarySlip` rows.
///
/// The window comes from [YearMonthFilterMixin], shared with Incentives —
/// see there for why `DateFilterMixin` does not fit a monthly record.
class SalaryController extends RemoteModuleController
    with YearMonthFilterMixin {
  SalaryController(this._api)
    : super(
        title: t('common.salary'),
        subtitle: t('salary.your_salary_structure_monthly_earnings_allowances'),
      );

  final SalesmanFinanceService _api;

  /// The raw slips behind [rows], kept in step with them so a tap can pass the
  /// payslip's id to the breakdown screen — [ListRowModel] carries no id.
  final slips = <Map<String, dynamic>>[].obs;

  /// Every slip the selected year returned, before the month chip narrows it.
  /// Held so changing the month never hits the network.
  List<Map<String, dynamic>> _yearSlips = const [];

  /// A pull-to-refresh must really refetch — a slip is released by HR, so that
  /// is the only way this screen learns about a new one. The mixin's
  /// `selectMonth` calls `super.load()` instead, so a chip change keeps this
  /// cache warm.
  @override
  Future<void> load() {
    _yearSlips = const [];

    return super.load();
  }

  @override
  Future<ModuleData> fetch() async {
    var all = _yearSlips;
    var totals = const <String, dynamic>{};

    if (all.isEmpty) {
      final response = await _api.payslips(year: year.value.toString());
      all = ModuleRowMapper.listFrom(response, 'payslips');
      totals = ModuleRowMapper.mapFrom(response, 'totals');
      _yearSlips = all;
    }

    final month = selectedMonth.value;
    final shown = all.where(isInMonth).toList();

    slips.assignAll(shown);

    // The year's own totals are only right when every month is shown; a month
    // chip has to add up what is actually listed.
    final netPaid = month == null
        ? ModuleRowMapper.toDouble(totals['net_paid'])
        : _sum(shown, 'net_salary');
    final incentives = month == null
        ? ModuleRowMapper.toDouble(totals['incentives'])
        : _sum(shown, 'incentives');
    final deductions = month == null
        ? ModuleRowMapper.toDouble(totals['deductions'])
        : _sum(shown, 'deductions');

    return (
      rows: shown.map(_row).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('payslips.net_paid'),
          value: ModuleRowMapper.money(netPaid),
          icon: Icons.account_balance_wallet,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.incentives'),
          value: ModuleRowMapper.money(incentives),
          icon: Icons.emoji_events,
          color: AppColors.success,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.deductions'),
          value: ModuleRowMapper.money(deductions),
          icon: Icons.remove_circle_outline,
          color: AppColors.orange,
          subtitle: windowLabel,
        ),
      ],
    );
  }

  ListRowModel _row(Map<String, dynamic> slip) {
    final name = YearMonthFilterMixin.rowMonth(slip['salary_month']);

    return ModuleRowMapper.row(
      title: '$name ${slip['salary_year']}'.trim(),
      subtitle:
          '${t('payslips.basic_salary')} ${ModuleRowMapper.money(slip['basic_salary'])}'
          ' • ${t('payslips.allowances')} ${ModuleRowMapper.money(slip['allowances'])}'
          ' • ${t('payslips.deductions')} ${ModuleRowMapper.money(slip['deductions'])}',
      trailing: ModuleRowMapper.money(slip['net_salary']),
      icon: Icons.account_balance_wallet,
      status: slip['status']?.toString(),
    );
  }

  double _sum(List<Map<String, dynamic>> rows, String key) => rows.fold(
    0,
    (total, slip) => total + ModuleRowMapper.toDouble(slip[key]),
  );
}
