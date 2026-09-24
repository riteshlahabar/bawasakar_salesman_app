import 'package:flutter/material.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Parses the `/dashboard` API payload and builds the summary/quick-stat
/// tiles for [DashboardController], keeping that plumbing out of the
/// reactive controller itself.
class DashboardResponseParser {
  const DashboardResponseParser._();

  static Map<String, dynamic> data(Map<String, dynamic> response) {
    final rawData = response['data'];

    if (rawData is! Map) {
      throw FormatException(t('dashboard.invalid_dashboard_response'));
    }

    return Map<String, dynamic>.from(rawData);
  }

  /// Reads name/employee-code/territory out of `data.profile`. Any field
  /// missing from the payload comes back empty so the caller can fall back
  /// to locally stored values.
  static ({String name, String employeeCode, String territory}) parseProfile(
    Map<String, dynamic> data,
  ) {
    final rawProfile = data['profile'];

    if (rawProfile is! Map) {
      return (name: '', employeeCode: '', territory: '');
    }

    final profile = Map<String, dynamic>.from(rawProfile);
    final name = profile['name']?.toString().trim() ?? '';

    final rawSalesmanProfile = profile['salesman_profile'];

    if (rawSalesmanProfile is! Map) {
      return (name: name, employeeCode: '', territory: '');
    }

    final salesmanProfile = Map<String, dynamic>.from(rawSalesmanProfile);

    return (
      name: name,
      employeeCode: salesmanProfile['employee_code']?.toString() ?? '',
      territory: salesmanProfile['territory']?.toString() ?? '',
    );
  }

  /// Reads today's GPS check-in/out state out of `data.today_attendance`,
  /// so the dashboard's Check In/Out/Break buttons restore correctly after an
  /// app restart. Any field missing from the payload comes back null/empty.
  static ({
    String checkInAt,
    double checkInLatitude,
    double checkInLongitude,
    String checkOutAt,
    bool onBreak,
    int breakMinutes,
  })
  parseTodayAttendance(Map<String, dynamic> data) {
    final raw = data['today_attendance'];

    if (raw is! Map) {
      return (
        checkInAt: '',
        checkInLatitude: 0,
        checkInLongitude: 0,
        checkOutAt: '',
        onBreak: false,
        breakMinutes: 0,
      );
    }

    final attendance = Map<String, dynamic>.from(raw);

    return (
      checkInAt: attendance['check_in_at']?.toString() ?? '',
      checkInLatitude: ModuleRowMapper.toDouble(
        attendance['check_in_latitude'],
      ),
      checkInLongitude: ModuleRowMapper.toDouble(
        attendance['check_in_longitude'],
      ),
      checkOutAt: attendance['check_out_at']?.toString() ?? '',
      onBreak: attendance['on_break'] == true,
      breakMinutes: ModuleRowMapper.toDouble(
        attendance['break_minutes'],
      ).round(),
    );
  }

  static List<SummaryCardModel> buildSummaries({
    required double todayCollections,
    required int assignedDealers,
    required int pendingOrders,
    required double totalOutstanding,
    required double? monthTarget,
    required double? monthAchieved,
    required int todayVisits,
    required double? monthIncentive,
    required int pendingTasks,
  }) {
    return [
      SummaryCardModel(
        title: t('dashboard.today_collection'),
        value: ModuleRowMapper.money(todayCollections),
        icon: Icons.payments_outlined,
        color: AppColors.success,
        subtitle: t('dashboard.collected_today'),
      ),
      SummaryCardModel(
        title: t('common.assigned_dealers'),
        value: assignedDealers.toString(),
        icon: Icons.storefront_outlined,
        color: AppColors.primary,
        subtitle: t('dashboard.active_assignment'),
      ),
      SummaryCardModel(
        title: t('dashboard.pending_orders'),
        value: pendingOrders.toString(),
        icon: Icons.pending_actions_outlined,
        color: AppColors.accent,
        subtitle: t('dashboard.need_review'),
      ),
      SummaryCardModel(
        title: t('dashboard.total_outstanding'),
        value: ModuleRowMapper.money(totalOutstanding),
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.danger,
        subtitle: t('dashboard.dues_from_dealers'),
      ),
      SummaryCardModel(
        title: t('dashboard.monthly_target'),
        value: ModuleRowMapper.money(monthAchieved ?? 0),
        icon: Icons.track_changes_outlined,
        color: AppColors.info,
        subtitle: monthTarget == null
            ? t('dashboard.no_target_set')
            : t('dashboard.of_target', {
                'target': ModuleRowMapper.money(monthTarget),
              }),
      ),
      SummaryCardModel(
        title: t('dashboard.todays_visits'),
        value: todayVisits.toString(),
        icon: Icons.route_outlined,
        color: AppColors.orange,
        subtitle: t('dashboard.dealer_visits'),
      ),
      SummaryCardModel(
        title: t('dashboard.monthly_incentive'),
        value: ModuleRowMapper.money(monthIncentive ?? 0),
        icon: Icons.card_giftcard_outlined,
        color: AppColors.success,
        subtitle: t('dashboard.incentive_and_commission'),
      ),
      SummaryCardModel(
        title: t('dashboard.pending_tasks'),
        value: pendingTasks.toString(),
        icon: Icons.checklist_outlined,
        color: AppColors.mutedGreen,
        subtitle: t('dashboard.assigned_by_admin'),
      ),
    ];
  }

  static String errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
