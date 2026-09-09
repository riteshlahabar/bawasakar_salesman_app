import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/tour_plan_controller.dart';

class TourPlanView extends GetView<TourPlanController> {
  const TourPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Routes',
            value: '3',
            icon: Icons.map,
            color: AppColors.primary,
            subtitle: 'This week',
          ),
          SummaryCardModel(
            title: 'Dealers',
            value: '24',
            icon: Icons.storefront,
            color: AppColors.success,
            subtitle: 'Scheduled',
          ),
          SummaryCardModel(
            title: 'Distance',
            value: '312 km',
            icon: Icons.route,
            color: AppColors.info,
            subtitle: 'Planned',
          ),
          SummaryCardModel(
            title: 'Pending',
            value: '1',
            icon: Icons.hourglass_empty,
            color: AppColors.orange,
            subtitle: 'Approval',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Create Plan',
        primaryActionIcon: Icons.add_road,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Map View',
        secondaryActionIcon: Icons.map_outlined,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Upcoming Routes',
        featured: const ModuleInfoPanel(
          icon: Icons.route_outlined,
          title: 'Tomorrow: Pune Rural Route',
          subtitle:
              '9 dealers, 146 km, pending admin approval before field execution.',
          color: AppColors.orange,
        ),
      ),
    );
  }
}
