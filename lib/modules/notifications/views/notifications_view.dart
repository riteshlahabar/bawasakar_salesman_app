import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/field_module_view.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FieldModuleView(
        title: controller.title,
        subtitle: controller.subtitle,
        stats: const [
          SummaryCardModel(
            title: 'Unread',
            value: '8',
            icon: Icons.notifications_active,
            color: AppColors.danger,
            subtitle: 'Alerts',
          ),
          SummaryCardModel(
            title: 'Orders',
            value: '3',
            icon: Icons.receipt_long,
            color: AppColors.primary,
            subtitle: 'Updates',
          ),
          SummaryCardModel(
            title: 'Sync',
            value: '2',
            icon: Icons.sync,
            color: AppColors.info,
            subtitle: 'Messages',
          ),
          SummaryCardModel(
            title: 'Due',
            value: '3',
            icon: Icons.schedule,
            color: AppColors.orange,
            subtitle: 'Follow-up',
          ),
        ],
        rows: controller.rows.toList(),
        primaryActionLabel: 'Mark All Read',
        primaryActionIcon: Icons.done_all,
        onPrimaryAction: controller.primaryAction,
        secondaryActionLabel: 'Settings',
        secondaryActionIcon: Icons.settings,
        onSecondaryAction: controller.primaryAction,
        recordsTitle: 'Latest Notifications',
        featured: const ModuleInfoPanel(
          icon: Icons.campaign_outlined,
          title: 'Admin Broadcasts',
          subtitle:
              'Price updates, schemes, order approvals, and urgent collection follow-ups appear here.',
          color: AppColors.primary,
        ),
      ),
    );
  }
}
