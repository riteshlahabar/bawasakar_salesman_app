import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../../../app/widgets/status_filter_bar.dart';
import '../controllers/assets_controller.dart';
import '../../../app/localization/t.dart';

class AssetsView extends GetView<AssetsController> {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('assets.assigned_assets'),
      // The app bar already says "Salesman Assets"; the in-body heading and
      // its subtitle only repeated it — same as the other module screens.
      showHeader: false,
      // Filtered by state, not by date: an asset is a possession, not an
      // event, so a date window would hide a laptop issued long ago that the
      // salesman is still holding.
      topSlot: Obx(
        () => StatusFilterBar(
          options: controller.filterOptions,
          // Read in the closure, not only inside the bar: Obx registers what
          // its own builder touches.
          selected: controller.statusFilter.value,
          onSelected: controller.selectStatus,
        ),
      ),
    );
  }
}
