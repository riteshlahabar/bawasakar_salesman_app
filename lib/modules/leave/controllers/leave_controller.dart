import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class LeaveController extends ModuleController {
  LeaveController()
    : super(
        title: 'Leave Management',
        subtitle:
            'Leave application, approval, leave balance, and leave history.',
        actionLabel: 'Apply Leave',
        actionIcon: Icons.event_available,
        initialRows: const [
          ListRowModel(
            title: 'Casual Leave',
            subtitle: 'Available balance',
            trailing: '4 days',
            icon: Icons.event_note,
            status: 'Available',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Sick Leave',
            subtitle: 'Available balance',
            trailing: '2 days',
            icon: Icons.medical_services,
            status: 'Available',
            color: AppColors.info,
          ),
          ListRowModel(
            title: '22 Jul Leave',
            subtitle: 'Personal work • Approved by admin',
            trailing: '1 day',
            icon: Icons.verified,
            status: 'Approved',
            color: AppColors.success,
          ),
        ],
      );
}
