import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/localization/t.dart';

/// Tasks assigned to the salesman by admin. The salesman can move a task
/// through pending → in progress → completed (or cancel it) but never
/// reassign it.
class TasksController extends GetxController {
  TasksController(this._api);

  final SalesmanHrService _api;

  final tasks = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final error = ''.obs;

  bool get isEmpty => tasks.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await _api.tasks();
      tasks.assignAll(ModuleRowMapper.listFrom(response, 'tasks'));
    } catch (failure) {
      error.value = failure.toString();
      tasks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setStatus(
    int taskId,
    String status, {
    String? completionNotes,
  }) async {
    isUpdating.value = true;
    try {
      await _api.updateTask(taskId, {
        'status': status,
        if (completionNotes != null && completionNotes.trim().isNotEmpty)
          'completion_notes': completionNotes.trim(),
      });
      await load();
      Get.snackbar(t('tasks.tasks_title'), t('tasks.task_updated'));
    } catch (failure) {
      Get.snackbar(t('tasks.tasks_title'), failure.toString());
    } finally {
      isUpdating.value = false;
    }
  }
}
