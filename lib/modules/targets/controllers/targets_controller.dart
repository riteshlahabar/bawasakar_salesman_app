import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class TargetsController extends ModuleController {
  TargetsController()
    : super(
        title: 'Targets',
        subtitle:
            'Monthly sales target, dealer activation, collection target, performance and commission tracking.',
        actionLabel: 'View Target Detail',
        actionIcon: Icons.flag,
        initialRows: const [
          ListRowModel(
            title: 'Monthly Sales Target',
            subtitle: 'Achieved ₹8.4L of ₹12L',
            trailing: '70%',
            icon: Icons.flag,
            status: 'On Track',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Collection Target',
            subtitle: 'Achieved ₹4.8L of ₹7L',
            trailing: '69%',
            icon: Icons.payments,
            status: 'Follow-up',
            color: AppColors.accent,
          ),
          ListRowModel(
            title: 'New Dealer Activation',
            subtitle: '3 activated of 5 assigned',
            trailing: '3/5',
            icon: Icons.group_add,
            status: 'Pending',
            color: AppColors.info,
          ),
        ],
      );
}
