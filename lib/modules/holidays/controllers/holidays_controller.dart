import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// The company holiday calendar for the current year.
class HolidaysController extends RemoteModuleController {
  HolidaysController(this._api)
    : super(
        title: 'Holiday Calendar',
        subtitle:
            'National, company and festival holidays declared for this year.',
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final holidays = ModuleRowMapper.listFrom(await _api.holidays(), 'holidays');

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final upcoming = holidays
        .where((h) => ModuleRowMapper.date(h['holiday_date']).compareTo(today) >= 0)
        .length;

    return (
      rows: holidays.map((holiday) {
        final date = ModuleRowMapper.date(holiday['holiday_date']);
        final isPast = date.compareTo(today) < 0;

        return ModuleRowMapper.row(
          title: holiday['title']?.toString() ?? '',
          subtitle: [
            date,
            (holiday['holiday_type']?.toString() ?? '').toUpperCase(),
            if ((holiday['description']?.toString() ?? '').isNotEmpty)
              holiday['description'].toString(),
          ].join(' • '),
          trailing: isPast ? '' : 'Upcoming',
          icon: Icons.event_available_outlined,
          // Past holidays are greyed to "completed" so the upcoming ones stand
          // out in a year-long list.
          status: isPast ? 'completed' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Total',
          value: holidays.length.toString(),
          icon: Icons.calendar_month,
          color: AppColors.primary,
          subtitle: 'This year',
        ),
        ModuleRowMapper.stat(
          title: 'Upcoming',
          value: upcoming.toString(),
          icon: Icons.upcoming,
          color: AppColors.success,
          subtitle: 'Remaining',
        ),
      ],
    );
  }
}
