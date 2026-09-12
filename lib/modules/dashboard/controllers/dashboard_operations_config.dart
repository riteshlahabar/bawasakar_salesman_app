import 'package:flutter/material.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

/// Static "Operations" shortcut row shown on [DashboardView]. Kept out of
/// the controller since none of it is reactive state.
class DashboardOperationsConfig {
  const DashboardOperationsConfig._();

  static const operations = [
    ActionItemModel(
      title: 'Attendance',
      subtitle: 'GPS',
      icon: Icons.my_location,
      route: AppRoutes.attendance,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: 'Visit',
      subtitle: 'Dealer',
      icon: Icons.route,
      route: AppRoutes.visits,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: 'Products',
      subtitle: 'Catalog',
      icon: Icons.inventory_2_outlined,
      route: AppRoutes.products,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: 'Expense',
      subtitle: 'Claim',
      icon: Icons.account_balance_wallet_outlined,
      route: AppRoutes.expenses,
      color: AppColors.info,
    ),
  ];
}
