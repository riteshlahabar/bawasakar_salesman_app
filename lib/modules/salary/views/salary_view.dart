import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/salary_controller.dart';

class SalaryView extends GetView<SalaryController> {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Salary Slips',
    );
  }
}
