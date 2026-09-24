import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/models/dealer_model.dart';
import '../../../app/data/clock_time.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/log_visit_sheet.dart';

/// Dealer visits logged by the salesman in the field.
///
/// Visits are recorded by hand — dealer, purpose, remarks — with **no GPS**:
/// the endpoint takes `latitude`/`longitude` but the app deliberately never
/// sends them, so nothing depends on the phone's location being available.
class VisitsController extends RemoteModuleController with DateFilterMixin {
  VisitsController(this._api)
    : super(
        title: t('visits.daily_visits'),
        subtitle: t('visits.dealer_visits_logged_with_gps_location'),
        actionLabel: t('visits.log_visit'),
        actionIcon: Icons.add_business_outlined,
      );

  final SalesmanAttendanceService _api;

  final SalesmanDashboardService _directory =
      Get.find<SalesmanDashboardService>();

  /// The salesman's own dealers, for the form's picker.
  final dealers = <DealerModel>[].obs;

  final selectedDealerId = 0.obs;

  final purposeController = TextEditingController();

  final remarksController = TextEditingController();

  final isSaving = false.obs;

  /// Every visit the salesman has logged, kept so changing the filter is a
  /// re-map of what is already here rather than another trip to the network.
  /// Cleared whenever a new visit is saved.
  List<Map<String, dynamic>>? _cache;

  /// The screen opens on today's visits.
  @override
  DateFilterMode get initialFilterMode => DateFilterMode.today;

  @override
  void onInit() {
    loadDealers();
    super.onInit();
  }

  @override
  void onClose() {
    purposeController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  Future<void> loadDealers() async {
    try {
      final response = await _directory.dealers(perPage: 100);

      dealers.assignAll(
        ModuleRowMapper.listFrom(response, 'dealers').map(DealerModel.fromJson),
      );
    } catch (failure) {
      // The list is only needed by the form; a failure here must not take the
      // visit log down with it.
      dealers.clear();
    }
  }

  /// Opens the log-visit form. `RemoteModuleView` wires this to the screen's
  /// primary button because [actionLabel] is set.
  @override
  void primaryAction() {
    selectedDealerId.value = 0;
    purposeController.clear();
    remarksController.clear();

    if (dealers.isEmpty) loadDealers();

    Get.bottomSheet<void>(
      LogVisitSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> saveVisit() async {
    if (isSaving.value) return;

    if (selectedDealerId.value <= 0) {
      Get.snackbar(
        t('collections.dealer_required'),
        t('visits.select_the_dealer_you_visited'),
      );
      return;
    }

    isSaving.value = true;

    try {
      await _api.saveVisit(
        dealerId: selectedDealerId.value,
        purpose: purposeController.text,
        remarks: remarksController.text,
      );

      Get.back<void>();
      Get.snackbar(
        t('visits.visit_saved'),
        t('visits.visit_logged_for_dealer'),
      );

      // A new visit means the cached list is stale — drop it so the reload
      // actually goes back to the API.
      _cache = null;
      await load();
    } catch (failure) {
      Get.snackbar(
        t('visits.visit_not_saved'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Every visit, not just the first page.
  ///
  /// The endpoint paginates 20 at a time; reading only page 1 truncated the
  /// log and made the "Total" tile stop at 20. Pages are capped so a bad
  /// `last_page` can never loop forever.
  Future<List<Map<String, dynamic>>> _allVisits() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.visits(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'visits');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'visits');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    // Only the first load — and the one after saving a visit — goes to the
    // network; changing the filter re-reads this list.
    final all = _cache ??= await _allVisits();

    // Both sides through the same formatter: `ModuleRowMapper.date` returns
    // `dd-mm-yyyy`, so comparing it against a raw ISO string never matched.
    final today = ModuleRowMapper.date(DateTime.now().toIso8601String());
    final todayCount = all
        .where((v) => ModuleRowMapper.date(v['visited_at']) == today)
        .length;

    // The rows follow the filter; the Today tile deliberately does not, so it
    // still answers "how many today" whatever window is being read.
    final visits = all
        .where(
          (visit) =>
              isInWindow(DateTime.tryParse('${visit['visited_at']}')?.toLocal()),
        )
        .toList();

    return (
      rows: visits.map((visit) {
        final dealer = visit['dealer'];
        final dealerName = dealer is Map
            ? dealer['name']?.toString() ?? t('common.dealer')
            : 'Dealer #${visit['dealer_id']}';

        return ModuleRowMapper.row(
          title: dealerName,
          // Date and time together, next to the dealer's name — so the row
          // has no right-hand column at all.
          titleTrailing:
              '${ModuleRowMapper.date(visit['visited_at'])}'
              '  ${clockTime(visit['visited_at']?.toString())}',
          subtitle: [
            if ((visit['purpose']?.toString() ?? '').isNotEmpty)
              visit['purpose'].toString(),
            if ((visit['remarks']?.toString() ?? '').isNotEmpty)
              visit['remarks'].toString(),
          ].join(' • '),
          trailing: '',
          icon: Icons.recent_actors_rounded,
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('visits.today'),
          value: todayCount.toString(),
          icon: Icons.today,
          color: AppColors.primary,
          subtitle: t('common.visits'),
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          // The filtered count, with the window named underneath, so the tile
          // always matches the rows listed below it.
          value: visits.length.toString(),
          icon: Icons.route,
          color: AppColors.info,
          subtitle: windowLabel,
        ),
      ],
    );
  }
}
