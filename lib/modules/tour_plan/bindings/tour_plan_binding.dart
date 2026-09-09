import 'package:get/get.dart';
import '../controllers/tour_plan_controller.dart';

class TourPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TourPlanController>(TourPlanController.new);
  }
}
