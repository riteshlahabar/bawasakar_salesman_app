import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/remote_module_view.dart';
import '../controllers/expenses_controller.dart';

class ExpensesView extends GetView<ExpensesController> {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteModuleView(
      controller: controller,
      recordsTitle: 'Expense Claims',
    );
  }
}
