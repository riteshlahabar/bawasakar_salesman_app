import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../../../app/widgets/status_filter_bar.dart';
import '../controllers/advances_controller.dart';
import '../../../app/localization/t.dart';

class AdvancesView extends GetView<AdvancesController> {
  const AdvancesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('advances.advances_and_loans'),
      // The app bar already says "Advance & Loan"; the in-body heading and
      // its subtitle only repeated it — same as the other module screens.
      showHeader: false,
      // Filtered by state, not by date: an advance still being recovered from
      // last year is exactly the row the salesman came to see, and a date
      // window would hide it.
      topSlot: Obx(
        () => StatusFilterBar(
          options: controller.filterOptions,
          // Read in the closure, not only inside the bar: Obx registers what
          // its own builder touches.
          selected: controller.statusFilter.value,
          onSelected: controller.selectStatus,
        ),
      ),
    );
  }
}
