import 'package:get/get.dart';

import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';

class SplashController
    extends GetxController {
  final AuthStorage _storage = Get.find<AuthStorage>();

  final SalesmanDashboardService _api = Get.find<SalesmanDashboardService>();

  @override
  void onReady() {
    super.onReady();

    _start();
  }

  Future<void> _start() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 600,
      ),
    );

    final hasToken =
        _storage.hasToken;

    if (!hasToken) {
      Get.offAllNamed(
        AppRoutes.login,
      );
      return;
    }

    // Validate stored token against Laravel.
    try {
      await _api.dashboard();

      Get.offAllNamed(
        AppRoutes.main,
      );
    } catch (_) {
      await _storage.clear();

      Get.offAllNamed(
        AppRoutes.login,
      );
    }
  }
}