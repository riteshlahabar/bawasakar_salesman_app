import 'package:get/get.dart';

import '../../../app/data/services/file_opener.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../controllers/invoices_controller.dart';

class InvoicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoicesController>(
      () => InvoicesController(
        Get.find<SalesmanFinanceService>(),
        Get.find<FileOpener>(),
      ),
    );
  }
}
