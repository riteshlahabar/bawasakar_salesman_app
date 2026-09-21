import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/salesman_order_model.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/orders_controller.dart';
import 'widgets/order_card.dart';
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
              onSelected: (status) =>
                  controller.selectedStatus.value = status,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    t('orders.dealer_orders'),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
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
                  onReject: (order) => _confirmReject(context, order),
                ),
              ),
          ],
        ),
      );
    });
  }

  void _confirmReject(BuildContext context, SalesmanOrderModel order) {
    final reason = TextEditingController();

    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('orders.reject_order'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              order.orderNo,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reason,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('orders.rejection_reason')),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () {
                  final text = reason.text.trim();
                  if (text.isEmpty) return;
                  Get.back<void>();
                  controller.rejectOrder(order, text);
                },
                child: Text(t('orders.reject_order')),
              ),
            ),
          ],
        ),
      ),
    );
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
