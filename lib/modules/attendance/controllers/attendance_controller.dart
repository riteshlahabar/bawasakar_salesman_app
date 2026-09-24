import 'package:flutter/material.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/clock_time.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// The attendance sheet, built from the GPS check-in/out logs.
class AttendanceController extends RemoteModuleController with DateFilterMixin {
  AttendanceController(this._api)
    : super(
        title: t('common.attendance'),
        subtitle: t('attendance.your_gps_check_in_and_check'),
      );

  final SalesmanAttendanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final response = isRange && from.value != null && to.value != null
        ? await _api.attendance(
            from: DateFilterMixin.apiDay(from.value!),
            to: DateFilterMixin.apiDay(to.value!),
          )
        : await _api.attendance(month: monthParam);
    final logs = ModuleRowMapper.listFrom(response, 'logs');
    final summary = ModuleRowMapper.mapFrom(response, 'summary');

    final workedHours = ModuleRowMapper.toInt(summary['working_minutes']) / 60;

    return (
      rows: logs.map((log) {
        final inAt = log['check_in_at']?.toString();
        final outAt = log['check_out_at']?.toString();
        final minutes = ModuleRowMapper.toInt(log['working_minutes']);

        final hours = minutes == 0
            ? ''
            : t('attendance.hours', {'n': (minutes / 60).toStringAsFixed(1)});

        return ModuleRowMapper.row(
          title: ModuleRowMapper.date(log['attendance_date']),
          // Kept as the plain fallback; the coloured spans below are what the
          // row actually draws.
          subtitle:
              t('attendance.in_out', {'in': _time(inAt), 'out': _time(outAt)}) +
              (hours.isEmpty ? '' : ' • $hours'),
          subtitleSpans: [
            _part(t('attendance.in'), _time(inAt), AppColors.success),
            const TextSpan(text: '   '),
            _part(t('attendance.out'), _time(outAt), AppColors.orange),
            if (hours.isNotEmpty) ...[
              const TextSpan(text: '   '),
              _part(t('attendance.worked'), hours, AppColors.info),
            ],
          ],
          // Empty on purpose: the right-hand side carries only the
          // present/absent badge, not the GPS/No GPS label it used to show.
          trailing: '',
          // A calendar day, not the old fingerprint: each row is one date, and
          // the punch itself is already spelled out in the subtitle.
          icon: Icons.calendar_month_rounded,
          status: log['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('attendance.present'),
          value: ModuleRowMapper.toInt(summary['present']).toString(),
          icon: Icons.check_circle,
          color: AppColors.success,
          subtitle: t('attendance.days'),
        ),
        ModuleRowMapper.stat(
          title: t('attendance.half_day'),
          value: ModuleRowMapper.toInt(summary['half_day']).toString(),
          icon: Icons.timelapse,
          color: AppColors.orange,
          subtitle: t('attendance.days'),
        ),
        ModuleRowMapper.stat(
          title: t('attendance.absent'),
          value: ModuleRowMapper.toInt(summary['absent']).toString(),
          icon: Icons.cancel,
          color: AppColors.danger,
          subtitle: t('attendance.days'),
        ),
        ModuleRowMapper.stat(
          title: t('attendance.worked'),
          value: t('attendance.hours', {'n': workedHours.toStringAsFixed(0)}),
          icon: Icons.schedule,
          color: AppColors.info,
          subtitle: windowLabel,
        ),
      ],
    );
  }

  /// The punch time in the device's own timezone; `--:--` when it is missing.
  String _time(String? timestamp) => clockTime(timestamp);

  /// One "In 9:05 AM" piece of the subtitle: a grey label followed by the
  /// value in its own colour, so the three readings are told apart at a
  /// glance rather than running together in one grey line.
  static TextSpan _part(String label, String value, Color color) {
    return TextSpan(
      children: [
        TextSpan(text: '$label '),
        TextSpan(
          text: value,
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
