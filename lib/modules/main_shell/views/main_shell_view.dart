import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/action_tile.dart';
import '../../../app/widgets/salesman_bottom_navigation.dart';
import '../../collections/views/collections_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../dealers/views/dealers_view.dart';
import '../../orders/views/orders_view.dart';
import '../controllers/main_shell_controller.dart';

class MainShellView
    extends GetView<MainShellController> {
  const MainShellView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
          title:
              Text(
            controller.currentTitle,
          ),
          actions: [
            IconButton(
              tooltip:
                  'Refresh',
              onPressed: () {
                controller.changeTab(
                  controller
                      .selectedIndex
                      .value,
                );
              },
              icon:
                  const Icon(
                Icons.refresh_rounded,
              ),
            ),

            IconButton(
              tooltip:
                  'Notifications',
              onPressed: () {
                Get.toNamed(
                  AppRoutes.notifications,
                );
              },
              icon:
                  const Icon(
                Icons
                    .notifications_outlined,
              ),
            ),
          ],
        ),

        drawer:
            _SalesmanDrawer(
          controller:
              controller,
        ),

        body: IndexedStack(
          index: controller
              .selectedIndex.value,
          children: pages,
        ),

        floatingActionButtonLocation:
            FloatingActionButtonLocation
                .centerDocked,

        floatingActionButton:
            Padding(
          padding:
              const EdgeInsets.all(
            6,
          ),
          child:
              FloatingActionButton(
            backgroundColor:
                AppColors.primary,
            foregroundColor:
                Colors.white,
            elevation: 6,
            onPressed:
                controller
                    .openQuickAction,
            child: const Icon(
              Icons
                  .inventory_2_outlined,
            ),
          ),
        ),

        bottomNavigationBar:
            SalesmanBottomNavigation(
          selectedIndex:
              controller
                  .selectedIndex
                  .value,
          onTap:
              controller.changeTab,
        ),
      ),
    );
  }
}

class _SalesmanDrawer
    extends StatelessWidget {
  const _SalesmanDrawer({
    required this.controller,
  });

  final MainShellController controller;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .all(
                  18,
                ),
                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      AppColors
                          .primary,
                      AppColors
                          .primaryDark,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor:
                          Colors.white,
                      child: Icon(
                        Icons
                            .person_rounded,
                        color:
                            AppColors
                                .primary,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            controller
                                .salesmanName
                                .value,
                            style:
                                const TextStyle(
                              color: Colors
                                  .white,
                              fontSize:
                                  14,
                              fontWeight:
                                  FontWeight
                                      .w900,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            controller
                                    .employeeCode
                                    .value
                                    .isEmpty
                                ? 'Salesman'
                                : controller
                                    .employeeCode
                                    .value,
                            style:
                                const TextStyle(
                              color: Colors
                                  .white70,
                              fontSize:
                                  11,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                          if (controller
                              .territory
                              .value
                              .isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                top: 3,
                              ),
                              child:
                                  Text(
                                controller
                                    .territory
                                    .value,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .white70,
                                  fontSize:
                                      10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child:
                  ListView.separated(
                padding:
                    const EdgeInsets
                        .all(
                  12,
                ),
                itemCount:
                    controller
                        .drawerItems
                        .length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  height: 10,
                ),
                itemBuilder:
                    (context, index) {
                  final item =
                      controller
                              .drawerItems[
                          index];

                  return ActionTile(
                    item: item,
                    onTap: () {
                      controller
                          .openRoute(
                        item.route,
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              child:
                  SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      controller.logout,
                  icon:
                      const Icon(
                    Icons.logout,
                  ),
                  label:
                      const Text(
                    'Logout',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}