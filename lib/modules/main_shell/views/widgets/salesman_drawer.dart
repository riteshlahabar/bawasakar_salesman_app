import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/action_tile.dart';
import '../../controllers/main_shell_controller.dart';
import '../../../../app/localization/t.dart';

/// Navigation drawer for [MainShellView] — profile header plus the
/// scrollable list of HR/ops shortcuts and logout.
class SalesmanDrawer extends StatelessWidget {
  const SalesmanDrawer({super.key, required this.controller});

  final MainShellController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InkWell(
                onTap: () => controller.openRoute(AppRoutes.profile),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.salesmanName.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.employeeCode.value.isEmpty
                                  ? t('common.salesman')
                                  : controller.employeeCode.value,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (controller.territory.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  controller.territory.value,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 6),
                            Text(
                              t('main_shell.tap_to_view_profile'),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: controller.drawerItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = controller.drawerItems[index];

                  return ActionTile(
                    item: item,
                    onTap: () => controller.openRoute(item.route),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout),
                  label: Text(t('common.logout')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
