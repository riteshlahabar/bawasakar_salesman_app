import 'package:get/get.dart';

import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/payslip_detail_controller.dart';

class PayslipDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayslipDetailController>(
      () => PayslipDetailController(Get.find<SalesmanFinanceService>()),
    );
  }
}
