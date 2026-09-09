import 'dart:async';

import 'package:get/get.dart';

import '../../config/api_config.dart';
import '../../core/error/api_exception.dart';
import '../../core/security/session_expiry_handler.dart';
import 'auth_storage.dart';

export '../../core/error/api_exception.dart' show ApiException;

/// Single transport used by every service in the app.
///
/// It owns exactly three concerns: attaching the bearer token, refusing
/// non-TLS traffic, and turning a raw response into either a decoded map or an
/// [ApiException]. Business rules live in the services above it.
class ApiClient extends GetConnect {
  ApiClient(this._storage, {SessionExpiryHandler? onExpired})
      // ignore: prefer_initializing_formals
      : _onExpired = onExpired;

  final AuthStorage _storage;
  final SessionExpiryHandler? _onExpired;

  @override
  void onInit() {
    ApiConfig.assertSecureBaseUrl();
    httpClient.baseUrl = ApiConfig.baseUrl;
    httpClient.timeout = const Duration(seconds: ApiConfig.timeoutSeconds);
    httpClient.maxAuthRetries = 0;
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['X-Requested-With'] = 'XMLHttpRequest';
      final token = _storage.token;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
    super.onInit();
  }

  Future<Map<String, dynamic>> getJson(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    return _handle(await get(endpoint, query: _normalizeQuery(query)));
  }

  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _handle(await post(endpoint, body));
  }

  Future<Map<String, dynamic>> putJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _handle(await put(endpoint, body));
  }

  Future<Map<String, dynamic>> deleteJson(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    return _handle(await delete(endpoint, query: _normalizeQuery(query)));
  }

  /// GetConnect only accepts strings in the query map, so collections are
  /// flattened here rather than at each of the dozens of call sites.
  Map<String, dynamic>? _normalizeQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    return query.map((key, value) {
      if (value is Iterable) {
        return MapEntry(key, value.map((item) => item.toString()).toList());
      }
      return MapEntry(key, value.toString());
    });
  }

  Map<String, dynamic> _handle(Response<dynamic> response) {
    final body = response.body;
    final status = response.statusCode ?? 0;

    if (response.isOk && body is Map<String, dynamic>) return body;

    if (status == 401) {
      // Fire and forget: the caller still gets its exception, but the app-level
      // handler simultaneously wipes the dead session and returns to login.
      final expiry = _onExpired?.onSessionExpired();
      if (expiry != null) unawaited(expiry);
    }

    if (body is Map<String, dynamic>) {
      final message = body['message']?.toString() ??
          body['error']?.toString() ??
          'Request failed';
      throw ApiException(message, status, body);
    }

    throw ApiException(
      response.statusText?.isNotEmpty == true
          ? response.statusText!
          : 'Network request failed',
      status,
      const {},
    );
  }
}
