import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/tour_plan_controller.dart';
import '../../../app/localization/t.dart';

class TourPlanView extends GetView<TourPlanController> {
  const TourPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('tour_plan.planned_routes'),
      // The app bar already says "Tour Plan"; the in-body heading and its
      // subtitle only repeated it — same as Attendance, Visits and Expenses.
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

        // No Today chip: a tour plan covers a day that is usually not today.
        return DateFilterBar(controller: controller, showToday: false);
      }),
    );
  }
}
