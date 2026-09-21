import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/resignation_controller.dart';

class ResignationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResignationController>(
      () => ResignationController(Get.find<SalesmanHrService>()),
    );
  }
}
