import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/shifts_controller.dart';

class ShiftsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftsController>(
      () => ShiftsController(Get.find<SalesmanHrService>()),
    );
  }
}
