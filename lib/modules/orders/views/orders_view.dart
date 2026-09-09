import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/salesman_order_model.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/orders_controller.dart';

class OrdersView
    extends GetView<OrdersController> {
  const OrdersView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Obx(() {
      final orders =
          controller.filteredOrders;

      return RefreshIndicator(
        onRefresh:
            controller.loadOrders,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            110,
          ),
          children: [
            _statusFilter(),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Dealer Orders',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight
                              .w900,
                    ),
                  ),
                ),
                Text(
                  '${orders.length}',
                  style:
                      const TextStyle(
                    color:
                        AppColors.primary,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            if (controller
                    .isLoading.value &&
                orders.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.all(
                  30,
                ),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )
            else if (orders.isEmpty)
              _empty()
            else
              ...orders.map(
                _orderCard,
              ),
          ],
        ),
      );
    });
  }

  Widget _statusFilter() {
    const statuses =
        <String, String>{
      'all': 'All',
      'salesman_review':
          'My Review',
      'admin_review':
          'Admin Review',
      'approved':
          'Approved',
      'packing':
          'Packing',
      'dispatched':
          'Dispatched',
      'delivered':
          'Delivered',
      'cancelled':
          'Cancelled',
    };

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,
        itemCount:
            statuses.length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 8,
        ),
        itemBuilder:
            (_, index) {
          final entry =
              statuses.entries
                  .elementAt(
            index,
          );

          final selected =
              controller
                      .selectedStatus
                      .value ==
                  entry.key;

          return ChoiceChip(
            selected:
                selected,
            label:
                Text(
              entry.value,
            ),
            onSelected: (_) {
              controller
                      .selectedStatus
                      .value =
                  entry.key;
            },
            selectedColor:
                AppColors
                    .primarySoft,
            side:
                BorderSide(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
            labelStyle:
                TextStyle(
              color: selected
                  ? AppColors.primary
                  : AppColors
                      .textSecondary,
              fontSize: 11,
              fontWeight:
                  FontWeight
                      .w700,
            ),
          );
        },
      ),
    );
  }

  Widget _orderCard(
    SalesmanOrderModel order,
  ) {
    final color =
        _statusColor(
      order.status,
    );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  color: color
                      .withValues(
                    alpha: .10,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    13,
                  ),
                ),
                child: Icon(
                  Icons
                      .receipt_long_rounded,
                  color: color,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      order.orderNo,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      order.dealerName,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 11.5,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '₹${order.grandTotal.toStringAsFixed(0)}',
                style:
                    const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          Row(
            children: [
              const Icon(
                Icons
                    .inventory_2_outlined,
                size: 16,
                color: AppColors
                    .textSecondary,
              ),

              const SizedBox(
                width: 6,
              ),

              Text(
                '${order.itemCount} items',
                style:
                    const TextStyle(
                  fontSize: 11,
                  color: AppColors
                      .textSecondary,
                ),
              ),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color: color
                      .withValues(
                    alpha: .10,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),
                child: Text(
                  _statusText(
                    order.status,
                  ),
                  style:
                      TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),
              ),
            ],
          ),

          if (order.canForwardToAdmin) ...[
            const SizedBox(
              height: 14,
            ),

            Obx(
              () {
                final loading =
                    controller
                            .forwardingOrderId
                            .value ==
                        order.id;

                return SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton.icon(
                    onPressed: loading
                        ? null
                        : () {
                            controller
                                .forwardToAdmin(
                              order,
                            );
                          },
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons
                                .forward_to_inbox_outlined,
                          ),
                    label: Text(
                      loading
                          ? 'Forwarding...'
                          : 'Forward to Admin',
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(
    String status,
  ) {
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
        return AppColors
            .textSecondary;
    }
  }

  String _statusText(
    String status,
  ) {
    return status
        .split('_')
        .map(
          (word) {
            if (word.isEmpty) {
              return '';
            }

            return '${word[0].toUpperCase()}${word.substring(1)}';
          },
        )
        .join(' ');
  }

  Widget _empty() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons
                .receipt_long_outlined,
            size: 52,
            color:
                AppColors.mutedGreen,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Orders from dealers assigned to you will appear here.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}