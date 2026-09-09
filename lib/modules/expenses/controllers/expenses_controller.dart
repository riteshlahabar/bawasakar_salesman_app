import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class ExpensesController extends ModuleController {
  ExpensesController()
    : super(
        title: 'Expenses',
        subtitle:
            'Travel, fuel, food, hotel, mobile and other expenses with receipt upload and approval.',
        actionLabel: 'Add Expense',
        actionIcon: Icons.add_card,
        initialRows: const [
          ListRowModel(
            title: 'Fuel Expense',
            subtitle: 'Ahmednagar route • Receipt uploaded',
            trailing: '₹1,250',
            icon: Icons.local_gas_station,
            status: 'Pending',
            color: AppColors.accent,
          ),
          ListRowModel(
            title: 'Food Expense',
            subtitle: 'Dealer visit day allowance',
            trailing: '₹320',
            icon: Icons.restaurant,
            status: 'Approved',
            color: AppColors.success,
          ),
          ListRowModel(
            title: 'Mobile Bill',
            subtitle: 'Monthly reimbursement',
            trailing: '₹499',
            icon: Icons.phone_android,
            status: 'Draft',
            color: AppColors.info,
          ),
        ],
      );
}
