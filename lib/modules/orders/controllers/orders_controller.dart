import 'package:get/get.dart';

import '../../../app/data/models/salesman_order_model.dart';
import '../../../app/data/services/salesman_order_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../app/localization/t.dart';

class OrdersController extends GetxController {
  final SalesmanOrderService _api = Get.find<SalesmanOrderService>();

  final orders = <SalesmanOrderModel>[].obs;

  final isLoading = false.obs;

  final forwardingOrderId = 0.obs;

  final rejectingOrderId = 0.obs;

  final markingOrderId = 0.obs;

  final selectedStatus = 'all'.obs;

  List<SalesmanOrderModel> get filteredOrders {
    if (selectedStatus.value == 'all') {
      return orders.toList();
    }

    return orders
        .where((order) => order.status == selectedStatus.value)
        .toList();
  }

  @override
  void onReady() {
    super.onReady();

    loadOrders();
  }

  Future<void> loadOrders() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result = <SalesmanOrderModel>[];

      var page = 1;

      while (true) {
        final response = await _api.orders(page: page, perPage: 100);

        final paginator = _extractPaginator(response);

        final rows = paginator['data'];

        if (rows is! List) {
          break;
        }

        result.addAll(
          rows.whereType<Map>().map(
            (item) =>
                SalesmanOrderModel.fromJson(Map<String, dynamic>.from(item)),
          ),
        );

        final lastPage =
            int.tryParse(paginator['last_page']?.toString() ?? '') ?? 1;

        if (page >= lastPage || rows.isEmpty) {
          break;
        }

        page++;
      }

      orders.assignAll(result);
    } catch (error) {
      orders.clear();

      Get.snackbar(
        t('common.orders'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forwardToAdmin(SalesmanOrderModel order) async {
    if (!order.canForwardToAdmin || forwardingOrderId.value != 0) {
      return;
    }

    forwardingOrderId.value = order.id;

    try {
      await _api.forwardOrderToAdmin(order.id);

      Get.snackbar(
        t('orders.order_forwarded'),
        t('orders.sent_to_admin', {'order': order.orderNo}),
      );

      await loadOrders();

      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().loadDashboard();
      }
    } catch (error) {
      Get.snackbar(
        t('orders.unable_to_forward'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      forwardingOrderId.value = 0;
    }
  }

  /// Records "not available now" or "available on `<date>`" against an order
  /// still in salesman review. The order does not move — only the stock note
  /// changes — so the Approve and Cancel actions stay available afterwards.
  Future<void> markAvailability(
    SalesmanOrderModel order,
    String availability, {
    DateTime? availableOn,
  }) async {
    if (!order.canForwardToAdmin || markingOrderId.value != 0) {
      return;
    }

    markingOrderId.value = order.id;

    try {
      await _api.setOrderAvailability(
        order.id,
        availability,
        availableOn: availableOn,
      );

      Get.snackbar(
        t('orders.availability_updated'),
        availableOn == null
            ? t('orders.marked_not_available', {'order': order.orderNo})
            : t('orders.marked_available_on', {
                'order': order.orderNo,
                'date': SalesmanOrderModel.formatDateTime(availableOn),
              }),
      );

      await loadOrders();
    } catch (error) {
      Get.snackbar(
        t('orders.unable_to_update_availability'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      markingOrderId.value = 0;
    }
  }

  Future<void> rejectOrder(SalesmanOrderModel order, String reason) async {
    if (!order.canReject || rejectingOrderId.value != 0) {
      return;
    }

    rejectingOrderId.value = order.id;

    try {
      await _api.rejectOrder(order.id, reason);

      Get.snackbar(
        t('orders.order_rejected'),
        t('orders.order_rejected_message', {'order': order.orderNo}),
      );

      await loadOrders();

      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().loadDashboard();
      }
    } catch (error) {
      Get.snackbar(
        t('orders.unable_to_reject'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      rejectingOrderId.value = 0;
    }
  }

  Map<String, dynamic> _extractPaginator(Map<String, dynamic> response) {
    final rawData = response['data'];

    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);

      final rawOrders = data['orders'];

      if (rawOrders is Map) {
        return Map<String, dynamic>.from(rawOrders);
      }
    }

    return <String, dynamic>{};
  }
}
