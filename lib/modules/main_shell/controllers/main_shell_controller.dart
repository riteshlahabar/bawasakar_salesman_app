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

class MainShellController extends GetxController {
  final SalesmanAuthService _api = Get.find<SalesmanAuthService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final selectedIndex = 0.obs;

  final salesmanName = 'Salesman'.obs;

  final employeeCode = ''.obs;

  List<String> get tabTitles => MainShellNavConfig.tabTitles;

  /// The Home tab shows the salesman's name instead of a generic "Dashboard"
  /// title; every other tab keeps its plain title.
  String get currentTitle {
    if (selectedIndex.value != 0) {
      return tabTitles[selectedIndex.value];
    }

    if (Get.isRegistered<DashboardController>()) {
      final dashboardName = Get.find<DashboardController>().salesmanName.value;

      if (dashboardName.isNotEmpty) return dashboardName;
    }

    return salesmanName.value;
  }

  List<BottomNavigationBarItem> get navItems => MainShellNavConfig.navItems;

  List<ActionItemModel> get drawerItems => MainShellNavConfig.drawerItems;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    final tabIndex = arguments is Map ? arguments['tabIndex'] : null;

    if (tabIndex is int && tabIndex >= 0 && tabIndex < tabTitles.length) {
      selectedIndex.value = tabIndex;
    }

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = _storage.name;

    final code = _storage.employeeCode;

    if (name.trim().isNotEmpty) {
      salesmanName.value = name;
    }

    employeeCode.value = code;
  }

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().loadDashboard();
        }
        break;

      case 1:
        if (Get.isRegistered<DealersController>()) {
          Get.find<DealersController>().loadDealers();
        }
        break;

      case 2:
        if (Get.isRegistered<OrdersController>()) {
          Get.find<OrdersController>().loadOrders();
        }
        break;

      case 3:
        if (Get.isRegistered<CollectionsController>()) {
          Get.find<CollectionsController>().loadDealers();
        }
        break;
    }
  }

  void openRoute(String route) {
    Get.back<void>();

    Get.toNamed(route);
  }

  void openQuickAction() {
    Get.toNamed(AppRoutes.products);
  }

  Future<void> logout() async {
    await _api.logout();

    Get.offAllNamed(AppRoutes.login);
  }
}
