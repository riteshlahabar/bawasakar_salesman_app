import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/targets_controller.dart';

class TargetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TargetsController>(
      () => TargetsController(Get.find<SalesmanFinanceService>()),
    );
  }
}
