import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/targets_controller.dart';

class TargetsView extends GetView<TargetsController> {
  const TargetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Sales',
            value: '70%',
            icon: Icons.flag,
            color: AppColors.success,
            subtitle: 'â‚¹8.4L / â‚¹12L',
          ),
          SummaryCardModel(
            title: 'Collection',
            value: '69%',
            icon: Icons.payments,
            color: AppColors.orange,
            subtitle: 'â‚¹4.8L / â‚¹7L',
          ),
          SummaryCardModel(
            title: 'Dealers',
            value: '3/5',
            icon: Icons.group_add,
            color: AppColors.info,
            subtitle: 'Activated',
          ),
          SummaryCardModel(
            title: 'Commission',
            value: 'â‚¹6.8K',
            icon: Icons.workspace_premium,
            color: AppColors.primary,
            subtitle: 'Projected',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'View Targets',
        primaryActionIcon: Icons.flag_outlined,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Commission',
        secondaryActionIcon: Icons.workspace_premium_outlined,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Target Progress',
        featured: const ModuleInfoPanel(
          icon: Icons.insights_outlined,
          title: 'Commission Linked Target',
          subtitle:
              'Sales and collection achievements calculate monthly incentive and commission slabs.',
          color: AppColors.success,
        ),
      ),
    );
  }
}
