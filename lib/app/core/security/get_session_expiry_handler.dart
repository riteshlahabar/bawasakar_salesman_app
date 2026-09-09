import 'package:get/get.dart';

import '../../data/services/auth_storage.dart';
import '../../routes/app_routes.dart';
import 'session_expiry_handler.dart';

/// Wipes the session and returns to login when the backend answers 401.
///
/// Guarded so a burst of parallel requests that all fail cannot trigger a
/// stack of login screens.
class GetSessionExpiryHandler implements SessionExpiryHandler {
  GetSessionExpiryHandler(this._storage);

  final AuthStorage _storage;
  bool _handling = false;

  @override
  Future<void> onSessionExpired() async {
    if (_handling) return;
    _handling = true;
    try {
      await _storage.clear();
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed<void>(AppRoutes.login);
      }
    } finally {
      _handling = false;
    }
  }
}
