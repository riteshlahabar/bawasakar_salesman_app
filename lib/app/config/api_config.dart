import 'package:flutter/foundation.dart';

/// Backend endpoint catalogue for the salesman (HRMS + field sales) app.
///
/// The host is supplied at build time (`--dart-define=API_BASE_URL=...`) so a
/// staging build never ships pointing at production, and vice versa.
class ApiConfig {
  ApiConfig._();

  // Android emulator: http://10.0.2.2:8000/api/v1
  // Physical device: your PC/server IP, or the live domain below.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://drbawasakar.turnkeyinfotech.live/api/v1',
  );

  static const int timeoutSeconds = 30;

  /// Refuses to start a release build that would send bearer tokens over
  /// plaintext HTTP. Debug builds may still target a local `http://` server.
  static void assertSecureBaseUrl() {
    if (kReleaseMode && !baseUrl.startsWith('https://')) {
      throw StateError(
        'Insecure API_BASE_URL "$baseUrl": release builds require HTTPS.',
      );
    }
  }

  // --- Auth -----------------------------------------------------------------
  static const String login = '/auth/salesman/login';
  static const String logout = '/auth/logout';

  // --- Dashboard & field ----------------------------------------------------
  static const String dashboard = '/salesman/dashboard';
  static const String dealers = '/salesman/dealers';
  static const String orders = '/salesman/orders';
  static const String deliveries = '/salesman/deliveries';
  static const String collections = '/salesman/collections';

  static String forwardOrder(int orderId) =>
      '/salesman/orders/$orderId/forward-to-admin';
  static String rejectOrder(int orderId) => '/salesman/orders/$orderId/reject';
  static String orderAvailability(int orderId) =>
      '/salesman/orders/$orderId/availability';

  // --- Translations -------------------------------------------------------
  static const String appTranslations = '/app-translations';
  static const String appTranslationsRegister = '/app-translations/register';

  // --- Catalogue ------------------------------------------------------------
  static const String categories = '/catalog/categories';
  static const String products = '/catalog/products';
  static const String homepage = '/catalog/homepage';

  // --- Attendance & visits --------------------------------------------------
  static const String checkIn = '/salesman/attendance/check-in';
  static const String checkOut = '/salesman/attendance/check-out';
  static const String startBreak = '/salesman/attendance/break';
  static const String resumeBreak = '/salesman/attendance/resume';
  static const String attendance = '/salesman/attendance';
  static const String visits = '/salesman/visits';
  static const String tourPlans = '/salesman/tour-plans';

  // --- Finance --------------------------------------------------------------
  static const String expenses = '/salesman/expenses';
  static const String salary = '/salesman/salary';
  static const String targets = '/salesman/targets';
  static const String payslips = '/salesman/payslips';
  static const String advances = '/salesman/advances';
  static const String loans = '/salesman/loans';
  static const String incentives = '/salesman/incentives';

  static String payslip(int id) => '/salesman/payslips/$id';

  static const String salaryRevisions = '/salesman/salary-revisions';

  // --- HR -------------------------------------------------------------------
  static const String leaves = '/salesman/leaves';
  static const String leaveBalance = '/salesman/leaves/balance';
  static const String assets = '/salesman/assets';
  static const String holidays = '/salesman/holidays';
  static const String shifts = '/salesman/shifts';
  static const String announcements = '/salesman/announcements';
  static const String documents = '/salesman/documents';
  static const String performance = '/salesman/performance';
  static const String profile = '/salesman/profile';
  static const String support = '/salesman/support';

  static const String tasks = '/salesman/tasks';
  static String taskUpdate(int id) => '/salesman/tasks/$id';

  static const String skills = '/salesman/skills';

  static const String trainings = '/salesman/trainings';
  static String trainingCertificate(int id) =>
      '/salesman/trainings/$id/certificate';

  static const String resignation = '/salesman/resignation';

  // --- Invoices ---------------------------------------------------------------
  static const String invoices = '/salesman/invoices';
  static String invoicePdf(int id) => '/salesman/invoices/$id/pdf';

  // --- Notifications --------------------------------------------------------
  static const String notifications = '/salesman/notifications';
  static const String notificationsRead = '/salesman/notifications/read';
}
