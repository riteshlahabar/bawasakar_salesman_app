import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/salesman_bottom_navigation.dart';
import '../../collections/views/collections_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../dealers/views/dealers_view.dart';
import '../../orders/views/orders_view.dart';
import '../controllers/main_shell_controller.dart';
import 'widgets/salesman_drawer.dart';
import '../../../app/localization/t.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      DashboardView(),
      DealersView(),
      OrdersView(),
      CollectionsView(),
    ];

    return Obx(
      () => Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(controller.currentTitle),
          actions: [
            IconButton(
              tooltip: t('main_shell.refresh'),
              onPressed: () =>
                  controller.changeTab(controller.selectedIndex.value),
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: t('common.notifications'),
              onPressed: () => Get.toNamed(AppRoutes.notifications),
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        drawer: SalesmanDrawer(controller: controller),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(6),
          child: FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 6,
            onPressed: controller.openQuickAction,
            child: const Icon(Icons.inventory_2_outlined),
          ),
        ),
        bottomNavigationBar: SalesmanBottomNavigation(
          selectedIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
