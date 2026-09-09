import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class AssetsController extends ModuleController {
  AssetsController()
    : super(
        title: 'Salesman Assets',
        subtitle:
            'Company assets issued to salesman: laptop, mobile, SIM, bag, ID card, product samples, and return condition.',
        actionLabel: 'Asset Acknowledgement',
        actionIcon: Icons.assignment_turned_in,
        initialRows: const [
          ListRowModel(
            title: 'Samsung Mobile',
            subtitle: 'Serial SM-A556 • Issued 01 Jul • Good condition',
            trailing: '₹18,500',
            icon: Icons.phone_android,
            status: 'Issued',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Company SIM',
            subtitle: 'Mobile 9876543210 • Active plan',
            trailing: 'Active',
            icon: Icons.sim_card,
            status: 'Issued',
            color: AppColors.info,
          ),
          ListRowModel(
            title: 'Field Bag',
            subtitle: 'Marketing kit and product samples',
            trailing: 'Good',
            icon: Icons.work_outline,
            status: 'Issued',
            color: AppColors.accent,
          ),
        ],
      );
}
