import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drawer_menu_button.dart';
import '../controllers/remote_module_controller.dart';
import '../theme/app_colors.dart';
import 'empty_state.dart';
import 'field_module_view.dart';
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
    this.showHeader = true,
    this.topSlot,
  });

  final RemoteModuleController controller;
  final Widget? featured;
  final String recordsTitle;

  /// Passed straight to [FieldModuleView]: `false` drops the in-body
  /// title/subtitle block for screens whose app bar already carries it.
  final bool showHeader;

  /// A filter shown above the stats. It is kept in the loading, error and
  /// empty states too, so changing it never makes the control vanish.
  final Widget? topSlot;

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
        // The primary action has to be offered here too, not only once rows
        // exist — otherwise a module whose list starts empty (Dealer Visits)
        // shows no way to create the very first record.
        return _chrome(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded, not a bare child: EmptyState is a `Center` and
              // would take the whole column, leaving no room for the button.
              Expanded(
                child: EmptyState(
                  title: t('common.nothing_here_yet'),
                  message: controller.subtitle,
                  icon: Icons.inbox_outlined,
                ),
              ),
              if (controller.actionLabel != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: ElevatedButton.icon(
                    onPressed: onPrimaryAction ?? controller.primaryAction,
                    icon: Icon(controller.actionIcon ?? Icons.add),
                    label: Text(controller.actionLabel!),
                  ),
                ),
            ],
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
          showHeader: showHeader,
          topSlot: topSlot,
        ),
      );
    });
  }

  /// Keeps the app bar in place for the non-list states, so a failed load
  /// still looks like the same screen. The bottom bar and FAB belong to
  /// NavShell, which wraps every route using this view.
  Widget _chrome(Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        leading: const DrawerMenuButton(),
      ),
      body: topSlot == null
          ? body
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: topSlot!,
                ),
                Expanded(child: body),
              ],
            ),
    );
  }
}
