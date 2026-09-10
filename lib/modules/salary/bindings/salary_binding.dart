import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/salary_controller.dart';

class SalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalaryController>(
      () => SalaryController(Get.find<SalesmanFinanceService>()),
    );
  }
}
