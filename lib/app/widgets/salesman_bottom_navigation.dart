import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/main_shell/controllers/main_shell_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../localization/t.dart';

class SalesmanBottomNavigation extends StatelessWidget {
  const SalesmanBottomNavigation({
    super.key,
    required this.selectedIndex,
    this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int>? onTap;

  static void openMainTab(int index) {
    if (Get.currentRoute == AppRoutes.main &&
        Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().changeTab(index);
      return;
    }

    Get.offAllNamed(AppRoutes.main, arguments: {'tabIndex': index});
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 12,
      child: Row(
        children: [
          Expanded(
            child: _BottomNavIcon(
              index: 0,
              selectedIndex: selectedIndex,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              tooltip: t('common.home'),
              onTap: onTap ?? openMainTab,
            ),
          ),
          Expanded(
            child: _BottomNavIcon(
              index: 1,
              selectedIndex: selectedIndex,
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront,
              tooltip: t('common.dealers'),
              onTap: onTap ?? openMainTab,
            ),
          ),
          const SizedBox(width: 72),
          Expanded(
            child: _BottomNavIcon(
              index: 2,
              selectedIndex: selectedIndex,
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              tooltip: t('common.orders'),
              onTap: onTap ?? openMainTab,
            ),
          ),
          Expanded(
            child: _BottomNavIcon(
              index: 3,
              selectedIndex: selectedIndex,
              icon: Icons.payments_outlined,
              activeIcon: Icons.payments,
              tooltip: t('common.collections'),
              onTap: onTap ?? openMainTab,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.activeIcon,
    required this.tooltip,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData activeIcon;
  final String tooltip;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: .10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.primary : Colors.grey,
            size: 23,
          ),
        ),
      ),
    );
  }
}
