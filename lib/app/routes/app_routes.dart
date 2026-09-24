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
  static const assets = '/assets';
  static const reports = '/reports';
  static const notifications = '/notifications';
  static const products = '/products';
  static const delivery = '/delivery';

  /// Pushed with the tapped [SalesmanOrderModel] as its route argument —
  /// the orders list already holds every detail this screen shows.
  static const orderDetail = '/orders/detail';

  // Phase 5 HRMS modules from the Phase 1 specification.
  static const payslips = '/payslips';
  static const payslipDetail = '/payslips/detail';
  static const advances = '/advances';
  static const incentives = '/incentives';
  static const performance = '/performance';
  static const announcements = '/announcements';
  static const documents = '/documents';
  static const holidays = '/holidays';
  static const shifts = '/shifts';
  static const profile = '/profile';
  static const support = '/support';
  static const language = '/language';

  // Phase 5-7 HRMS gaps closed 2026-09-19.
  static const invoices = '/invoices';
  static const salaryRevisions = '/salary-revisions';
  static const tasks = '/tasks';
  static const skills = '/skills';
  static const training = '/training';
  static const resignation = '/resignation';
}
