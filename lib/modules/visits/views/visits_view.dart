import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/visits_controller.dart';
import '../../../app/localization/t.dart';

class VisitsView extends GetView<VisitsController> {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('visits.visit_log'),
      // The app bar already says "Dealer Visits"; the in-body heading and its
      // subtitle only repeated it — same as Attendance.
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

        return DateFilterBar(controller: controller, showToday: true);
      }),
    );
  }
}
