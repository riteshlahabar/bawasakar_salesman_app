import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// The company holiday calendar for the current year.
class HolidaysController extends RemoteModuleController {
  HolidaysController(this._api)
    : super(
        title: t('holidays.holiday_calendar'),
        subtitle: t('holidays.national_company_and_festival_holidays_declared'),
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final holidays = ModuleRowMapper.listFrom(
      await _api.holidays(),
      'holidays',
    );

    // Compared as dates, not as text: `ModuleRowMapper.date` is for display
    // and returns `dd-mm-yyyy`, which does not sort lexicographically.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcoming = holidays.where((h) {
      final date = DateTime.tryParse(h['holiday_date']?.toString() ?? '');

      return date != null && !date.isBefore(today);
    }).length;

    return (
      rows: holidays.map((holiday) {
        final date = ModuleRowMapper.date(holiday['holiday_date']);
        final parsed = DateTime.tryParse(
          holiday['holiday_date']?.toString() ?? '',
        );
        final isPast = parsed != null && parsed.isBefore(today);

        return ModuleRowMapper.row(
          title: holiday['title']?.toString() ?? '',
          subtitle: [
            date,
            (holiday['holiday_type']?.toString() ?? '').toUpperCase(),
            if ((holiday['description']?.toString() ?? '').isNotEmpty)
              holiday['description'].toString(),
          ].join(' • '),
          trailing: isPast ? '' : t('holidays.upcoming'),
          icon: Icons.event_available_outlined,
          // Past holidays are greyed to "completed" so the upcoming ones stand
          // out in a year-long list.
          status: isPast ? 'completed' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: holidays.length.toString(),
          icon: Icons.calendar_month,
          color: AppColors.primary,
          subtitle: t('common.this_year'),
        ),
        ModuleRowMapper.stat(
          title: t('holidays.upcoming'),
          value: upcoming.toString(),
          icon: Icons.upcoming,
          color: AppColors.success,
          subtitle: t('common.remaining'),
        ),
      ],
    );
  }
}
