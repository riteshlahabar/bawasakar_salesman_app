import 'package:get/get.dart';

import '../../../app/config/api_config.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/file_opener.dart';
import '../../../app/data/services/salesman_finance_service.dart';

/// Invoices for the salesman's own billed dealer orders, downloadable as the
/// same styled PDF the admin and the dealer app produce.
class InvoicesController extends GetxController {
  InvoicesController(this._api, this._files);

  final SalesmanFinanceService _api;
  final FileOpener _files;

  final invoices = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => invoices.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _api.invoices();
      invoices.assignAll(ModuleRowMapper.listFrom(response, 'invoices'));
    } catch (failure) {
      error.value = failure.toString();
      invoices.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadPdf(int invoiceId, String invoiceNo) {
    final name = invoiceNo.isEmpty
        ? 'invoice-$invoiceId.pdf'
        : '$invoiceNo.pdf';
    return _files.open(
      ApiConfig.invoicePdf(invoiceId),
      name,
      mimeType: 'application/pdf',
    );
  }
}
