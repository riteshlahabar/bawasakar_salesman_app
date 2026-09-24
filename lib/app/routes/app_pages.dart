import 'package:get/get.dart';

import '../../modules/advances/bindings/advances_binding.dart';
import '../../modules/advances/views/advances_view.dart';
import '../../modules/announcements/bindings/announcements_binding.dart';
import '../../modules/announcements/views/announcements_view.dart';
import '../../modules/assets/bindings/assets_binding.dart';
import '../../modules/assets/views/assets_view.dart';
import '../../modules/attendance/bindings/attendance_binding.dart';
import '../../modules/attendance/views/attendance_view.dart';
import '../../modules/auth/bindings/login_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/delivery/bindings/delivery_binding.dart';
import '../../modules/delivery/views/delivery_view.dart';
import '../../modules/documents/bindings/documents_binding.dart';
import '../../modules/documents/views/documents_view.dart';
import '../../modules/expenses/bindings/expenses_binding.dart';
import '../../modules/expenses/views/expenses_view.dart';
import '../../modules/holidays/bindings/holidays_binding.dart';
import '../../modules/holidays/views/holidays_view.dart';
import '../../modules/incentives/bindings/incentives_binding.dart';
import '../../modules/incentives/views/incentives_view.dart';
import '../../modules/invoices/bindings/invoices_binding.dart';
import '../../modules/invoices/views/invoices_view.dart';
import '../../modules/language/bindings/language_binding.dart';
import '../../modules/language/views/language_view.dart';
import '../../modules/leave/bindings/leave_binding.dart';
import '../../modules/leave/views/leave_view.dart';
import '../../modules/main_shell/bindings/main_shell_binding.dart';
import '../../modules/main_shell/views/main_shell_view.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/payslips/bindings/payslip_detail_binding.dart';
import '../../modules/payslips/bindings/payslips_binding.dart';
import '../../modules/orders/views/order_detail_view.dart';
import '../../modules/payslips/views/payslip_detail_view.dart';
import '../../modules/payslips/views/payslips_view.dart';
import '../../modules/performance/bindings/performance_binding.dart';
import '../../modules/performance/views/performance_view.dart';
import '../../modules/products/bindings/products_binding.dart';
import '../../modules/products/views/products_view.dart';
import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_view.dart';
import '../../modules/reports/bindings/reports_binding.dart';
import '../../modules/reports/views/reports_view.dart';
import '../../modules/resignation/bindings/resignation_binding.dart';
import '../../modules/resignation/views/resignation_view.dart';
import '../../modules/salary/bindings/salary_binding.dart';
import '../../modules/salary/views/salary_view.dart';
import '../../modules/salary_revisions/bindings/salary_revisions_binding.dart';
import '../../modules/salary_revisions/views/salary_revisions_view.dart';
import '../../modules/shifts/bindings/shifts_binding.dart';
import '../../modules/shifts/views/shifts_view.dart';
import '../../modules/skills/bindings/skills_binding.dart';
import '../../modules/skills/views/skills_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/support/bindings/support_binding.dart';
import '../../modules/support/views/support_view.dart';
import '../../modules/targets/bindings/targets_binding.dart';
import '../../modules/targets/views/targets_view.dart';
import '../../modules/tasks/bindings/tasks_binding.dart';
import '../../modules/tasks/views/tasks_view.dart';
import '../../modules/tour_plan/bindings/tour_plan_binding.dart';
import '../../modules/tour_plan/views/tour_plan_view.dart';
import '../../modules/training/bindings/training_binding.dart';
import '../../modules/training/views/training_view.dart';
import '../../modules/visits/bindings/visits_binding.dart';
import '../../modules/visits/views/visits_view.dart';
import '../widgets/nav_shell.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => const NavShell(child: AttendanceView()),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.visits,
      page: () => const NavShell(child: VisitsView()),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.expenses,
      page: () => const NavShell(child: ExpensesView()),
      binding: ExpensesBinding(),
    ),
    GetPage(
      name: AppRoutes.leave,
      page: () => const NavShell(child: LeaveView()),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: AppRoutes.salary,
      page: () => const NavShell(child: SalaryView()),
      binding: SalaryBinding(),
    ),
    GetPage(
      name: AppRoutes.targets,
      page: () => const NavShell(child: TargetsView()),
      binding: TargetsBinding(),
    ),
    GetPage(
      name: AppRoutes.tourPlan,
      page: () => const NavShell(child: TourPlanView()),
      binding: TourPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.assets,
      page: () => const NavShell(child: AssetsView()),
      binding: AssetsBinding(),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const NavShell(child: ReportsView()),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NavShell(child: NotificationsView()),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const NavShell(child: ProductsView()),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: AppRoutes.delivery,
      page: () => const NavShell(child: DeliveryView()),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: AppRoutes.payslips,
      page: () => const NavShell(child: PayslipsView()),
      binding: PayslipsBinding(),
    ),
    GetPage(
      name: AppRoutes.advances,
      page: () => const NavShell(child: AdvancesView()),
      binding: AdvancesBinding(),
    ),
    GetPage(
      name: AppRoutes.incentives,
      page: () => const NavShell(child: IncentivesView()),
      binding: IncentivesBinding(),
    ),
    GetPage(
      name: AppRoutes.performance,
      page: () => const NavShell(child: PerformanceView()),
      binding: PerformanceBinding(),
    ),
    GetPage(
      name: AppRoutes.announcements,
      page: () => const NavShell(child: AnnouncementsView()),
      binding: AnnouncementsBinding(),
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const NavShell(child: DocumentsView()),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.holidays,
      page: () => const NavShell(child: HolidaysView()),
      binding: HolidaysBinding(),
    ),
    GetPage(
      name: AppRoutes.shifts,
      page: () => const NavShell(child: ShiftsView()),
      binding: ShiftsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const NavShell(child: ProfileView()),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const NavShell(child: SupportView()),
      binding: SupportBinding(),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const NavShell(child: LanguageView()),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: AppRoutes.payslipDetail,
      page: () => const NavShell(child: PayslipDetailView()),
      binding: PayslipDetailBinding(),
    ),
    // No binding: the screen reads the order from its route argument and
    // reuses the shell's OrdersController (registered with fenix) for
    // Forward and Reject.
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const NavShell(child: OrderDetailView()),
    ),
    GetPage(
      name: AppRoutes.invoices,
      page: () => const NavShell(child: InvoicesView()),
      binding: InvoicesBinding(),
    ),
    GetPage(
      name: AppRoutes.salaryRevisions,
      page: () => const NavShell(child: SalaryRevisionsView()),
      binding: SalaryRevisionsBinding(),
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => const NavShell(child: TasksView()),
      binding: TasksBinding(),
    ),
    GetPage(
      name: AppRoutes.skills,
      page: () => const NavShell(child: SkillsView()),
      binding: SkillsBinding(),
    ),
    GetPage(
      name: AppRoutes.training,
      page: () => const NavShell(child: TrainingView()),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: AppRoutes.resignation,
      page: () => const NavShell(child: ResignationView()),
      binding: ResignationBinding(),
    ),
  ];
}
