import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/holidays_controller.dart';

class HolidaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HolidaysController>(
      () => HolidaysController(Get.find<SalesmanHrService>()),
    );
  }
}
