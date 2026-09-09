import 'package:get/get.dart';
import '../controllers/targets_controller.dart';

class TargetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TargetsController>(TargetsController.new);
  }
}
