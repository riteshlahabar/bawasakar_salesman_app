import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/salesman_order_model.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';
import 'order_status_style.dart';

/// Single dealer order card for [OrdersView], including the
/// "Forward to Admin" action for orders awaiting salesman review.
///
/// Also reused as a read-only preview on the dashboard's Current Orders
/// section via `showActions: false`, which skips the action row (and its
/// otherwise-required callbacks) regardless of [SalesmanOrderModel.canForwardToAdmin].
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.showActions = true,
    this.forwardingOrderId,
    this.onForward,
    this.rejectingOrderId,
    this.onReject,
  });

  final SalesmanOrderModel order;
  final bool showActions;
  final RxInt? forwardingOrderId;
  final void Function(SalesmanOrderModel order)? onForward;
  final RxInt? rejectingOrderId;
  final void Function(SalesmanOrderModel order)? onReject;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      // Transparent Material so the tap ripple is visible over the card's own
      // white background instead of being painted under it.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () =>
              Get.toNamed<void>(AppRoutes.orderDetail, arguments: order),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.dealerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.orderNo,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Mirrors the left column: the heading line (status) on top,
                    // its supporting line (the amount) underneath.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            orderStatusText(order.status),
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
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
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: AppColors.border),
                const SizedBox(height: 10),
                // Contact and date share one line, then address and items take a
                // full line each — keeps every detail on the card while adding only
                // three short rows to its height.
                Row(
                  children: [
                    if (order.dealerMobile.isNotEmpty)
                      Expanded(
                        child: _DetailLine(
                          icon: Icons.call_outlined,
                          text: order.dealerMobile,
                        ),
                      ),
                    if (order.orderDate.isNotEmpty)
                      _DetailLine(
                        icon: Icons.event_outlined,
                        text: order.orderDate,
                      ),
                  ],
                ),
                if (order.dealerAddress.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _DetailLine(
                    icon: Icons.location_on_outlined,
                    text: order.dealerAddress,
                  ),
                ],
                const SizedBox(height: 6),
                _DetailLine(
                  icon: Icons.inventory_2_outlined,
                  text: order.productSummary.isEmpty
                      ? t('orders.item_count', {'n': '${order.itemCount}'})
                      : '${order.productSummary}  •  ${t('orders.item_count', {'n': '${order.itemCount}'})}',
                ),
                // What the salesman last told the dealer about stock, if anything.
                if (order.availability.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _DetailLine(
                    icon: order.availability == 'available_on'
                        ? Icons.event_available_outlined
                        : Icons.remove_shopping_cart_outlined,
                    color: order.availability == 'available_on'
                        ? AppColors.info
                        : AppColors.orange,
                    text: order.availability == 'available_on'
                        ? t('orders.marked_available_on_short', {
                            'date': order.availableOnLabel,
                          })
                        : t('orders.marked_not_available_short'),
                  ),
                ],
                if (showActions && order.canForwardToAdmin) ...[
                  const SizedBox(height: 14),
                  Obx(() {
                    final forwarding = forwardingOrderId!.value == order.id;
                    final rejecting = rejectingOrderId!.value == order.id;
                    final busy = forwarding || rejecting;

                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: busy ? null : () => onReject!(order),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                            ),
                            icon: rejecting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.danger,
                                    ),
                                  )
                                : const Icon(Icons.close_rounded, size: 18),
                            label: Text(
                              rejecting
                                  ? t('orders.rejecting')
                                  : t('orders.reject'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: busy ? null : () => onForward!(order),
                            icon: forwarding
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.forward_to_inbox_outlined,
                                    size: 18,
                                  ),
                            label: Text(
                              forwarding
                                  ? t('orders.forwarding')
                                  : t('orders.forward_to_admin'),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One compact `icon + text` detail row inside [OrderCard] — contact number,
/// order date, address or item summary. Kept to a single ellipsized line so
/// adding a detail never grows the card by more than ~20px.
class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;

  /// Overrides the usual grey — used to make the stock note stand out.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: tone),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: tone,
              fontWeight: color == null ? FontWeight.w600 : FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
