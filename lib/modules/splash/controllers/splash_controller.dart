import 'dart:async';

import 'package:get/get.dart';

import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/localization/translation_service.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthStorage _storage = Get.find<AuthStorage>();

  final SalesmanDashboardService _api = Get.find<SalesmanDashboardService>();

  @override
  void onReady() {
    super.onReady();

    _loadTranslations();
    _start();
  }

  /// The splash already waits five seconds, so the cached strings load and the
  /// server refresh runs before the first real screen is drawn.
  Future<void> _loadTranslations() async {
    if (!Get.isRegistered<TranslationService>()) return;

    final translations = Get.find<TranslationService>();
    await translations.load();
    unawaited(translations.refresh());
  }

  Future<void> _start() async {
    await Future<void>.delayed(const Duration(seconds: 5));

    final hasToken = _storage.hasToken;

    if (!hasToken) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // Validate stored token against Laravel.
    try {
      await _api.dashboard();

      Get.offAllNamed(AppRoutes.main);
    } catch (_) {
      await _storage.clear();

      Get.offAllNamed(AppRoutes.login);
    }
  }
}
