class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const main = '/main';
  static const attendance = '/attendance';
  static const visits = '/visits';
  static const expenses = '/expenses';
  static const leave = '/leave';
  static const salary = '/salary';
  static const targets = '/targets';
  static const tourPlan = '/tour-plan';
  // static const assets = '/assets';
  static const reports = '/reports';
  static const notifications = '/notifications';
  static const products = '/products';
  static const delivery = '/delivery';

  /// Pushed with the tapped [SalesmanOrderModel] as its route argument —
  /// the orders list already holds every detail this screen shows.
  static const orderDetail = '/orders/detail';

  /// Pushed with the tapped [ProductModel] as its route argument, for the
  /// same reason: the catalog list already holds every variant and price.
  static const productDetail = '/products/detail';

  // Phase 5 HRMS modules from the Phase 1 specification.
  // Merged into Salary 2026-09-24 — /salary now reads the same payslips
  // endpoint. [payslipDetail] stays: it is the breakdown screen Salary opens.
  // static const payslips = '/payslips';
  static const payslipDetail = '/payslips/detail';
  static const advances = '/advances';

  /// Pushed with the tapped advance/loan record as its route argument — the
  /// list response already carries the whole record, EMI schedule included.
  static const advanceDetail = '/advances/detail';
  static const incentives = '/incentives';
  static const performance = '/performance';
  static const announcements = '/announcements';
  // static const documents = '/documents';
  static const holidays = '/holidays';
  // static const shifts = '/shifts';
  static const profile = '/profile';
  static const support = '/support';
  static const language = '/language';

  // Phase 5-7 HRMS gaps closed 2026-09-19.
  static const invoices = '/invoices';
  static const tasks = '/tasks';

  // Commented out 2026-09-24: Assets (#15), Shifts (#3), Salary Revisions
  // (#6), Skill Records and Training (#16) and Resignation & Exit (#19) are
  // all admin-panel-only HRMS modules in the Phase 1 spec — none of them
  // appears in its salesman-facing HRMS list. The screens, bindings, views
  // and ERP endpoints are all untouched; uncomment these constants, their
  // GetPage entries in app_pages.dart and their drawer entries in
  // main_shell_nav_config.dart to restore them.
  // static const salaryRevisions = '/salary-revisions';
  // static const skills = '/skills';
  // static const training = '/training';
  // static const resignation = '/resignation';
}
