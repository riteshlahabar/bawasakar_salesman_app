import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/incentives_controller.dart';
import '../../../app/localization/t.dart';

class IncentivesView extends GetView<IncentivesController> {
  const IncentivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('incentives.monthly_earnings'),
    );
  }
}
