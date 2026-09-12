import 'package:flutter/material.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

/// Static navigation config for [MainShellController] — the bottom-nav
/// tabs, tab titles and drawer shortcuts. Kept out of the controller since
/// none of it is reactive state.
class MainShellNavConfig {
  const MainShellNavConfig._();

  static const tabTitles = [
    'Dashboard',
    'Assigned Dealers',
    'Orders',
    'Payment Collection',
  ];

  static const navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.storefront_outlined),
      activeIcon: Icon(Icons.storefront),
      label: 'Dealers',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.payments_outlined),
      activeIcon: Icon(Icons.payments),
      label: 'Collect',
    ),
  ];

  static const drawerItems = [
    ActionItemModel(
      title: 'Attendance',
      subtitle: 'GPS check in and working hours',
      icon: Icons.location_on_outlined,
      route: AppRoutes.attendance,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: 'Dealer Visits',
      subtitle: 'Visit assigned dealers',
      icon: Icons.route_outlined,
      route: AppRoutes.visits,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: 'Expenses',
      subtitle: 'Travel, fuel and other claims',
      icon: Icons.account_balance_wallet_outlined,
      route: AppRoutes.expenses,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: 'Leave',
      subtitle: 'Apply and view leave',
      icon: Icons.event_available_outlined,
      route: AppRoutes.leave,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: 'Salary',
      subtitle: 'Payslip and earnings',
      icon: Icons.currency_rupee,
      route: AppRoutes.salary,
      color: AppColors.primaryDark,
    ),
    ActionItemModel(
      title: 'Targets',
      subtitle: 'Monthly performance targets',
      icon: Icons.flag_outlined,
      route: AppRoutes.targets,
      color: AppColors.danger,
    ),
    ActionItemModel(
      title: 'Tour Plan',
      subtitle: 'Daily route schedule',
      icon: Icons.map_outlined,
      route: AppRoutes.tourPlan,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: 'Assets',
      subtitle: 'Company issued assets',
      icon: Icons.inventory_2_outlined,
      route: AppRoutes.assets,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: 'Products',
      subtitle: 'Dealer price catalog',
      icon: Icons.medication_outlined,
      route: AppRoutes.products,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: 'Delivery Tracking',
      subtitle: 'Dispatch and delivery',
      icon: Icons.local_shipping_outlined,
      route: AppRoutes.delivery,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: 'Payslips',
      subtitle: 'Released monthly payslips',
      icon: Icons.description_outlined,
      route: AppRoutes.payslips,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: 'Advance & Loan',
      subtitle: 'Request and track recovery',
      icon: Icons.request_quote_outlined,
      route: AppRoutes.advances,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: 'Incentives',
      subtitle: 'Commission and bonuses',
      icon: Icons.emoji_events_outlined,
      route: AppRoutes.incentives,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: 'Performance',
      subtitle: 'KPI scores and reviews',
      icon: Icons.insights_outlined,
      route: AppRoutes.performance,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: 'Announcements',
      subtitle: 'Company notices and circulars',
      icon: Icons.campaign_outlined,
      route: AppRoutes.announcements,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: 'My Documents',
      subtitle: 'Identity and employment papers',
      icon: Icons.folder_shared_outlined,
      route: AppRoutes.documents,
      color: AppColors.accent,
    ),
    ActionItemModel(
      title: 'Holidays',
      subtitle: 'Company holiday calendar',
      icon: Icons.event_available_outlined,
      route: AppRoutes.holidays,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: 'My Shift',
      subtitle: 'Working hours and weekly off',
      icon: Icons.schedule_outlined,
      route: AppRoutes.shifts,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: 'My Profile',
      subtitle: 'Employee code, territory and contact',
      icon: Icons.person_outline_rounded,
      route: AppRoutes.profile,
      color: AppColors.primaryDark,
    ),
    ActionItemModel(
      title: 'Help & Support',
      subtitle: 'Raise a support ticket',
      icon: Icons.support_agent_rounded,
      route: AppRoutes.support,
      color: AppColors.info,
    ),
  ];
}
