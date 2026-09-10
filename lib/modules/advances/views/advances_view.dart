import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/advances_controller.dart';

class AdvancesView extends GetView<AdvancesController> {
  const AdvancesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Advances & Loans',
    );
  }
}
