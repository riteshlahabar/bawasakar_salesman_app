import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/salesman_order_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';
import '../../controllers/orders_controller.dart';

/// Asks for a rejection reason, then hands it to [OrdersController.rejectOrder].
///
/// Lives on its own because both the Orders tab and the order detail screen
/// offer Reject — the sheet is the same in either place, so neither owns it.
void showRejectOrderSheet(BuildContext context, SalesmanOrderModel order) {
  final controller = Get.find<OrdersController>();
  final reason = TextEditingController();

  Get.bottomSheet<void>(
    Container(
      padding: const EdgeInsets.all(20),
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
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
