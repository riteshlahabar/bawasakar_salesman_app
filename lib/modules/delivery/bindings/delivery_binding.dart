import 'package:get/get.dart';

import '../../../app/data/services/salesman_order_service.dart';
import '../controllers/delivery_controller.dart';

class DeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryController>(
      () => DeliveryController(Get.find<SalesmanOrderService>()),
    );
  }
}
