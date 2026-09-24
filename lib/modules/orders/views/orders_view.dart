import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/orders_controller.dart';
import 'widgets/order_card.dart';
import 'widgets/reject_order_sheet.dart';
import 'widgets/order_status_filter.dart';
import '../../../app/localization/t.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final orders = controller.filteredOrders;

      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
          children: [
            OrderStatusFilter(
              selectedStatus: controller.selectedStatus.value,
              onSelected: (status) => controller.selectedStatus.value = status,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    t('orders.dealer_orders'),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  '${orders.length}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.isLoading.value && orders.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (orders.isEmpty)
              _empty()
            else
              ...orders.map(
                (order) => OrderCard(
                  order: order,
                  forwardingOrderId: controller.forwardingOrderId,
                  onForward: controller.forwardToAdmin,
                  rejectingOrderId: controller.rejectingOrderId,
                  onReject: (order) => showRejectOrderSheet(context, order),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _empty() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 52,
            color: AppColors.mutedGreen,
          ),
          SizedBox(height: 12),
          Text(
            t('orders.no_orders_found'),
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text(
            t('orders.orders_from_dealers_assigned_to_you'),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
