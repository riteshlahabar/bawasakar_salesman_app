import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class VisitsController extends ModuleController {
  VisitsController()
    : super(
        title: 'Dealer Visits',
        subtitle:
            'Dealer route, GPS visit check in, discussion notes, order follow-up, and next visit date.',
        actionLabel: 'Start Dealer Visit',
        actionIcon: Icons.add_location_alt,
        initialRows: const [
          ListRowModel(
            title: 'Shree Agro Center',
            subtitle: '10:30 AM • Outstanding follow-up and new order',
            trailing: '2.4 km',
            icon: Icons.route,
            status: 'Next',
            color: AppColors.primary,
          ),
          ListRowModel(
            title: 'Kisan Krushi Seva',
            subtitle: '12:15 PM • Collection promise date update',
            trailing: '6.8 km',
            icon: Icons.storefront,
            status: 'Planned',
            color: AppColors.info,
          ),
          ListRowModel(
            title: 'Farmer Care Agency',
            subtitle: 'Visited • Notes synced with server',
            trailing: 'Done',
            icon: Icons.check_circle,
            status: 'Synced',
            color: AppColors.success,
          ),
        ],
      );
}
