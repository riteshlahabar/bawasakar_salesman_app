import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/leave_controller.dart';
import '../../../app/localization/t.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('leave.leave_applications'),
      // The app bar already says "Leave"; the in-body heading and its
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

        // No Today chip: leave is applied for in blocks of days, so a
        // single-day window would almost always read as empty.
        return DateFilterBar(controller: controller);
      }),
    );
  }
}
