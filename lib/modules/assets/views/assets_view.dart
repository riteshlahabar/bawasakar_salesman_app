import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/assets_controller.dart';

class AssetsView extends GetView<AssetsController> {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Issued',
            value: '6',
            icon: Icons.inventory_2,
            color: AppColors.primary,
            subtitle: 'Assets',
          ),
          SummaryCardModel(
            title: 'Value',
            value: 'â‚¹42K',
            icon: Icons.currency_rupee,
            color: AppColors.success,
            subtitle: 'Company',
          ),
          SummaryCardModel(
            title: 'Pending',
            value: '1',
            icon: Icons.assignment_late,
            color: AppColors.orange,
            subtitle: 'Return',
          ),
          SummaryCardModel(
            title: 'Damaged',
            value: '0',
            icon: Icons.report,
            color: AppColors.info,
            subtitle: 'Current',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Acknowledge',
        primaryActionIcon: Icons.assignment_turned_in,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Return Asset',
        secondaryActionIcon: Icons.keyboard_return,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Assigned Assets',
        featured: const ModuleInfoPanel(
          icon: Icons.verified_user_outlined,
          title: 'Exit Settlement Ready',
          subtitle:
              'Issued laptop, mobile, SIM, bag, ID card, and samples will be checked during final settlement.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
