import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// The shift currently assigned to the salesman.
class ShiftsController extends RemoteModuleController {
  ShiftsController(this._api)
    : super(
        title: 'My Shift',
        subtitle:
            'Your working hours, grace period and weekly offs under the shift you are assigned to.',
      );

  final SalesmanHrService _api;

  static const _dayNames = <int, String>{
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
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
          title: shift['name']?.toString() ?? 'Shift',
          subtitle:
              '${_time(shift['starts_at'])} to ${_time(shift['ends_at'])}'
              '${offDays.isEmpty ? '' : ' • Weekly off: $offDays'}',
          trailing: '',
          icon: Icons.schedule,
          status: 'active',
        ),
        ModuleRowMapper.row(
          title: 'Assignment period',
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
          title: 'Starts',
          value: _time(shift['starts_at']),
          icon: Icons.login,
          color: AppColors.primary,
          subtitle: 'Shift in',
        ),
        ModuleRowMapper.stat(
          title: 'Ends',
          value: _time(shift['ends_at']),
          icon: Icons.logout,
          color: AppColors.info,
          subtitle: 'Shift out',
        ),
        ModuleRowMapper.stat(
          title: 'Grace',
          value: '${ModuleRowMapper.toInt(shift['grace_minutes'])} m',
          icon: Icons.timer_outlined,
          color: AppColors.orange,
          subtitle: 'Allowed',
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
