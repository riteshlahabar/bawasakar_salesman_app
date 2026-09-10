import 'package:get/get.dart';

import '../../../app/data/services/salesman_attendance_service.dart';
import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(Get.find<SalesmanAttendanceService>()),
    );
  }
}
