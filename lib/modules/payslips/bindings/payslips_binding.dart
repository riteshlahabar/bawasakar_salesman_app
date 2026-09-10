import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/payslips_controller.dart';

class PayslipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayslipsController>(
      () => PayslipsController(Get.find<SalesmanFinanceService>()),
    );
  }
}
