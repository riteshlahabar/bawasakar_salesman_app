import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/incentives_controller.dart';

class IncentivesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncentivesController>(
      () => IncentivesController(Get.find<SalesmanFinanceService>()),
    );
  }
}
