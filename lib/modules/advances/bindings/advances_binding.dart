import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/advances_controller.dart';

class AdvancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvancesController>(
      () => AdvancesController(Get.find<SalesmanFinanceService>()),
    );
  }
}
