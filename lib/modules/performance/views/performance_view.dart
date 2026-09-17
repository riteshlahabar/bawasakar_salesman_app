import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/performance_controller.dart';
import '../../../app/localization/t.dart';

class PerformanceView extends GetView<PerformanceController> {
  const PerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('performance.review_history'),
    );
  }
}
