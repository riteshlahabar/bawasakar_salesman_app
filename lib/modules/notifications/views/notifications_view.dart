import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Inbox',
    );
  }
}
