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
    // Admin-only per the Phase 1 spec — Asset Management is HRMS module #15
    // under "HRMS Modules (Admin Panel)" and is not in the salesman-facing
    // HRMS list. Screen, route and API are all still in place; re-enable this
    // entry to bring it back.
    // ActionItemModel(
    //   title: t('common.assets'),
    //   subtitle: t('main_shell.company_issued_assets'),
    //   icon: Icons.inventory_2_outlined,
    //   route: AppRoutes.assets,
    //   color: AppColors.orange,
    // ),
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
    // Commented out 2026-09-24 — merged into Salary, which now reads the same
    // /salesman/payslips endpoint and owns the tappable breakdown screen.
    // Two menus listed the same SalarySlip rows; this was the duplicate.
    // ActionItemModel(
    //   title: t('common.payslips'),
    //   subtitle: t('main_shell.released_monthly_payslips'),
    //   icon: Icons.description_outlined,
    //   route: AppRoutes.payslips,
    //   color: AppColors.primary,
    // ),
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
    // Commented out 2026-09-24 at the user's request — kept in the admin panel
    // only (HRMS module #18, Document Management). Note this one differs from
    // the other six: the Phase 1 spec does list "Documents" in its
    // salesman-facing HRMS list, so this is a deliberate product decision
    // rather than a spec correction.
    // ActionItemModel(
    //   title: t('common.my_documents'),
    //   subtitle: t('main_shell.identity_and_employment_papers'),
    //   icon: Icons.folder_shared_outlined,
    //   route: AppRoutes.documents,
    //   color: AppColors.accent,
    // ),
    ActionItemModel(
      title: t('main_shell.holidays'),
      subtitle: t('main_shell.company_holiday_calendar'),
      icon: Icons.event_available_outlined,
      route: AppRoutes.holidays,
      color: AppColors.success,
    ),
    // Admin-only per the Phase 1 spec — Shift Management is HRMS module #3
    // under "HRMS Modules (Admin Panel)".
    // ActionItemModel(
    //   title: t('common.my_shift'),
    //   subtitle: t('main_shell.working_hours_and_weekly_off'),
    //   icon: Icons.schedule_outlined,
    //   route: AppRoutes.shifts,
    //   color: AppColors.info,
    // ),
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
      title: t('invoices.invoices'),
      subtitle: t('main_shell.invoices_for_billed_orders'),
      icon: Icons.receipt_long_outlined,
      route: AppRoutes.invoices,
      color: AppColors.primary,
    ),
    // Admin-only per the Phase 1 spec — "Salary Revision" is a line item of
    // HRMS module #6 (Salary Management) under "HRMS Modules (Admin Panel)".
    // ActionItemModel(
    //   title: t('salary_revisions.salary_revisions'),
    //   subtitle: t('main_shell.basic_salary_change_history'),
    //   icon: Icons.trending_up_outlined,
    //   route: AppRoutes.salaryRevisions,
    //   color: AppColors.primaryDark,
    // ),
    ActionItemModel(
      title: t('tasks.tasks_title'),
      subtitle: t('main_shell.assigned_tasks'),
      icon: Icons.task_alt_outlined,
      route: AppRoutes.tasks,
      color: AppColors.orange,
    ),
    // Admin-only per the Phase 1 spec — Skill Records and Training are both
    // line items of HRMS module #16 (Training Management), and Resignation &
    // Exit is HRMS module #19, all under "HRMS Modules (Admin Panel)".
    // ActionItemModel(
    //   title: t('skills.skill_records'),
    //   subtitle: t('main_shell.skills_and_certifications'),
    //   icon: Icons.workspace_premium_outlined,
    //   route: AppRoutes.skills,
    //   color: AppColors.success,
    // ),
    // ActionItemModel(
    //   title: t('training.training_title'),
    //   subtitle: t('main_shell.training_programs_and_certificates'),
    //   icon: Icons.school_outlined,
    //   route: AppRoutes.training,
    //   color: AppColors.info,
    // ),
    // ActionItemModel(
    //   title: t('resignation.resignation_and_exit'),
    //   subtitle: t('main_shell.resignation_and_full_final_settlement'),
    //   icon: Icons.logout_outlined,
    //   route: AppRoutes.resignation,
    //   color: AppColors.danger,
    // ),
    ActionItemModel(
      title: t('menu.language'),
      subtitle: t('menu.language_subtitle'),
      icon: Icons.translate_rounded,
      route: AppRoutes.language,
      color: AppColors.primary,
    ),
  ];
}
