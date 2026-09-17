import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/assets_controller.dart';
import '../../../app/localization/t.dart';

class AssetsView extends GetView<AssetsController> {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('assets.assigned_assets'),
    );
  }
}
