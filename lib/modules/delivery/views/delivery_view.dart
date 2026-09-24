import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/delivery_controller.dart';
import '../../../app/localization/t.dart';

class DeliveryView extends GetView<DeliveryController> {
  const DeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('delivery.dispatches'),
      // The app bar already says "Delivery Tracking".
      showHeader: false,
      topSlot: Obx(() {
        // Read the observables in this closure: Obx registers only what its
        // own builder touches, never what a child widget reads later.
        controller.mode.value;
        controller.month.value;
        controller.from.value;
        controller.to.value;

        return DateFilterBar(controller: controller, showToday: true);
      }),
    );
  }
}
