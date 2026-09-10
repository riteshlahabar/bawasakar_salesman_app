import 'package:get/get.dart';

import '../../../app/data/services/salesman_attendance_service.dart';
import '../controllers/tour_plan_controller.dart';

class TourPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TourPlanController>(
      () => TourPlanController(Get.find<SalesmanAttendanceService>()),
    );
  }
}
