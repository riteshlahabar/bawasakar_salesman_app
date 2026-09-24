import 'package:get/get.dart';

import '../../../app/data/services/file_opener.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../controllers/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(
      () => TrainingController(
        Get.find<SalesmanHrService>(),
        Get.find<FileOpener>(),
      ),
    );
  }
}
