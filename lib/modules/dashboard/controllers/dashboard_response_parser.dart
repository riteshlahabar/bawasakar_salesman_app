import 'package:flutter/material.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/theme/app_colors.dart';

/// Parses the `/dashboard` API payload and builds the summary/quick-stat
/// tiles for [DashboardController], keeping that plumbing out of the
/// reactive controller itself.
class DashboardResponseParser {
  const DashboardResponseParser._();

  static Map<String, dynamic> data(Map<String, dynamic> response) {
    final rawData = response['data'];

    if (rawData is! Map) {
      throw const FormatException('Invalid dashboard response.');
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
        title: 'Assigned Dealers',
        value: assignedDealers.toString(),
        icon: Icons.storefront_outlined,
        color: AppColors.primary,
        subtitle: 'Active assignment',
      ),
      SummaryCardModel(
        title: 'Pending Orders',
        value: pendingOrders.toString(),
        icon: Icons.pending_actions_outlined,
        color: AppColors.accent,
        subtitle: 'Need review',
      ),
      SummaryCardModel(
        title: 'Today Collection',
        value: ModuleRowMapper.money(todayCollections),
        icon: Icons.payments_outlined,
        color: AppColors.success,
        subtitle: 'Collected today',
      ),
    ];
  }

  static List<String> buildQuickStats({
    required int assignedDealers,
    required int pendingOrders,
    required double todayCollections,
    required String territory,
  }) {
    return [
      'Assigned Dealers: $assignedDealers',
      'Orders waiting for review: $pendingOrders',
      'Today Collection: ${ModuleRowMapper.money(todayCollections)}',
      if (territory.trim().isNotEmpty) 'Territory: $territory',
    ];
  }

  static String errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
