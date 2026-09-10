import 'package:get/get.dart';

import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(
      () => ReportsController(
        Get.find<SalesmanDashboardService>(),
        Get.find<SalesmanFinanceService>(),
      ),
    );
  }
}
