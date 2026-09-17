import 'package:get/get.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/data/models/summary_card_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/auth_storage.dart';
import 'dashboard_operations_config.dart';
import 'dashboard_response_parser.dart';
import '../../../app/localization/t.dart';

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

  final operations =
      <ActionItemModel>[
        ...DashboardOperationsConfig.operations,
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

      final data =
          DashboardResponseParser.data(
        response,
      );

      assignedDealers.value =
          ModuleRowMapper.toInt(
        data['assigned_dealers'],
      );

      pendingOrders.value =
          ModuleRowMapper.toInt(
        data['pending_orders'],
      );

      todayCollections.value =
          ModuleRowMapper.toDouble(
        data['today_collections'],
      );

      final profile =
          DashboardResponseParser
              .parseProfile(
        data,
      );

      if (profile.name.isNotEmpty) {
        salesmanName.value =
            profile.name;
      }

      if (profile.employeeCode
          .isNotEmpty) {
        employeeCode.value =
            profile.employeeCode;
      }

      if (profile.territory
          .isNotEmpty) {
        territory.value =
            profile.territory;
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
        t('common.dashboard'),
        DashboardResponseParser
            .errorMessage(
          error,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _buildCards() {
    summaries.assignAll(
      DashboardResponseParser
          .buildSummaries(
        assignedDealers:
            assignedDealers.value,
        pendingOrders:
            pendingOrders.value,
        todayCollections:
            todayCollections.value,
      ),
    );
  }
}
