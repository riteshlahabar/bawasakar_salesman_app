import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/announcements_controller.dart';

class AnnouncementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnnouncementsController>(
      () => AnnouncementsController(Get.find<SalesmanHrService>()),
    );
  }
}
