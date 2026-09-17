import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/salesman_auth_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/localization/t.dart';

class ProfileController extends GetxController {
  ProfileController(this._api, this._storage);

  final SalesmanAuthService _api;
  final AuthStorage _storage;

  final isLoading = false.obs;
  final profile = <String, dynamic>{}.obs;

  String get name => _storage.name.isNotEmpty ? _storage.name : t('common.salesman');
  String get mobile => _storage.mobile;
  String get email => _storage.email;

  String get employeeCode {
    final fromServer = _salesmanProfile['employee_code']?.toString() ?? '';
    return fromServer.isNotEmpty ? fromServer : _storage.employeeCode;
  }

  String get territory {
    final fromServer = _salesmanProfile['territory']?.toString() ?? '';
    return fromServer.isNotEmpty ? fromServer : _storage.territory;
  }

  Map<String, dynamic> get _salesmanProfile {
    final user = profile['user'];
    if (user is Map && user['salesman_profile'] is Map) {
      return Map<String, dynamic>.from(user['salesman_profile'] as Map);
    }
    return const {};
  }

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await _api.profile();
      profile.value = Map<String, dynamic>.from(
        (response['data'] ?? const {}) as Map,
      );
    } catch (_) {
      profile.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
