import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/holidays_controller.dart';
import '../../../app/localization/t.dart';

class HolidaysView extends GetView<HolidaysController> {
  const HolidaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('holidays.holiday_list'),
    );
  }
}
