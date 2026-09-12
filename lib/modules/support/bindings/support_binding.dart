import 'package:get/get.dart';

import '../../../app/data/services/salesman_auth_service.dart';
import '../controllers/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(
      () => SupportController(Get.find<SalesmanAuthService>()),
    );
  }
}
