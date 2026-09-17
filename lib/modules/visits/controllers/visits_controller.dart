import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Dealer visits logged by the salesman in the field.
class VisitsController extends RemoteModuleController {
  VisitsController(this._api)
    : super(
        title: t('visits.daily_visits'),
        subtitle:
            t('visits.dealer_visits_logged_with_gps_location'),
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
            ? dealer['name']?.toString() ?? t('common.dealer')
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
          trailing: visit['latitude'] == null ? t('common.no_gps') : t('common.gps'),
          icon: Icons.storefront,
          status: visit['latitude'] == null ? 'pending' : 'completed',
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
          value: visits.length.toString(),
          icon: Icons.route,
          color: AppColors.info,
          subtitle: t('visits.logged'),
        ),
        ModuleRowMapper.stat(
          title: t('visits.gps_tagged'),
          value: located.toString(),
          icon: Icons.location_on,
          color: AppColors.success,
          subtitle: t('common.verified'),
        ),
      ],
    );
  }
}
