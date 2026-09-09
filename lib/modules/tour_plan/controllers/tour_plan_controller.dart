import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class TourPlanController extends ModuleController {
  TourPlanController()
    : super(
        title: 'Tour Plan',
        subtitle:
            'Daily route plan, assigned dealers, GPS route, planned visits, and admin approval.',
        actionLabel: 'Create Tour Plan',
        actionIcon: Icons.add_road,
        initialRows: const [
          ListRowModel(
            title: 'Ahmednagar Route',
            subtitle: '6 dealers • 82 km • Approved',
            trailing: 'Today',
            icon: Icons.map,
            status: 'Approved',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Pune Rural Route',
            subtitle: '9 dealers • 146 km • Pending approval',
            trailing: 'Tomorrow',
            icon: Icons.route,
            status: 'Pending',
            color: AppColors.accent,
          ),
          ListRowModel(
            title: 'Nashik Follow-up',
            subtitle: 'High outstanding dealers',
            trailing: 'Fri',
            icon: Icons.schedule,
            status: 'Draft',
            color: AppColors.info,
          ),
        ],
      );
}
