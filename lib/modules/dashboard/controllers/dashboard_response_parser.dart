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

  static List<SummaryCardModel> buildSummaries({
    required int assignedDealers,
    required int pendingOrders,
    required double todayCollections,
  }) {
    return [
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
        title: t('dashboard.today_collection'),
        value: ModuleRowMapper.money(todayCollections),
        icon: Icons.payments_outlined,
        color: AppColors.success,
        subtitle: t('dashboard.collected_today'),
      ),
    ];
  }

  static String errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
