import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/list_row_model.dart';

class ModuleController extends GetxController {
  ModuleController({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionIcon,
    required List<ListRowModel> initialRows,
  }) : rows = initialRows.obs;

  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData actionIcon;
  final RxList<ListRowModel> rows;

  void primaryAction() {
    Get.snackbar(title, '$actionLabel form will connect with Laravel API.');
  }
}
