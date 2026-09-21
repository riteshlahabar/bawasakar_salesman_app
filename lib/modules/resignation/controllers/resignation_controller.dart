import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/localization/t.dart';

/// The salesman's own resignation request and its approval / full & final
/// settlement status. Only one request may be pending or approved at a time
/// — enforced server side — so the form only shows when there is none.
class ResignationController extends GetxController {
  ResignationController(this._api);

  final SalesmanHrService _api;

  final resignations = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final error = ''.obs;

  final resignationDate = Rxn<DateTime>();
  final reason = TextEditingController();

  Map<String, dynamic>? get current => resignations.isEmpty ? null : resignations.first;

  bool get hasOpenRequest =>
      current != null && ['pending', 'approved'].contains(current!['status']);

  @override
  void onInit() {
    load();
    super.onInit();
  }

  @override
  void onClose() {
    reason.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _api.resignation();
      resignations.assignAll(ModuleRowMapper.listFrom(response, 'resignations'));
    } catch (failure) {
      error.value = failure.toString();
      resignations.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    if (resignationDate.value == null) {
      Get.snackbar(t('resignation.resignation_and_exit'), t('resignation.select_resignation_date'));
      return;
    }

    isSubmitting.value = true;
    try {
      await _api.submitResignation({
        'resignation_date': resignationDate.value!.toIso8601String().substring(0, 10),
        if (reason.text.trim().isNotEmpty) 'reason': reason.text.trim(),
      });
      reason.clear();
      resignationDate.value = null;
      await load();
      Get.snackbar(t('resignation.resignation_and_exit'), t('resignation.submitted_for_approval'));
    } catch (failure) {
      Get.snackbar(t('resignation.resignation_and_exit'), failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
