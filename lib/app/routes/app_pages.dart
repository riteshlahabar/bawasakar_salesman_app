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
import '../../modules/leave/bindings/leave_binding.dart';
import '../../modules/leave/views/leave_view.dart';
import '../../modules/main_shell/bindings/main_shell_binding.dart';
import '../../modules/main_shell/views/main_shell_view.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/payslips/bindings/payslips_binding.dart';
import '../../modules/payslips/views/payslips_view.dart';
import '../../modules/performance/bindings/performance_binding.dart';
import '../../modules/performance/views/performance_view.dart';
import '../../modules/products/bindings/products_binding.dart';
import '../../modules/products/views/products_view.dart';
import '../../modules/reports/bindings/reports_binding.dart';
import '../../modules/reports/views/reports_view.dart';
import '../../modules/salary/bindings/salary_binding.dart';
import '../../modules/salary/views/salary_view.dart';
import '../../modules/shifts/bindings/shifts_binding.dart';
import '../../modules/shifts/views/shifts_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/targets/bindings/targets_binding.dart';
import '../../modules/targets/views/targets_view.dart';
import '../../modules/tour_plan/bindings/tour_plan_binding.dart';
import '../../modules/tour_plan/views/tour_plan_view.dart';
import '../../modules/visits/bindings/visits_binding.dart';
import '../../modules/visits/views/visits_view.dart';
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
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: AppRoutes.visits,
      page: () => const VisitsView(),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.expenses,
      page: () => const ExpensesView(),
      binding: ExpensesBinding(),
    ),
    GetPage(
      name: AppRoutes.leave,
      page: () => const LeaveView(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: AppRoutes.salary,
      page: () => const SalaryView(),
      binding: SalaryBinding(),
    ),
    GetPage(
      name: AppRoutes.targets,
      page: () => const TargetsView(),
      binding: TargetsBinding(),
    ),
    GetPage(
      name: AppRoutes.tourPlan,
      page: () => const TourPlanView(),
      binding: TourPlanBinding(),
    ),
    GetPage(
      name: AppRoutes.assets,
      page: () => const AssetsView(),
      binding: AssetsBinding(),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: AppRoutes.delivery,
      page: () => const DeliveryView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: AppRoutes.payslips,
      page: () => const PayslipsView(),
      binding: PayslipsBinding(),
    ),
    GetPage(
      name: AppRoutes.advances,
      page: () => const AdvancesView(),
      binding: AdvancesBinding(),
    ),
    GetPage(
      name: AppRoutes.incentives,
      page: () => const IncentivesView(),
      binding: IncentivesBinding(),
    ),
    GetPage(
      name: AppRoutes.performance,
      page: () => const PerformanceView(),
      binding: PerformanceBinding(),
    ),
    GetPage(
      name: AppRoutes.announcements,
      page: () => const AnnouncementsView(),
      binding: AnnouncementsBinding(),
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentsView(),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.holidays,
      page: () => const HolidaysView(),
      binding: HolidaysBinding(),
    ),
    GetPage(
      name: AppRoutes.shifts,
      page: () => const ShiftsView(),
      binding: ShiftsBinding(),
    ),
  ];
}
