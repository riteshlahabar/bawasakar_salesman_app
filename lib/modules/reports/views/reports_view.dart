import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Sales',
            value: 'â‚¹8.4L',
            icon: Icons.bar_chart,
            color: AppColors.primary,
            subtitle: 'Month',
          ),
          SummaryCardModel(
            title: 'Collection',
            value: 'â‚¹4.8L',
            icon: Icons.payments,
            color: AppColors.success,
            subtitle: 'Month',
          ),
          SummaryCardModel(
            title: 'Orders',
            value: '126',
            icon: Icons.receipt_long,
            color: AppColors.info,
            subtitle: 'Month',
          ),
          SummaryCardModel(
            title: 'Reports',
            value: '12',
            icon: Icons.folder,
            color: AppColors.orange,
            subtitle: 'Ready',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Download PDF',
        primaryActionIcon: Icons.picture_as_pdf,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Export Excel',
        secondaryActionIcon: Icons.table_chart,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Available Reports',
        featured: const ModuleInfoPanel(
          icon: Icons.filter_alt_outlined,
          title: 'Report Filters',
          subtitle:
              'Date range, dealer, product, route, order status, collection type, and salesman filters will be supported.',
          color: AppColors.info,
        ),
      ),
    );
  }
}
