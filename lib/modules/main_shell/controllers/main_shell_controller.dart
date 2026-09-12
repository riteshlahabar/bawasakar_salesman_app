import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/data/services/salesman_auth_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../collections/controllers/collections_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dealers/controllers/dealers_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import 'main_shell_nav_config.dart';

class MainShellController
    extends GetxController {
  final SalesmanAuthService _api = Get.find<SalesmanAuthService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final selectedIndex = 0.obs;

  final salesmanName =
      'Salesman'.obs;

  final employeeCode = ''.obs;

  final territory = ''.obs;

  List<String> get tabTitles =>
      MainShellNavConfig.tabTitles;

  String get currentTitle =>
      tabTitles[
          selectedIndex.value];

  List<BottomNavigationBarItem> get navItems =>
      MainShellNavConfig.navItems;

  List<ActionItemModel> get drawerItems =>
      MainShellNavConfig.drawerItems;

  @override
  void onInit() {
    super.onInit();

    final arguments =
        Get.arguments;

    final tabIndex =
        arguments is Map
            ? arguments[
                'tabIndex']
            : null;

    if (tabIndex is int &&
        tabIndex >= 0 &&
        tabIndex <
            tabTitles.length) {
      selectedIndex.value =
          tabIndex;
    }

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name =
        _storage.name;

    final code =
        _storage.employeeCode;

    final savedTerritory =
        _storage.territory;

    if (name.trim().isNotEmpty) {
      salesmanName.value =
          name;
    }

    employeeCode.value =
        code;

    territory.value =
        savedTerritory;
  }

  void changeTab(
    int index,
  ) {
    selectedIndex.value =
        index;

    switch (index) {
      case 0:
        if (Get.isRegistered<
            DashboardController>()) {
          Get.find<
                  DashboardController>()
              .loadDashboard();
        }
        break;

      case 1:
        if (Get.isRegistered<
            DealersController>()) {
          Get.find<
                  DealersController>()
              .loadDealers();
        }
        break;

      case 2:
        if (Get.isRegistered<
            OrdersController>()) {
          Get.find<
                  OrdersController>()
              .loadOrders();
        }
        break;

      case 3:
        if (Get.isRegistered<
            CollectionsController>()) {
          Get.find<
                  CollectionsController>()
              .loadDealers();
        }
        break;
    }
  }

  void openRoute(
    String route,
  ) {
    Get.back<void>();

    Get.toNamed(
      route,
    );
  }

  void openQuickAction() {
    Get.toNamed(
      AppRoutes.products,
    );
  }

  Future<void> logout() async {
    await _api.logout();

    Get.offAllNamed(
      AppRoutes.login,
    );
  }
}