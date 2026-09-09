import '../../config/api_config.dart';
import 'api_client.dart';
import 'auth_storage.dart';

/// Sign-in and sign-out for the salesman session.
class SalesmanAuthService {
  SalesmanAuthService(this._client, this._storage);

  final ApiClient _client;
  final AuthStorage _storage;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _client.postJson(ApiConfig.login, {
      'email': email.trim(),
      'password': password,
    });
  }

  /// Clears the device session even when the server call fails, so a user on a
  /// dead network is never left signed in on a shared handset.
  Future<void> logout() async {
    try {
      await _client.postJson(ApiConfig.logout, const {});
    } on ApiException {
      // Local logout must still succeed if the server is unreachable.
    }
    await _storage.clear();
  }

  Future<Map<String, dynamic>> profile() =>
      _client.getJson(ApiConfig.profile);
}
