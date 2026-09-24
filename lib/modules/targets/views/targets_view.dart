import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/targets_controller.dart';
import '../../../app/localization/t.dart';

class TargetsView extends GetView<TargetsController> {
  const TargetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('targets.target_periods'),
      // The app bar already says "Targets"; the in-body heading and its
      // subtitle only repeated it.
      showHeader: false,
      // Its own Obx: RemoteModuleView's watches rows/isLoading, and this
      // widget is built out here, outside that closure.
      topSlot: Obx(() {
        // Read the observables here, not only inside the bar: Obx registers
        // what its own closure touches.
        controller.mode.value;
        controller.month.value;
        controller.from.value;
        controller.to.value;

        // No Today chip: a target covers a period, so a single-day window
        // would almost always read as empty.
        return DateFilterBar(controller: controller);
      }),
    );
  }
}
