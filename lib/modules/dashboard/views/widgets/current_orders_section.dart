import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/section_header.dart';
import '../../../../app/localization/t.dart';
import '../../../main_shell/controllers/main_shell_controller.dart';
import '../../../orders/controllers/orders_controller.dart';
import '../../../orders/views/widgets/order_card.dart';

/// Preview of the salesman's most recent orders, shown on [DashboardView]
/// below the Performance section. Reuses [OrderCard] read-only
/// (`showActions: false`) — the full Orders tab is where Forward/Reject
/// actually happens.
class CurrentOrdersSection extends GetView<OrdersController> {
  const CurrentOrdersSection({super.key});

  static const int _previewCount = 5;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only orders still waiting on this salesman. Once they approve one it
      // becomes admin_review and leaves this list — it is still there in full
      // on the Orders tab.
      final orders = controller.orders
          .where((order) => order.status == 'salesman_review')
          .take(_previewCount)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(title: t('dashboard.current_orders')),
              ),
              GestureDetector(
                onTap: () {
                  if (Get.isRegistered<MainShellController>()) {
                    Get.find<MainShellController>().changeTab(2);
                  }
                },
                child: Text(
                  t('dashboard.view_all'),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (controller.isLoading.value && orders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  t('orders.no_orders_found'),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            ...orders.map(
              (order) => OrderCard(order: order, showActions: false),
            ),
        ],
      );
    });
  }
}
