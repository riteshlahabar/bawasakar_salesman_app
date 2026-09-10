import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/theme/app_colors.dart';

/// Dealer visits logged by the salesman in the field.
class VisitsController extends RemoteModuleController {
  VisitsController(this._api)
    : super(
        title: 'Daily Visits',
        subtitle:
            'Dealer visits logged with GPS location, purpose and the remarks you captured on site.',
      );

  final SalesmanAttendanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final visits = ModuleRowMapper.listFrom(await _api.visits(), 'visits');

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final todayCount = visits
        .where((v) => ModuleRowMapper.date(v['visited_at']) == today)
        .length;
    final located = visits.where((v) => v['latitude'] != null).length;

    return (
      rows: visits.map((visit) {
        final dealer = visit['dealer'];
        final dealerName = dealer is Map
            ? dealer['name']?.toString() ?? 'Dealer'
            : 'Dealer #${visit['dealer_id']}';

        return ModuleRowMapper.row(
          title: dealerName,
          subtitle: [
            ModuleRowMapper.date(visit['visited_at']),
            if ((visit['purpose']?.toString() ?? '').isNotEmpty)
              visit['purpose'].toString(),
            if ((visit['remarks']?.toString() ?? '').isNotEmpty)
              visit['remarks'].toString(),
          ].join(' • '),
          trailing: visit['latitude'] == null ? 'No GPS' : 'GPS',
          icon: Icons.storefront,
          status: visit['latitude'] == null ? 'pending' : 'completed',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Today',
          value: todayCount.toString(),
          icon: Icons.today,
          color: AppColors.primary,
          subtitle: 'Visits',
        ),
        ModuleRowMapper.stat(
          title: 'Total',
          value: visits.length.toString(),
          icon: Icons.route,
          color: AppColors.info,
          subtitle: 'Logged',
        ),
        ModuleRowMapper.stat(
          title: 'GPS tagged',
          value: located.toString(),
          icon: Icons.location_on,
          color: AppColors.success,
          subtitle: 'Verified',
        ),
      ],
    );
  }
}
