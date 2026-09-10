import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/assets_controller.dart';

class AssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetsController>(
      () => AssetsController(Get.find<SalesmanHrService>()),
    );
  }
}
