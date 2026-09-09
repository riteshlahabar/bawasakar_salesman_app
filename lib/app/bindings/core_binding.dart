import 'package:get/get.dart';

import '../core/security/get_session_expiry_handler.dart';
import '../core/security/session_expiry_handler.dart';
import '../data/services/api_client.dart';
import '../data/services/auth_storage.dart';
import '../data/services/salesman_attendance_service.dart';
import '../data/services/salesman_auth_service.dart';
import '../data/services/salesman_dashboard_service.dart';
import '../data/services/salesman_finance_service.dart';
import '../data/services/salesman_hr_service.dart';
import '../data/services/salesman_order_service.dart';

/// Wires the app-wide singletons.
///
/// The services are deliberately narrow — a controller asks for the one it
/// needs and gets nothing else, so a screen that only reads payslips cannot
/// accidentally reach the order-creation API. That is interface segregation
/// enforced by the container rather than by convention.
class CoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionExpiryHandler>(
      () => GetSessionExpiryHandler(Get.find<AuthStorage>()),
      fenix: true,
    );

    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<AuthStorage>(),
        onExpired: Get.find<SessionExpiryHandler>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SalesmanAuthService>(
      () => SalesmanAuthService(Get.find<ApiClient>(), Get.find<AuthStorage>()),
      fenix: true,
    );
    Get.lazyPut<SalesmanDashboardService>(
      () => SalesmanDashboardService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SalesmanOrderService>(
      () => SalesmanOrderService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SalesmanAttendanceService>(
      () => SalesmanAttendanceService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SalesmanFinanceService>(
      () => SalesmanFinanceService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SalesmanHrService>(
      () => SalesmanHrService(Get.find<ApiClient>()),
      fenix: true,
    );
  }
}
