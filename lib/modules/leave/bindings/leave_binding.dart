import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/leave_controller.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(
      () => LeaveController(Get.find<SalesmanHrService>()),
    );
  }
}
