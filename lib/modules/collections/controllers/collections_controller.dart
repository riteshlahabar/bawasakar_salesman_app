import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/dealer_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../app/localization/t.dart';

class CollectionsController extends GetxController {
  final SalesmanFinanceService _api = Get.find<SalesmanFinanceService>();

  final SalesmanDashboardService _directory =
      Get.find<SalesmanDashboardService>();

  final dealers = <DealerModel>[].obs;

  final selectedDealerId = 0.obs;

  final paymentMode = 'upi'.obs;

  final amountController = TextEditingController();

  final transactionController = TextEditingController();

  final isLoading = false.obs;

  final lastMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();

    loadDealers();
  }

  Future<void> loadDealers() async {
    try {
      final response = await _directory.dealers(perPage: 100);

      final rows = ModuleRowMapper.listFrom(response, 'dealers');

      dealers.assignAll(rows.map(DealerModel.fromJson));
    } catch (error) {
      Get.snackbar(
        t('common.dealers'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> collect() async {
    if (isLoading.value) {
      return;
    }

    if (selectedDealerId.value <= 0) {
      Get.snackbar(
        t('collections.dealer_required'),
        t('collections.select_the_dealer_who_made_the'),
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      Get.snackbar(
        t('collections.amount_required'),
        t('collections.enter_a_valid_payment_amount'),
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _api.collectPayment(
        dealerId: selectedDealerId.value,
        paymentMode: paymentMode.value,
        amount: amount,
        transactionRef: transactionController.text,
      );

      final payment = ModuleRowMapper.mapFrom(response, 'payment');

      final receipt = payment['payment_no']?.toString() ?? '';

      lastMessage.value = receipt.isEmpty
          ? t('collections.payment_collected_successfully')
          : t('collections.payment_collected_receipt', {'receipt': receipt});

      amountController.clear();

      transactionController.clear();

      Get.snackbar(t('collections.payment_collected'), lastMessage.value);

      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().loadDashboard();
      }
    } catch (error) {
      Get.snackbar(
        t('collections.collection_failed'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    transactionController.dispose();

    super.onClose();
  }
}
