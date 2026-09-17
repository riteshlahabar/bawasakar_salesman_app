import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/payslips_controller.dart';
import '../../../app/localization/t.dart';

class PayslipsView extends GetView<PayslipsController> {
  const PayslipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('payslips.payslip_history'),
    );
  }
}
