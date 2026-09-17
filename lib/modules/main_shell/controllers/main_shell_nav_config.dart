import 'package:flutter/material.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Static navigation config for [MainShellController] — the bottom-nav
/// tabs, tab titles and drawer shortcuts. Kept out of the controller since
/// none of it is reactive state.
class MainShellNavConfig {
  const MainShellNavConfig._();

  static List<String> get tabTitles => [
    t('common.dashboard'),
    t('common.assigned_dealers'),
    t('common.orders'),
    t('common.payment_collection'),
  ];

  static List<BottomNavigationBarItem> get navItems => [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: t('common.home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.storefront_outlined),
      activeIcon: Icon(Icons.storefront),
      label: t('common.dealers'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: t('common.orders'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.payments_outlined),
      activeIcon: Icon(Icons.payments),
      label: t('main_shell.collect'),
    ),
  ];

  static List<ActionItemModel> get drawerItems => [
    ActionItemModel(
      title: t('common.attendance'),
      subtitle: t('main_shell.gps_check_in_and_working_hours'),
      icon: Icons.location_on_outlined,
      route: AppRoutes.attendance,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: t('main_shell.dealer_visits'),
      subtitle: t('main_shell.visit_assigned_dealers'),
      icon: Icons.route_outlined,
      route: AppRoutes.visits,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: t('common.expenses'),
      subtitle: t('main_shell.travel_fuel_and_other_claims'),
      icon: Icons.account_balance_wallet_outlined,
      route: AppRoutes.expenses,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: t('main_shell.leave'),
      subtitle: t('main_shell.apply_and_view_leave'),
      icon: Icons.event_available_outlined,
      route: AppRoutes.leave,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: t('common.salary'),
      subtitle: t('main_shell.payslip_and_earnings'),
      icon: Icons.currency_rupee,
      route: AppRoutes.salary,
      color: AppColors.primaryDark,
    ),
    ActionItemModel(
      title: t('main_shell.targets'),
      subtitle: t('main_shell.monthly_performance_targets'),
      icon: Icons.flag_outlined,
      route: AppRoutes.targets,
      color: AppColors.danger,
    ),
    ActionItemModel(
      title: t('common.tour_plan'),
      subtitle: t('main_shell.daily_route_schedule'),
      icon: Icons.map_outlined,
      route: AppRoutes.tourPlan,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: t('common.assets'),
      subtitle: t('main_shell.company_issued_assets'),
      icon: Icons.inventory_2_outlined,
      route: AppRoutes.assets,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: t('common.products'),
      subtitle: t('main_shell.dealer_price_catalog'),
      icon: Icons.medication_outlined,
      route: AppRoutes.products,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: t('main_shell.delivery_tracking'),
      subtitle: t('main_shell.dispatch_and_delivery'),
      icon: Icons.local_shipping_outlined,
      route: AppRoutes.delivery,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: t('common.payslips'),
      subtitle: t('main_shell.released_monthly_payslips'),
      icon: Icons.description_outlined,
      route: AppRoutes.payslips,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: t('common.advance_and_loan'),
      subtitle: t('main_shell.request_and_track_recovery'),
      icon: Icons.request_quote_outlined,
      route: AppRoutes.advances,
      color: AppColors.orange,
    ),
    ActionItemModel(
      title: t('common.incentives'),
      subtitle: t('main_shell.commission_and_bonuses'),
      icon: Icons.emoji_events_outlined,
      route: AppRoutes.incentives,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: t('common.performance'),
      subtitle: t('main_shell.kpi_scores_and_reviews'),
      icon: Icons.insights_outlined,
      route: AppRoutes.performance,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: t('common.announcements'),
      subtitle: t('main_shell.company_notices_and_circulars'),
      icon: Icons.campaign_outlined,
      route: AppRoutes.announcements,
      color: AppColors.primary,
    ),
    ActionItemModel(
      title: t('common.my_documents'),
      subtitle: t('main_shell.identity_and_employment_papers'),
      icon: Icons.folder_shared_outlined,
      route: AppRoutes.documents,
      color: AppColors.accent,
    ),
    ActionItemModel(
      title: t('main_shell.holidays'),
      subtitle: t('main_shell.company_holiday_calendar'),
      icon: Icons.event_available_outlined,
      route: AppRoutes.holidays,
      color: AppColors.success,
    ),
    ActionItemModel(
      title: t('common.my_shift'),
      subtitle: t('main_shell.working_hours_and_weekly_off'),
      icon: Icons.schedule_outlined,
      route: AppRoutes.shifts,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: t('common.my_profile'),
      subtitle: t('main_shell.employee_code_territory_and_contact'),
      icon: Icons.person_outline_rounded,
      route: AppRoutes.profile,
      color: AppColors.primaryDark,
    ),
    ActionItemModel(
      title: t('common.help_and_support'),
      subtitle: t('common.raise_a_support_ticket'),
      icon: Icons.support_agent_rounded,
      route: AppRoutes.support,
      color: AppColors.info,
    ),
    ActionItemModel(
      title: t('menu.language'),
      subtitle: t('menu.language_subtitle'),
      icon: Icons.translate_rounded,
      route: AppRoutes.language,
      color: AppColors.primary,
    ),
  ];
}
