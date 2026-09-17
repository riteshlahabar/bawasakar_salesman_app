import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/list_row_model.dart';
import '../data/models/summary_card_model.dart';
import '../localization/t.dart';

/// What one module screen needs to render: the record rows and the stat tiles
/// above them.
typedef ModuleData = ({
  List<ListRowModel> rows,
  List<SummaryCardModel> stats,
});

/// Base for every list-shaped salesman module that reads from the backend.
///
/// It owns the parts every such screen repeats — loading flag, error message,
/// refresh — and leaves subclasses exactly one job: [fetch], which calls its
/// own service and maps the response into rows and stats. Adding a module
/// means writing a `fetch`, not touching this class, and a subclass cannot get
/// the loading/error handling subtly wrong because it never writes any.
abstract class RemoteModuleController extends GetxController {
  RemoteModuleController({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionIcon,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData? actionIcon;

  final rows = <ListRowModel>[].obs;
  final stats = <SummaryCardModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  /// True only once a completed load has produced nothing, so the empty state
  /// never flashes while the first request is still in flight.
  bool get isEmpty => rows.isEmpty && !isLoading.value;

  /// Reads this module's data. Implementations should not catch errors — the
  /// base turns a thrown failure into [error] so every screen reports it the
  /// same way.
  Future<ModuleData> fetch();

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await fetch();
      rows.assignAll(data.rows);
      stats.assignAll(data.stats);
    } catch (failure) {
      error.value = failure.toString();
      rows.clear();
      stats.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Default primary action: modules that submit something override this.
  void primaryAction() {
    Get.snackbar(title, t('common.this_action_is_not_available_yet'));
  }
}
