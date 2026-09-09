import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class DashboardController
    extends GetxController {
  final SalesmanDashboardService _api = Get.find<SalesmanDashboardService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final isLoading = false.obs;

  final salesmanName =
      'Sales Executive'.obs;

  final employeeCode = ''.obs;

  final territory = ''.obs;

  final assignedDealers = 0.obs;

  final pendingOrders = 0.obs;

  final todayCollections =
      0.0.obs;

  final summaries =
      <SummaryCardModel>[].obs;

  final quickStats =
      <String>[].obs;

  final operations = const [
    ActionItemModel(
      title: 'Attendance',
      subtitle: 'GPS',
      icon: Icons.my_location,
      route:
          AppRoutes.attendance,
      color:
          AppColors.primary,
    ),
    ActionItemModel(
      title: 'Visit',
      subtitle: 'Dealer',
      icon: Icons.route,
      route: AppRoutes.visits,
      color:
          AppColors.orange,
    ),
    ActionItemModel(
      title: 'Products',
      subtitle: 'Catalog',
      icon:
          Icons.inventory_2_outlined,
      route: AppRoutes.products,
      color:
          AppColors.success,
    ),
    ActionItemModel(
      title: 'Expense',
      subtitle: 'Claim',
      icon: Icons
          .account_balance_wallet_outlined,
      route: AppRoutes.expenses,
      color:
          AppColors.info,
    ),
  ].obs;

  @override
  void onReady() {
    super.onReady();

    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final response =
          await _api.dashboard();

      final rawData =
          response['data'];

      if (rawData is! Map) {
        throw const FormatException(
          'Invalid dashboard response.',
        );
      }

      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      assignedDealers.value =
          _asInt(
        data['assigned_dealers'],
      );

      pendingOrders.value =
          _asInt(
        data['pending_orders'],
      );

      todayCollections.value =
          _asDouble(
        data['today_collections'],
      );

      final rawProfile =
          data['profile'];

      if (rawProfile is Map) {
        final profile =
            Map<String, dynamic>.from(
          rawProfile,
        );

        final name =
            profile['name']
                    ?.toString()
                    .trim() ??
                '';

        if (name.isNotEmpty) {
          salesmanName.value =
              name;
        }

        final rawSalesmanProfile =
            profile[
                'salesman_profile'];

        if (rawSalesmanProfile
            is Map) {
          final salesmanProfile =
              Map<String, dynamic>.from(
            rawSalesmanProfile,
          );

          employeeCode.value =
              salesmanProfile[
                          'employee_code']
                      ?.toString() ??
                  '';

          territory.value =
              salesmanProfile[
                          'territory']
                      ?.toString() ??
                  '';
        }
      }

      // Save fallback profile data if
      // dashboard relation is absent.
      if (salesmanName.value ==
          'Sales Executive') {
        final storedName =
            _storage.name;

        if (storedName
            .trim()
            .isNotEmpty) {
          salesmanName.value =
              storedName;
        }
      }

      if (employeeCode
          .value.isEmpty) {
        employeeCode.value =
            _storage.employeeCode;
      }

      if (territory
          .value.isEmpty) {
        territory.value =
            _storage.territory;
      }

      _buildCards();
    } catch (error) {
      Get.snackbar(
        'Dashboard',
        _message(
          error,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _buildCards() {
    summaries.assignAll([
      SummaryCardModel(
        title:
            'Assigned Dealers',
        value:
            assignedDealers.value
                .toString(),
        icon:
            Icons.storefront_outlined,
        color:
            AppColors.primary,
        subtitle:
            'Active assignment',
      ),
      SummaryCardModel(
        title:
            'Pending Orders',
        value:
            pendingOrders.value
                .toString(),
        icon:
            Icons.pending_actions_outlined,
        color:
            AppColors.accent,
        subtitle:
            'Need review',
      ),
      SummaryCardModel(
        title:
            'Today Collection',
        value:
            _money(
          todayCollections.value,
        ),
        icon:
            Icons.payments_outlined,
        color:
            AppColors.success,
        subtitle:
            'Collected today',
      ),
    ]);

    quickStats.assignAll([
      'Assigned Dealers: ${assignedDealers.value}',
      'Orders waiting for review: ${pendingOrders.value}',
      'Today Collection: ${_money(todayCollections.value)}',
      if (territory.value
          .trim()
          .isNotEmpty)
        'Territory: ${territory.value}',
    ]);
  }

  String _money(
    double value,
  ) {
    return '₹${value.toStringAsFixed(0)}';
  }

  int _asInt(
    dynamic value,
  ) {
    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  double _asDouble(
    dynamic value,
  ) {
    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  String _message(
    Object error,
  ) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}