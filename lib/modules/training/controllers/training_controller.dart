import 'package:get/get.dart';

import '../../../app/config/api_config.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/file_opener.dart';
import '../../../app/data/services/salesman_hr_service.dart';

/// Training programs the salesman is enrolled in, with attendance, score and
/// the certificate once HR has issued one.
class TrainingController extends GetxController {
  TrainingController(this._api, this._files);

  final SalesmanHrService _api;
  final FileOpener _files;

  final trainings = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => trainings.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _api.trainings();
      trainings.assignAll(ModuleRowMapper.listFrom(response, 'trainings'));
    } catch (failure) {
      error.value = failure.toString();
      trainings.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadCertificate(int attendanceId, String title) {
    return _files.open(
      ApiConfig.trainingCertificate(attendanceId),
      'certificate-$title.pdf',
    );
  }
}
