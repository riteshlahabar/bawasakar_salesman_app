import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
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

  String get name =>
      _storage.name.isNotEmpty ? _storage.name : t('common.salesman');
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

  /// Department, Designation, Joining Date and Employment Status are all
  /// Employee Profile items in the Phase 1 spec. They have always been on the
  /// `salesman_profiles` row; the first two only became nameable once the API
  /// started eager-loading their relations (2026-09-24) — before that the
  /// response carried bare ids.
  String get department => _related('department');

  String get designation => _related('designation');

  String get reportingManager => _related('reporting_manager');

  /// `dd-mm-yyyy`, like every other date in this app.
  String get joiningDate =>
      ModuleRowMapper.date(_salesmanProfile['joining_date']);

  /// `active`, `notice_period`, … title-cased for display.
  String get employmentStatus => ModuleRowMapper.statusLabel(
    _salesmanProfile['employment_status']?.toString() ?? '',
  );

  Map<String, dynamic> get _salesmanProfile {
    final user = profile['user'];
    if (user is Map && user['salesman_profile'] is Map) {
      return Map<String, dynamic>.from(user['salesman_profile'] as Map);
    }
    return const {};
  }

  /// The `name` of an eager-loaded relation on the salesman profile, or an
  /// empty string when it was not loaded or is not set.
  String _related(String key) {
    final value = _salesmanProfile[key];

    return value is Map ? value['name']?.toString() ?? '' : '';
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
