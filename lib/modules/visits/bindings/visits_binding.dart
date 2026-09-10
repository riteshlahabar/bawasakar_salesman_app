import 'package:get/get.dart';

import '../../../app/data/services/salesman_attendance_service.dart';
import '../controllers/visits_controller.dart';

class VisitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitsController>(
      () => VisitsController(Get.find<SalesmanAttendanceService>()),
    );
  }
}
