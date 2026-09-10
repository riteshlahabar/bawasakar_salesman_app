import 'package:get/get.dart';

import '../../../app/data/services/salesman_dashboard_service.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(Get.find<SalesmanDashboardService>()),
    );
  }
}
