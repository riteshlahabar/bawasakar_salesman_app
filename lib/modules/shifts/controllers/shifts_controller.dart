import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// The shift currently assigned to the salesman.
class ShiftsController extends RemoteModuleController {
  ShiftsController(this._api)
    : super(
        title: t('common.my_shift'),
        subtitle: t('shifts.your_working_hours_grace_period_and'),
      );

  final SalesmanHrService _api;

  static Map<int, String> get _dayNames => <int, String>{
    1: t('shifts.mon'),
    2: t('shifts.tue'),
    3: t('shifts.wed'),
    4: t('shifts.thu'),
    5: t('shifts.fri'),
    6: t('shifts.sat'),
    7: t('shifts.sun'),
  };

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.shifts();
    final shift = ModuleRowMapper.mapFrom(response, 'shift');
    final assignment = ModuleRowMapper.mapFrom(response, 'assignment');

    // No assignment is a normal state, not an error: HR may simply not have
    // rostered this salesman yet, so the screen shows its empty state.
    if (shift.isEmpty) {
      return (rows: const <ListRowModel>[], stats: const <SummaryCardModel>[]);
    }

    final offs = shift['weekly_offs'];
    final offDays = offs is List
        ? offs
              .map((day) => _dayNames[ModuleRowMapper.toInt(day)] ?? '')
              .where((name) => name.isNotEmpty)
              .join(', ')
        : '';

    return (
      rows: [
        ModuleRowMapper.row(
          title: shift['name']?.toString() ?? t('common.shift'),
          subtitle:
              t('common.date_range', {
                'from': _time(shift['starts_at']),
                'to': _time(shift['ends_at']),
              }) +
              (offDays.isEmpty
                  ? ''
                  : ' • ${t('shifts.weekly_off', {'days': offDays})}'),
          trailing: '',
          icon: Icons.schedule,
          status: 'active',
        ),
        ModuleRowMapper.row(
          title: t('shifts.assignment_period'),
          subtitle:
              'From ${ModuleRowMapper.date(assignment['effective_from'])}'
              '${assignment['effective_to'] == null ? ' (ongoing)' : ' to ${ModuleRowMapper.date(assignment['effective_to'])}'}',
          trailing: '',
          icon: Icons.date_range,
          status: 'active',
        ),
      ],
      stats: [
        ModuleRowMapper.stat(
          title: t('shifts.starts'),
          value: _time(shift['starts_at']),
          icon: Icons.login,
          color: AppColors.primary,
          subtitle: t('shifts.shift_in'),
        ),
        ModuleRowMapper.stat(
          title: t('shifts.ends'),
          value: _time(shift['ends_at']),
          icon: Icons.logout,
          color: AppColors.info,
          subtitle: t('shifts.shift_out'),
        ),
        ModuleRowMapper.stat(
          title: t('shifts.grace'),
          value: '${ModuleRowMapper.toInt(shift['grace_minutes'])} m',
          icon: Icons.timer_outlined,
          color: AppColors.orange,
          subtitle: t('shifts.allowed'),
        ),
      ],
    );
  }

  /// Trims a `HH:MM:SS` time column down to `HH:MM`.
  String _time(Object? value) {
    final text = value?.toString() ?? '';
    return text.length >= 5 ? text.substring(0, 5) : text;
  }
}
