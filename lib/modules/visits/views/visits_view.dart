import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/visits_controller.dart';

class VisitsView extends GetView<VisitsController> {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Planned',
            value: '18',
            icon: Icons.route,
            color: AppColors.primary,
            subtitle: 'Today',
          ),
          SummaryCardModel(
            title: 'Completed',
            value: '14',
            icon: Icons.task_alt,
            color: AppColors.success,
            subtitle: 'Synced',
          ),
          SummaryCardModel(
            title: 'Pending',
            value: '4',
            icon: Icons.schedule,
            color: AppColors.orange,
            subtitle: 'Remaining',
          ),
          SummaryCardModel(
            title: 'Distance',
            value: '82 km',
            icon: Icons.map,
            color: AppColors.info,
            subtitle: 'Route',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Start Visit',
        primaryActionIcon: Icons.add_location_alt,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Route Map',
        secondaryActionIcon: Icons.map_outlined,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Today Dealer Route',
        featured: const ModuleInfoPanel(
          icon: Icons.storefront_outlined,
          title: 'Next Visit: Shree Agro Center',
          subtitle:
              'Purpose: outstanding follow-up, new order discussion, and product scheme update.',
          color: AppColors.orange,
        ),
      ),
    );
  }
}
