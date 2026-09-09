import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class ReportsController extends ModuleController {
  ReportsController()
    : super(
        title: 'Reports',
        subtitle:
            'Sales, dealer, attendance, expense, salary, order, collection, commission, and delivery reports.',
        actionLabel: 'Download Report',
        actionIcon: Icons.download,
        initialRows: const [
          ListRowModel(
            title: 'Sales Report',
            subtitle: 'Daily, monthly, dealer-wise and product-wise',
            trailing: 'View',
            icon: Icons.bar_chart,
            status: 'Ready',
            color: AppColors.primary,
          ),
          ListRowModel(
            title: 'Collection Report',
            subtitle: 'Cash, UPI, online, outstanding and receipts',
            trailing: 'View',
            icon: Icons.payments,
            status: 'Ready',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Attendance Report',
            subtitle: 'Present, late, half day, absent and working hours',
            trailing: 'View',
            icon: Icons.calendar_month,
            status: 'Ready',
            color: AppColors.info,
          ),
        ],
      );
}
