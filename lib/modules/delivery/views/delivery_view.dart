import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/delivery_controller.dart';

class DeliveryView extends GetView<DeliveryController> {
  const DeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Packed',
            value: '18',
            icon: Icons.inventory,
            color: AppColors.orange,
            subtitle: 'Orders',
          ),
          SummaryCardModel(
            title: 'Dispatched',
            value: '42',
            icon: Icons.local_shipping,
            color: AppColors.primary,
            subtitle: 'Orders',
          ),
          SummaryCardModel(
            title: 'Delivered',
            value: '36',
            icon: Icons.task_alt,
            color: AppColors.success,
            subtitle: 'Orders',
          ),
          SummaryCardModel(
            title: 'Failed',
            value: '2',
            icon: Icons.report_problem,
            color: AppColors.danger,
            subtitle: 'Follow-up',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Track Order',
        primaryActionIcon: Icons.local_shipping,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Proof Details',
        secondaryActionIcon: Icons.image_outlined,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Delivery Updates',
        featured: const ModuleInfoPanel(
          icon: Icons.pin_drop_outlined,
          title: 'Dealer Delivery Follow-up',
          subtitle:
              'Track packing, dispatch, LR/courier number, expected delivery date, proof upload, and failed delivery reasons.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
