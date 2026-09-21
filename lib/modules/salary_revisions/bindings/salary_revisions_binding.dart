import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/salary_revisions_controller.dart';

class SalaryRevisionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalaryRevisionsController>(
      () => SalaryRevisionsController(Get.find<SalesmanFinanceService>()),
    );
  }
}
