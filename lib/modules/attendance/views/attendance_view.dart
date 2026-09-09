import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Check In',
            value: '09:42',
            icon: Icons.login,
            color: AppColors.success,
            subtitle: 'GPS captured',
          ),
          SummaryCardModel(
            title: 'Working',
            value: '7h 10m',
            icon: Icons.access_time,
            color: AppColors.primary,
            subtitle: 'Today',
          ),
          SummaryCardModel(
            title: 'Status',
            value: 'Present',
            icon: Icons.verified,
            color: AppColors.info,
            subtitle: 'On duty',
          ),
          SummaryCardModel(
            title: 'Late Days',
            value: '3',
            icon: Icons.warning_amber,
            color: AppColors.orange,
            subtitle: 'This month',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'GPS Check In',
        primaryActionIcon: Icons.my_location,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Check Out',
        secondaryActionIcon: Icons.logout,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Attendance History',
        featured: const ModuleInfoPanel(
          icon: Icons.place_outlined,
          title: 'Current Location Required',
          subtitle:
              'Check in and check out will save latitude, longitude, time, and device sync status.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
