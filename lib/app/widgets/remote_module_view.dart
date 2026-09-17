import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/remote_module_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'empty_state.dart';
import 'field_module_view.dart';
import 'salesman_bottom_navigation.dart';
import '../localization/t.dart';

/// Renders any [RemoteModuleController] as a standard module screen.
///
/// Loading, failure and empty are handled once here rather than in each of the
/// twenty module screens, so they cannot drift apart — and a new module needs
/// only a controller, not a bespoke layout.
class RemoteModuleView extends StatelessWidget {
  const RemoteModuleView({
    super.key,
    required this.controller,
    this.featured,
    this.recordsTitle = 'common.records',
    this.onPrimaryAction,
  });

  final RemoteModuleController controller;
  final Widget? featured;
  final String recordsTitle;

  /// Overrides the controller's own primary action, for screens that open a
  /// form rather than firing a request directly.
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.rows.isEmpty) {
        return _chrome(
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      }

      if (controller.error.value.isNotEmpty && controller.rows.isEmpty) {
        return _chrome(
          EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          ),
        );
      }

      if (controller.isEmpty) {
        return _chrome(
          EmptyState(
            title: t('common.nothing_here_yet'),
            message: controller.subtitle,
            icon: Icons.inbox_outlined,
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.load,
        child: FieldModuleView(
          title: controller.title,
          subtitle: controller.subtitle,
          stats: controller.stats.toList(),
          rows: controller.rows.toList(),
          primaryActionLabel: controller.actionLabel,
          primaryActionIcon: controller.actionIcon,
          onPrimaryAction: controller.actionLabel == null
              ? null
              : (onPrimaryAction ?? controller.primaryAction),
          featured: featured,
          recordsTitle: t(recordsTitle),
        ),
      );
    });
  }

  /// Keeps the app bar and bottom navigation in place for the non-list states,
  /// so a failed load still looks like the same screen.
  Widget _chrome(Widget body) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(controller.title)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          onPressed: () => Get.toNamed<void>(AppRoutes.products),
          child: const Icon(Icons.qr_code_scanner_sharp),
        ),
      ),
      bottomNavigationBar: const SalesmanBottomNavigation(selectedIndex: -1),
      body: body,
    );
  }
}
