import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    );
  }
}
