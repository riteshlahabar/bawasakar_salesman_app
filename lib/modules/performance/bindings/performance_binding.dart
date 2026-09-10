import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/performance_controller.dart';

class PerformanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerformanceController>(
      () => PerformanceController(Get.find<SalesmanHrService>()),
    );
  }
}
