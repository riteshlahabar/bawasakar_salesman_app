import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class SalaryController extends ModuleController {
  SalaryController()
    : super(
        title: 'Salary',
        subtitle:
            'Basic salary, allowances, bonus, incentives, commission, advance, loan, deductions, and payslip.',
        actionLabel: 'View Payslip',
        actionIcon: Icons.description,
        initialRows: const [
          ListRowModel(
            title: 'July Net Salary',
            subtitle: 'Basic + allowance + incentive - deductions',
            trailing: '₹38,420',
            icon: Icons.currency_rupee,
            status: 'Generated',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Commission',
            subtitle: 'Target slab incentive for July',
            trailing: '₹6,800',
            icon: Icons.trending_up,
            status: 'Earned',
            color: AppColors.primary,
          ),
          ListRowModel(
            title: 'Advance',
            subtitle: 'Remaining balance deduction',
            trailing: '₹2,000',
            icon: Icons.remove_circle_outline,
            status: 'Deduct',
            color: AppColors.danger,
          ),
        ],
      );
}
