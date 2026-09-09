import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/salary_controller.dart';

class SalaryView extends GetView<SalaryController> {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Net Salary',
            value: 'â‚¹38.4K',
            icon: Icons.currency_rupee,
            color: AppColors.success,
            subtitle: 'July',
          ),
          SummaryCardModel(
            title: 'Incentive',
            value: 'â‚¹6.8K',
            icon: Icons.trending_up,
            color: AppColors.primary,
            subtitle: 'Earned',
          ),
          SummaryCardModel(
            title: 'Deduction',
            value: 'â‚¹2K',
            icon: Icons.remove_circle,
            color: AppColors.danger,
            subtitle: 'Advance',
          ),
          SummaryCardModel(
            title: 'Payslips',
            value: '6',
            icon: Icons.description,
            color: AppColors.info,
            subtitle: 'Available',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'View Payslip',
        primaryActionIcon: Icons.description_outlined,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Salary History',
        secondaryActionIcon: Icons.history,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Salary Components',
        featured: const ModuleInfoPanel(
          icon: Icons.payments_outlined,
          title: 'Salary Calculation',
          subtitle:
              'Basic salary, allowance, bonus, commission, leave deduction, attendance deduction, advance, and loan are tracked here.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
