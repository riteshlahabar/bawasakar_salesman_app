import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';

/// One payslip's full allowance and deduction breakdown, kept as its own
/// screen since the list only shows the totals.
class PayslipDetailController extends GetxController {
  PayslipDetailController(this._api);

  final SalesmanFinanceService _api;

  final slip = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final error = ''.obs;

  List<Map<String, dynamic>> get lines =>
      (slip.value?['lines'] as List?)
          ?.whereType<Map<String, dynamic>>()
          .toList() ??
      const [];

  List<Map<String, dynamic>> get allowances =>
      lines.where((line) => line['kind'] == 'allowance').toList();

  List<Map<String, dynamic>> get deductions =>
      lines.where((line) => line['kind'] == 'deduction').toList();

  @override
  void onInit() {
    final id = ModuleRowMapper.toInt(Get.arguments);
    if (id > 0) load(id);
    super.onInit();
  }

  Future<void> load(int payslipId) async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _api.payslip(payslipId);
      slip.value = ModuleRowMapper.mapFrom(response, 'payslip');
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
