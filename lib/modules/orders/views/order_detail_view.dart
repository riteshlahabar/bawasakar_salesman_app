import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/data/models/salesman_order_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/product_image.dart';
import '../../../app/localization/t.dart';
import '../controllers/orders_controller.dart';
import 'widgets/order_status_style.dart';
import 'widgets/reject_order_sheet.dart';

/// Everything recorded against one order — firm and contact details, the
/// item lines, the money breakdown, notes and payment — reached by tapping a
/// card on either the Orders tab or the dashboard's Current Orders preview.
///
/// The order arrives as a route argument rather than through a second API
/// call: the list endpoint already returns the full order, items included.
/// It is then re-read from [OrdersController.orders] on every rebuild so a
/// Forward or Reject done here shows its new status immediately.
class OrderDetailView extends GetView<OrdersController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;
    if (argument is! SalesmanOrderModel) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t('orders.order_details')),
          leading: const DrawerMenuButton(),
        ),
        body: Center(child: Text(t('common.could_not_load'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t('orders.order_details')),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(() {
        final order =
            controller.orders.firstWhereOrNull(
              (row) => row.id == argument.id,
            ) ??
            argument;
        final color = orderStatusColor(order.status);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            _header(order, color),
            if (order.availability.isNotEmpty) ...[
              const SizedBox(height: 14),
              _availabilityBanner(order),
            ],
            const SizedBox(height: 14),
            _section(
              title: t('orders.firm_and_contact'),
              icon: Icons.storefront_outlined,
              children: [
                _row(t('orders.firm_name'), order.dealerName),
                _row(t('orders.contact_person'), order.contactPerson),
                _row(t('orders.contact_number'), order.dealerMobile),
                _row(t('orders.delivery_address'), order.dealerAddress),
              ],
            ),
            const SizedBox(height: 14),
            _items(order),
            const SizedBox(height: 14),
            _summary(order),
            if (order.notes.isNotEmpty ||
                order.paymentMethod.isNotEmpty ||
                order.paymentStatus.isNotEmpty) ...[
              const SizedBox(height: 14),
              _section(
                title: t('orders.payment_and_notes'),
                icon: Icons.sticky_note_2_outlined,
                children: [
                  _row(t('orders.payment_method'), _label(order.paymentMethod)),
                  _row(t('orders.payment_status'), _label(order.paymentStatus)),
                  _row(t('orders.order_notes'), order.notes),
                ],
              ),
            ],
            if (order.canForwardToAdmin) ...[
              const SizedBox(height: 20),
              _actions(context, order),
            ],
          ],
        );
      }),
    );
  }

  /// Order number, date and status at a glance, in the status colour.
  Widget _header(SalesmanOrderModel order, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.softCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderDate,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${order.grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reminds the salesman what they last told the dealer about stock. It is
  /// only a note — the order is still theirs to approve or cancel.
  Widget _availabilityBanner(SalesmanOrderModel order) {
    final waiting = order.availability == 'available_on';
    final color = waiting ? AppColors.info : AppColors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          Icon(
            waiting
                ? Icons.event_available_outlined
                : Icons.remove_shopping_cart_outlined,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              waiting
                  ? t('orders.marked_available_on_short', {
                      'date': order.availableOnLabel,
                    })
                  : t('orders.marked_not_available_short'),
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(SalesmanOrderModel order) {
    if (order.items.isEmpty) {
      return _section(
        title: t('orders.order_items'),
        icon: Icons.inventory_2_outlined,
        children: [
          Text(
            t('orders.item_count', {'n': '${order.itemCount}'}),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    return _section(
      title: '${t('orders.order_items')} (${order.items.length})',
      icon: Icons.inventory_2_outlined,
      children: [
        for (var index = 0; index < order.items.length; index++) ...[
          if (index > 0) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            const SizedBox(height: 10),
          ],
          _itemRow(order.items[index]),
        ],
      ],
    );
  }

  /// Thumbnail, then the product with its pack size, then the case-wise
  /// quantity ("2 cases × 10 units") and the rate per case — dealers order
  /// in cases, so a bare unit count would not match what they chose.
  Widget _itemRow(SalesmanOrderItemModel item) {
    final subtitle = [
      if (item.variantName.isNotEmpty) item.variantName,
      if (item.gstPercent > 0) 'GST ${item.gstPercent.toStringAsFixed(0)}%',
    ].join('  •  ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ProductImage(imageUrl: item.imageUrl, width: 46, height: 46),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 3),
              Text(
                '${item.caseLabel} = ${item.totalUnitsLabel}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${item.lineTotal.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '₹${item.casePrice.toStringAsFixed(0)}/case',
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summary(SalesmanOrderModel order) {
    return _section(
      title: t('orders.price_summary'),
      icon: Icons.calculate_outlined,
      children: [
        _money(t('orders.subtotal'), order.subtotal),
        if (order.discountTotal > 0)
          _money(
            t('orders.discount'),
            -order.discountTotal,
            color: AppColors.success,
          ),
        _money(t('orders.gst'), order.gstTotal),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: AppColors.border),
        const SizedBox(height: 10),
        _money(t('orders.grand_total'), order.grandTotal, emphasise: true),
      ],
    );
  }

  /// The salesman's four decisions on an order still in their review, in two
  /// rows: the two stock answers first (they leave the order where it is),
  /// then the two that settle it — Cancel Order and Approved.
  Widget _actions(BuildContext context, SalesmanOrderModel order) {
    final forwarding = controller.forwardingOrderId.value == order.id;
    final rejecting = controller.rejectingOrderId.value == order.id;
    final marking = controller.markingOrderId.value == order.id;
    final busy = forwarding || rejecting || marking;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy
                    ? null
                    : () => controller.markAvailability(order, 'not_available'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                icon: const Icon(Icons.remove_shopping_cart_outlined, size: 17),
                label: Text(t('orders.not_available_now')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy ? null : () => _pickAvailableOn(context, order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.info,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                icon: const Icon(Icons.event_available_outlined, size: 17),
                label: Text(t('orders.available_on')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy
                    ? null
                    : () => showRejectOrderSheet(context, order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  padding: const EdgeInsets.symmetric(vertical: 13),
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
                    : const Icon(Icons.close_rounded, size: 17),
                label: Text(
                  rejecting ? t('orders.cancelling') : t('orders.cancel_order'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: busy ? null : () => controller.forwardToAdmin(order),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                icon: forwarding
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 17),
                label: Text(
                  forwarding ? t('orders.approving') : t('orders.approved'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Date then time, both in the app's own theme, before sending the promise
  /// to the server. Cancelling either step abandons the whole action.
  Future<void> _pickAvailableOn(
    BuildContext context,
    SalesmanOrderModel order,
  ) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: order.availableOn ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        order.availableOn ?? now.add(const Duration(hours: 1)),
      ),
    );

    if (time == null) return;

    final availableOn = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (!availableOn.isAfter(DateTime.now())) {
      Get.snackbar(
        t('orders.unable_to_update_availability'),
        t('orders.available_on_must_be_future'),
      );

      return;
    }

    await controller.markAvailability(
      order,
      'available_on',
      availableOn: availableOn,
    );
  }

  /// White card with a small icon heading, used for every block on the page.
  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.softCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// Label on the left, value on the right. Rows with nothing to show are
  /// left out rather than printed blank.
  Widget _row(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _money(
    String label,
    double amount, {
    bool emphasise = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: emphasise ? 0 : 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: emphasise ? 13 : 11.5,
                fontWeight: emphasise ? FontWeight.w900 : FontWeight.w400,
                color: emphasise
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: emphasise ? 14 : 12,
              fontWeight: FontWeight.w900,
              color:
                  color ??
                  (emphasise ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// "cod" → "COD", "pending" → "Pending". Short words are acronyms here
  /// (COD, GST), so they read better fully capitalised; `credit` gets the
  /// dealer app's own wording so both apps name the same thing the same way.
  String _label(String value) {
    if (value.isEmpty) return '';

    if (value.toLowerCase() == 'credit') return t('orders.pay_later_credit');

    if (value.toLowerCase() == 'cod') return t('orders.cash_upi_collection');

    return value
        .split(RegExp(r'[_\s]+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word.length <= 3
              ? word.toUpperCase()
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
