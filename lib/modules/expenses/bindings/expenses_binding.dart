import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/expenses_controller.dart';

class ExpensesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpensesController>(
      () => ExpensesController(Get.find<SalesmanFinanceService>()),
    );
  }
}
