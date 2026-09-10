import 'package:get/get.dart';

import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/documents_controller.dart';

class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentsController>(
      () => DocumentsController(Get.find<SalesmanHrService>()),
    );
  }
}
