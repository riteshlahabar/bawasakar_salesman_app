import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/data/models/action_item_model.dart';
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
      width: 228,
      // `top: false` so the green header paints behind the status bar like
      // the app bar does, instead of leaving a white strip above it; the
      // status-bar height is added to the header's own padding instead.
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Obx(
              () => InkWell(
                onTap: () => controller.openRoute(AppRoutes.profile),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    18,
                    18 + MediaQuery.of(context).padding.top,
                    18,
                    18,
                  ),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                itemCount: controller.drawerItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final item = controller.drawerItems[index];

                  return _DrawerTile(
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

/// A flat drawer row: coloured icon and title only.
///
/// Deliberately not [ActionTile] — that one is a raised card with a subtitle
/// and a trailing arrow, which the Profile screen still wants; the drawer
/// lists every module, so the same treatment made it long and heavy.
class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.item, required this.onTap});

  final ActionItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          children: [
            Icon(item.icon, color: item.color, size: 21),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
