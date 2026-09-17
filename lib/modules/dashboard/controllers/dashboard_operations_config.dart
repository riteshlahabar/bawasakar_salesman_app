import 'package:flutter/material.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Static "Operations" shortcut row shown on [DashboardView]. Kept out of
/// the controller since none of it is reactive state.
class DashboardOperationsConfig {
  const DashboardOperationsConfig._();

  static List<ActionItemModel> get operations => [
    ActionItemModel(
      title: t('common.attendance'),
      subtitle: t('dashboard.gps'),
      icon: Icons.my_location,
      route: AppRoutes.attendance,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: t('dashboard.visit'),
      subtitle: t('common.dealer'),
      icon: Icons.route,
      route: AppRoutes.visits,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: t('common.products'),
      subtitle: t('dashboard.catalog'),
      icon: Icons.inventory_2_outlined,
      route: AppRoutes.products,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: t('dashboard.expense'),
      subtitle: t('dashboard.claim'),
      icon: Icons.account_balance_wallet_outlined,
      route: AppRoutes.expenses,
      color: AppColors.info,
    ),
  ];
}
