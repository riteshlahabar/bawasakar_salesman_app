import 'package:get/get.dart';

import '../../collections/controllers/collections_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dealers/controllers/dealers_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../controllers/main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(MainShellController.new);

    Get.lazyPut<DashboardController>(DashboardController.new, fenix: true);

    Get.lazyPut<DealersController>(DealersController.new, fenix: true);

    Get.lazyPut<OrdersController>(OrdersController.new, fenix: true);

    Get.lazyPut<CollectionsController>(CollectionsController.new, fenix: true);
  }
}
