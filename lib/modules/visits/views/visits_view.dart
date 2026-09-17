import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    );
  }
}
