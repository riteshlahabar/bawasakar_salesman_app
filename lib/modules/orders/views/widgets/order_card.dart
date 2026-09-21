import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/salesman_order_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Single dealer order card for [OrdersView], including the
/// "Forward to Admin" action for orders awaiting salesman review.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.forwardingOrderId,
    required this.onForward,
    required this.rejectingOrderId,
    required this.onReject,
  });

  final SalesmanOrderModel order;
  final RxInt forwardingOrderId;
  final void Function(SalesmanOrderModel order) onForward;
  final RxInt rejectingOrderId;
  final void Function(SalesmanOrderModel order) onReject;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(Icons.receipt_long_rounded, color: color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.dealerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${order.grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                t('orders.item_count', {'n': '${order.itemCount}'}),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText(order.status),
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (order.canForwardToAdmin) ...[
            const SizedBox(height: 14),
            Obx(() {
              final forwarding = forwardingOrderId.value == order.id;
              final rejecting = rejectingOrderId.value == order.id;
              final busy = forwarding || rejecting;

              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : () => onReject(order),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                      icon: rejecting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger),
                            )
                          : const Icon(Icons.close_rounded, size: 18),
                      label: Text(rejecting ? t('orders.rejecting') : t('orders.reject')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: busy ? null : () => onForward(order),
                      icon: forwarding
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.forward_to_inbox_outlined, size: 18),
                      label: Text(forwarding ? t('orders.forwarding') : t('orders.forward_to_admin')),
                    ),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'salesman_review':
        return AppColors.accent;
      case 'admin_review':
        return AppColors.info;
      case 'approved':
        return AppColors.primary;
      case 'packing':
        return AppColors.orange;
      case 'dispatched':
        return AppColors.info;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  String _statusText(String status) {
    return status
        .split('_')
        .map((word) {
          if (word.isEmpty) {
            return '';
          }

          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }
}
