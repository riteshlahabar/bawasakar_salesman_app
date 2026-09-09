import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class AttendanceController extends ModuleController {
  AttendanceController()
    : super(
        title: 'Attendance',
        subtitle:
            'GPS check in, check out, working hours, late, half day, and absent tracking.',
        actionLabel: 'GPS Check In',
        actionIcon: Icons.my_location,
        initialRows: const [
          ListRowModel(
            title: 'Today',
            subtitle: 'Check in 09:42 AM • Location captured',
            trailing: '7h 10m',
            icon: Icons.location_on,
            status: 'Present',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Yesterday',
            subtitle: 'Check in 09:55 AM • Check out 06:48 PM',
            trailing: '8h 53m',
            icon: Icons.access_time,
            status: 'Late',
            color: AppColors.accent,
          ),
          ListRowModel(
            title: 'Monthly Summary',
            subtitle: 'Present 22 • Late 3 • Half day 1',
            trailing: '26 days',
            icon: Icons.calendar_month,
            status: 'July',
            color: AppColors.info,
          ),
        ],
      );
}
