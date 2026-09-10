import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/theme/app_colors.dart';

/// The monthly attendance sheet, built from the GPS check-in/out logs.
class AttendanceController extends RemoteModuleController {
  AttendanceController(this._api)
    : super(
        title: 'Attendance',
        subtitle:
            'Your GPS check-in and check-out history for the month, with present, half day and absent days.',
      );

  final SalesmanAttendanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.attendance();
    final logs = ModuleRowMapper.listFrom(response, 'logs');
    final summary = ModuleRowMapper.mapFrom(response, 'summary');

    final workedHours = ModuleRowMapper.toInt(summary['working_minutes']) / 60;

    return (
      rows: logs.map((log) {
        final inAt = log['check_in_at']?.toString();
        final outAt = log['check_out_at']?.toString();
        final minutes = ModuleRowMapper.toInt(log['working_minutes']);

        return ModuleRowMapper.row(
          title: ModuleRowMapper.date(log['attendance_date']),
          subtitle:
              'In ${_time(inAt)} • Out ${_time(outAt)}'
              '${minutes == 0 ? '' : ' • ${(minutes / 60).toStringAsFixed(1)} h'}',
          trailing: log['check_in_latitude'] == null ? 'No GPS' : 'GPS',
          icon: Icons.fingerprint,
          status: log['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Present',
          value: ModuleRowMapper.toInt(summary['present']).toString(),
          icon: Icons.check_circle,
          color: AppColors.success,
          subtitle: 'Days',
        ),
        ModuleRowMapper.stat(
          title: 'Half day',
          value: ModuleRowMapper.toInt(summary['half_day']).toString(),
          icon: Icons.timelapse,
          color: AppColors.orange,
          subtitle: 'Days',
        ),
        ModuleRowMapper.stat(
          title: 'Absent',
          value: ModuleRowMapper.toInt(summary['absent']).toString(),
          icon: Icons.cancel,
          color: AppColors.danger,
          subtitle: 'Days',
        ),
        ModuleRowMapper.stat(
          title: 'Worked',
          value: '${workedHours.toStringAsFixed(0)} h',
          icon: Icons.schedule,
          color: AppColors.info,
          subtitle: 'This month',
        ),
      ],
    );
  }

  /// Pulls `HH:mm` out of an ISO timestamp; blank when the punch is missing.
  String _time(String? timestamp) {
    if (timestamp == null || timestamp.length < 16) return '--:--';
    return timestamp.substring(11, 16);
  }
}
