import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Leave Applications',
    );
  }
}
