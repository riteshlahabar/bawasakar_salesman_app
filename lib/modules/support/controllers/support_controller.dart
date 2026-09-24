import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/salesman_auth_service.dart';
import '../../../app/localization/t.dart';

class SupportController extends GetxController {
  SupportController(this._api);

  final SalesmanAuthService _api;
  final subject = TextEditingController();
  final message = TextEditingController();
  final isLoading = false.obs;

  Future<void> submit() async {
    if (subject.text.trim().isEmpty || message.text.trim().isEmpty) {
      Get.snackbar(
        t('support.required'),
        t('support.enter_subject_and_message'),
      );
      return;
    }
    isLoading.value = true;
    try {
      await _api.support(
        subject: subject.text.trim(),
        message: message.text.trim(),
      );
      Get.back<void>();
      Get.snackbar(
        t('support.support_sent'),
        t('support.your_support_ticket_has_been_created'),
      );
    } catch (error) {
      Get.snackbar(t('support.support_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    subject.dispose();
    message.dispose();
    super.onClose();
  }
}
