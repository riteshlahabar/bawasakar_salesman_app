import 'package:get/get.dart';
import '../controllers/salary_controller.dart';

class SalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalaryController>(SalaryController.new);
  }
}
