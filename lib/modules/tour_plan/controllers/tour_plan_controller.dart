import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/models/dealer_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/add_tour_plan_sheet.dart';

/// Planned field routes and the dealers on each one.
///
/// A plan the salesman writes here is always filed as `planned` — approving
/// one stays an admin decision. What they can settle themselves is the other
/// end: marking a route completed once it has been walked.
class TourPlanController extends RemoteModuleController with DateFilterMixin {
  TourPlanController(this._api)
    : super(
        title: t('common.tour_plan'),
        subtitle: t('tour_plan.your_planned_routes_the_dealers_on'),
        actionLabel: t('tour_plan.add_tour_plan'),
        actionIcon: Icons.add_road_rounded,
      );

  final SalesmanAttendanceService _api;

  final SalesmanDashboardService _directory =
      Get.find<SalesmanDashboardService>();

  /// The salesman's own dealers, for the form's picker.
  final dealers = <DealerModel>[].obs;

  /// The dealers ticked onto the route being written, in pick order.
  final selectedDealerIds = <int>[].obs;

  final planDate = Rx<DateTime>(DateTime.now());

  final routeNameController = TextEditingController();

  final isSaving = false.obs;

  /// Every plan the salesman has, kept so changing the filter re-maps what is
  /// already here instead of going back to the network. Cleared whenever a
  /// plan is saved or completed.
  List<Map<String, dynamic>>? _cache;

  /// Plans are sparse, so the screen opens on the month rather than on today.
  @override
  DateFilterMode get initialFilterMode => DateFilterMode.month;

  String get planDateLabel => DateFilterMixin.dayLabel(planDate.value);

  @override
  void onInit() {
    loadDealers();
    super.onInit();
  }

  @override
  void onClose() {
    routeNameController.dispose();
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
      // tour plan log down with it.
      dealers.clear();
    }
  }

  /// Opens the new-plan form. `RemoteModuleView` wires this to the screen's
  /// primary button because [actionLabel] is set.
  @override
  void primaryAction() {
    planDate.value = DateTime.now();
    routeNameController.clear();
    selectedDealerIds.clear();

    if (dealers.isEmpty) loadDealers();

    Get.bottomSheet<void>(
      AddTourPlanSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void toggleDealer(int dealerId) {
    if (selectedDealerIds.contains(dealerId)) {
      selectedDealerIds.remove(dealerId);
    } else {
      selectedDealerIds.add(dealerId);
    }
  }

  String dealerName(int dealerId) {
    final match = dealers.where((dealer) => dealer.userId == dealerId);

    return match.isEmpty ? '#$dealerId' : match.first.displayName;
  }

  Future<void> saveTourPlan() async {
    if (isSaving.value) return;

    if (routeNameController.text.trim().isEmpty) {
      Get.snackbar(
        t('tour_plan.route_required'),
        t('tour_plan.name_the_route_you_are_planning'),
      );
      return;
    }

    isSaving.value = true;

    try {
      await _api.saveTourPlan(
        planDate: DateFilterMixin.apiDay(planDate.value),
        routeName: routeNameController.text,
        dealerIds: selectedDealerIds.toList(),
      );

      Get.back<void>();
      Get.snackbar(t('tour_plan.plan_saved'), t('tour_plan.tour_plan_saved'));

      _cache = null;
      await load();
    } catch (failure) {
      Get.snackbar(
        t('tour_plan.plan_not_saved'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Confirms before closing a route: completing one cannot be undone from
  /// the app, only by an admin.
  void confirmComplete(int planId, String routeName) {
    Get.defaultDialog<void>(
      title: t('tour_plan.mark_completed'),
      middleText: t('tour_plan.mark_route_completed_question')
          .replaceFirst(':route', routeName),
      textCancel: t('common.cancel'),
      textConfirm: t('tour_plan.mark_completed'),
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back<void>();
        completePlan(planId);
      },
    );
  }

  Future<void> completePlan(int planId) async {
    try {
      await _api.completeTourPlan(planId);

      Get.snackbar(
        t('tour_plan.plan_completed'),
        t('tour_plan.tour_plan_marked_completed'),
      );

      _cache = null;
      await load();
    } catch (failure) {
      Get.snackbar(
        t('tour_plan.plan_not_updated'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Every plan, not just the first page — the endpoint paginates 20 at a
  /// time, and reading only page 1 would truncate both the list and the
  /// stat tiles. Pages are capped so a bad `last_page` can never loop.
  Future<List<Map<String, dynamic>>> _allPlans() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.tourPlans(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'tour_plans');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'tour_plans');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  /// The dealers on a route, named. The API resolves `dealer_ids` into a
  /// `dealers` list; the ids are the fallback for an older server that does
  /// not, so the row still says how many stops there are.
  String _stopsLabel(Map<String, dynamic> plan) {
    final resolved = plan['dealers'];

    if (resolved is List && resolved.isNotEmpty) {
      return resolved
          .whereType<Map>()
          .map((dealer) => dealer['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .join(', ');
    }

    final ids = plan['dealer_ids'];
    final stops = ids is List ? ids.length : 0;

    return stops == 0
        ? t('tour_plan.no_dealers_on_this_route')
        : '$stops ${t('tour_plan.dealer_stops')}';
  }

  @override
  Future<ModuleData> fetch() async {
    // Only the first load — and the one after saving or completing a plan —
    // goes to the network; changing the filter re-reads this list.
    final all = _cache ??= await _allPlans();

    final plans = all
        .where(
          (plan) =>
              isInWindow(DateTime.tryParse('${plan['plan_date']}')?.toLocal()),
        )
        .toList();

    final planned = plans.where((p) => p['status'] == 'planned').length;
    final completed = plans.where((p) => p['status'] == 'completed').length;

    return (
      rows: plans.map((plan) {
        final status = plan['status']?.toString() ?? 'planned';
        final routeName =
            plan['route_name']?.toString() ?? t('common.route');
        final planId = ModuleRowMapper.toInt(plan['id']);

        // Only a route still open can be closed; completed and cancelled are
        // final, so those rows are not tappable at all.
        final isOpen = status == 'planned' || status == 'approved';

        return ModuleRowMapper.row(
          title: routeName,
          titleTrailing: ModuleRowMapper.date(plan['plan_date']),
          subtitle: _stopsLabel(plan),
          trailing: '',
          icon: Icons.map_outlined,
          status: status,
          onTap: isOpen && planId > 0
              ? () => confirmComplete(planId, routeName)
              : null,
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('tour_plan.planned'),
          value: planned.toString(),
          icon: Icons.event,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.completed'),
          value: completed.toString(),
          icon: Icons.done_all,
          color: AppColors.success,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: plans.length.toString(),
          icon: Icons.route,
          color: AppColors.info,
          subtitle: windowLabel,
        ),
      ],
    );
  }
}
