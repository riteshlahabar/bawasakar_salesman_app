import 'package:get/get.dart';

import '../../../app/data/models/salesman_order_model.dart';
import '../../../app/data/services/salesman_order_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../app/localization/t.dart';

class OrdersController
    extends GetxController {
  final SalesmanOrderService _api = Get.find<SalesmanOrderService>();

  final orders =
      <SalesmanOrderModel>[].obs;

  final isLoading = false.obs;

  final forwardingOrderId =
      0.obs;

  final selectedStatus =
      'all'.obs;

  List<SalesmanOrderModel>
      get filteredOrders {
    if (selectedStatus.value ==
        'all') {
      return orders.toList();
    }

    return orders
        .where(
          (order) =>
              order.status ==
              selectedStatus.value,
        )
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
      final result =
          <SalesmanOrderModel>[];

      var page = 1;

      while (true) {
        final response =
            await _api.orders(
          page: page,
          perPage: 100,
        );

        final paginator =
            _extractPaginator(
          response,
        );

        final rows =
            paginator['data'];

        if (rows is! List) {
          break;
        }

        result.addAll(
          rows
              .whereType<Map>()
              .map(
                (item) =>
                    SalesmanOrderModel
                        .fromJson(
                  Map<String, dynamic>
                      .from(
                    item,
                  ),
                ),
              ),
        );

        final lastPage =
            int.tryParse(
                  paginator[
                              'last_page']
                          ?.toString() ??
                      '',
                ) ??
                1;

        if (page >= lastPage ||
            rows.isEmpty) {
          break;
        }

        page++;
      }

      orders.assignAll(
        result,
      );
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

  Future<void> forwardToAdmin(
    SalesmanOrderModel order,
  ) async {
    if (!order.canForwardToAdmin ||
        forwardingOrderId.value !=
            0) {
      return;
    }

    forwardingOrderId.value =
        order.id;

    try {
      await _api
          .forwardOrderToAdmin(
        order.id,
      );

      Get.snackbar(
        t('orders.order_forwarded'),
        t('orders.sent_to_admin', {'order': order.orderNo}),
      );

      await loadOrders();

      if (Get.isRegistered<
          DashboardController>()) {
        await Get.find<
                DashboardController>()
            .loadDashboard();
      }
    } catch (error) {
      Get.snackbar(
        t('orders.unable_to_forward'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      forwardingOrderId.value =
          0;
    }
  }

  Map<String, dynamic>
      _extractPaginator(
    Map<String, dynamic> response,
  ) {
    final rawData =
        response['data'];

    if (rawData is Map) {
      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      final rawOrders =
          data['orders'];

      if (rawOrders is Map) {
        return Map<String, dynamic>.from(
          rawOrders,
        );
      }
    }

    return <String, dynamic>{};
  }
}