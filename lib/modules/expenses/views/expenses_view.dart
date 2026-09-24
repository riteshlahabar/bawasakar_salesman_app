import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/date_filter_bar.dart';
import '../../../app/widgets/remote_module_view.dart';
import '../controllers/expenses_controller.dart';
import '../../../app/localization/t.dart';

class ExpensesView extends GetView<ExpensesController> {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: t('expenses.expense_claims'),
      // The app bar already says "Expenses"; the in-body heading and its
      // subtitle only repeated it — same as Attendance and Dealer Visits.
      showHeader: false,
      // Its own Obx: RemoteModuleView's watches rows/isLoading, and this
      // widget is built out here, outside that closure.
      topSlot: Obx(() {
        // Read the observables here, not only inside the bar: Obx registers
        // what its own closure touches.
        controller.mode.value;
        controller.month.value;
        controller.from.value;
        controller.to.value;

        return DateFilterBar(controller: controller, showToday: true);
      }),
    );
  }
}
