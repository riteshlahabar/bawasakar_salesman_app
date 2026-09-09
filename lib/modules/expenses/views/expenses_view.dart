import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/expenses_controller.dart';

class ExpensesView extends GetView<ExpensesController> {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Claimed',
            value: 'â‚¹8,240',
            icon: Icons.receipt_long,
            color: AppColors.primary,
            subtitle: 'This month',
          ),
          SummaryCardModel(
            title: 'Pending',
            value: 'â‚¹1,250',
            icon: Icons.hourglass_top,
            color: AppColors.orange,
            subtitle: 'Approval',
          ),
          SummaryCardModel(
            title: 'Approved',
            value: 'â‚¹6,491',
            icon: Icons.verified,
            color: AppColors.success,
            subtitle: 'Paid/ready',
          ),
          SummaryCardModel(
            title: 'Drafts',
            value: '2',
            icon: Icons.edit_note,
            color: AppColors.info,
            subtitle: 'Offline',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Add Expense',
        primaryActionIcon: Icons.add_card,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Upload Receipt',
        secondaryActionIcon: Icons.upload_file,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Expense Claims',
        featured: const ModuleInfoPanel(
          icon: Icons.camera_alt_outlined,
          title: 'Receipt Upload Required',
          subtitle:
              'Travel, fuel, hotel, and food claims should include photo proof before admin approval.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
