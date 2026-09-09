import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/data/services/salesman_auth_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../collections/controllers/collections_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dealers/controllers/dealers_controller.dart';
import '../../orders/controllers/orders_controller.dart';

class MainShellController
    extends GetxController {
  final SalesmanAuthService _api = Get.find<SalesmanAuthService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final selectedIndex = 0.obs;

  final salesmanName =
      'Salesman'.obs;

  final employeeCode = ''.obs;

  final territory = ''.obs;

  final tabTitles = const [
    'Dashboard',
    'Assigned Dealers',
    'Orders',
    'Payment Collection',
  ];

  String get currentTitle =>
      tabTitles[
          selectedIndex.value];

  final navItems = const [
    BottomNavigationBarItem(
      icon:
          Icon(Icons.home_outlined),
      activeIcon:
          Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.storefront_outlined,
      ),
      activeIcon:
          Icon(Icons.storefront),
      label: 'Dealers',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.receipt_long_outlined,
      ),
      activeIcon:
          Icon(Icons.receipt_long),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon:
          Icon(Icons.payments_outlined),
      activeIcon:
          Icon(Icons.payments),
      label: 'Collect',
    ),
  ];

  final drawerItems = const [
    ActionItemModel(
      title: 'Attendance',
      subtitle:
          'GPS check in and working hours',
      icon:
          Icons.location_on_outlined,
      route:
          AppRoutes.attendance,
      color:
          AppColors.success,
    ),
    ActionItemModel(
      title: 'Dealer Visits',
      subtitle:
          'Visit assigned dealers',
      icon:
          Icons.route_outlined,
      route: AppRoutes.visits,
      color:
          AppColors.primary,
    ),
    ActionItemModel(
      title: 'Expenses',
      subtitle:
          'Travel, fuel and other claims',
      icon: Icons
          .account_balance_wallet_outlined,
      route:
          AppRoutes.expenses,
      color:
          AppColors.orange,
    ),
    ActionItemModel(
      title: 'Leave',
      subtitle:
          'Apply and view leave',
      icon: Icons
          .event_available_outlined,
      route:
          AppRoutes.leave,
      color:
          AppColors.info,
    ),
    ActionItemModel(
      title: 'Salary',
      subtitle:
          'Payslip and earnings',
      icon:
          Icons.currency_rupee,
      route:
          AppRoutes.salary,
      color:
          AppColors.primaryDark,
    ),
    ActionItemModel(
      title: 'Targets',
      subtitle:
          'Monthly performance targets',
      icon:
          Icons.flag_outlined,
      route:
          AppRoutes.targets,
      color:
          AppColors.danger,
    ),
    ActionItemModel(
      title: 'Tour Plan',
      subtitle:
          'Daily route schedule',
      icon:
          Icons.map_outlined,
      route:
          AppRoutes.tourPlan,
      color:
          AppColors.success,
    ),
    ActionItemModel(
      title: 'Assets',
      subtitle:
          'Company issued assets',
      icon: Icons
          .inventory_2_outlined,
      route:
          AppRoutes.assets,
      color:
          AppColors.orange,
    ),
    ActionItemModel(
      title: 'Products',
      subtitle:
          'Dealer price catalog',
      icon:
          Icons.medication_outlined,
      route:
          AppRoutes.products,
      color:
          AppColors.primary,
    ),
    ActionItemModel(
      title:
          'Delivery Tracking',
      subtitle:
          'Dispatch and delivery',
      icon:
          Icons.local_shipping_outlined,
      route:
          AppRoutes.delivery,
      color:
          AppColors.info,
    ),
  ];

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