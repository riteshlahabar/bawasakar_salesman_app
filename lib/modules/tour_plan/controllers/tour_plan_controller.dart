import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Planned field routes and the dealers on each one.
class TourPlanController extends RemoteModuleController {
  TourPlanController(this._api)
    : super(
        title: 'Tour Plan',
        subtitle:
            'Your planned routes, the dealers on each and the approval state of the plan.',
      );

  final SalesmanAttendanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final plans = ModuleRowMapper.listFrom(await _api.tourPlans(), 'tour_plans');

    final planned = plans.where((p) => p['status'] == 'planned').length;
    final completed = plans.where((p) => p['status'] == 'completed').length;

    return (
      rows: plans.map((plan) {
        // `dealer_ids` is a JSON column, so it arrives as a list.
        final dealerIds = plan['dealer_ids'];
        final stops = dealerIds is List ? dealerIds.length : 0;

        return ModuleRowMapper.row(
          title: plan['route_name']?.toString() ?? 'Route',
          subtitle:
              '${ModuleRowMapper.date(plan['plan_date'])} • $stops dealer stop${stops == 1 ? '' : 's'}',
          trailing: '$stops',
          icon: Icons.map_outlined,
          status: plan['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Planned',
          value: planned.toString(),
          icon: Icons.event,
          color: AppColors.primary,
          subtitle: 'Routes',
        ),
        ModuleRowMapper.stat(
          title: 'Completed',
          value: completed.toString(),
          icon: Icons.done_all,
          color: AppColors.success,
          subtitle: 'Routes',
        ),
        ModuleRowMapper.stat(
          title: 'Total',
          value: plans.length.toString(),
          icon: Icons.route,
          color: AppColors.info,
          subtitle: 'Records',
        ),
      ],
    );
  }
}
