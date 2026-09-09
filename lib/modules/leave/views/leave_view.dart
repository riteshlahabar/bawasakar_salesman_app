import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Casual',
            value: '4',
            icon: Icons.event_available,
            color: AppColors.success,
            subtitle: 'Balance',
          ),
          SummaryCardModel(
            title: 'Sick',
            value: '2',
            icon: Icons.medical_services,
            color: AppColors.info,
            subtitle: 'Balance',
          ),
          SummaryCardModel(
            title: 'Pending',
            value: '1',
            icon: Icons.hourglass_empty,
            color: AppColors.orange,
            subtitle: 'Approval',
          ),
          SummaryCardModel(
            title: 'Used',
            value: '5',
            icon: Icons.event_busy,
            color: AppColors.danger,
            subtitle: 'This year',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Apply Leave',
        primaryActionIcon: Icons.add_circle_outline,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Leave History',
        secondaryActionIcon: Icons.history,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Leave Balance & History',
        featured: const ModuleInfoPanel(
          icon: Icons.policy_outlined,
          title: 'Approval Workflow',
          subtitle:
              'Leave requests are submitted to admin and later used in salary and attendance deduction rules.',
          color: AppColors.info,
        ),
      ),
    );
  }
}
