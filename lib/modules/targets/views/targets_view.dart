import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/targets_controller.dart';

class TargetsView extends GetView<TargetsController> {
  const TargetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Target Periods',
    );
  }
}
