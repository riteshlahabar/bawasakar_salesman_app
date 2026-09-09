import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class NotificationsController extends ModuleController {
  NotificationsController()
    : super(
        title: 'Notifications',
        subtitle:
            'Admin alerts, order status, price change, sync updates, target alerts, and delivery notifications.',
        actionLabel: 'Mark All Read',
        actionIcon: Icons.done_all,
        initialRows: const [
          ListRowModel(
            title: 'Price Updated',
            subtitle: 'Dealer price list updated for 24 products',
            trailing: 'Now',
            icon: Icons.sell,
            status: 'Sync',
            color: AppColors.primary,
          ),
          ListRowModel(
            title: 'Order Approved',
            subtitle: 'ORD-24070 approved by admin and moved to packing',
            trailing: '15m',
            icon: Icons.verified,
            status: 'Order',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Collection Due',
            subtitle: 'Shree Agro Center follow-up required today',
            trailing: '1h',
            icon: Icons.notifications_active,
            status: 'Due',
            color: AppColors.danger,
          ),
        ],
      );
}
