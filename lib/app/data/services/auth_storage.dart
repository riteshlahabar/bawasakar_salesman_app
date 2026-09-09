import 'package:shared_preferences/shared_preferences.dart';

import '../../core/security/secure_key_value_store.dart';

/// Holds the signed-in salesman's session.
///
/// Values are persisted through an injected [SecureKeyValueStore] (Keystore on
/// Android, Keychain on iOS) and mirrored into memory so reads are cheap and
/// synchronous. Nothing here touches a plugin directly, so the whole class is
/// testable with a fake store.
class AuthStorage {
  AuthStorage(this._store);

  static const _tokenKey = 'salesman_token';
  static const _nameKey = 'salesman_name';
  static const _emailKey = 'salesman_email';
  static const _mobileKey = 'salesman_mobile';
  static const _employeeCodeKey = 'salesman_employee_code';
  static const _territoryKey = 'salesman_territory';

  static const _keys = <String>[
    _tokenKey,
    _nameKey,
    _emailKey,
    _mobileKey,
    _employeeCodeKey,
    _territoryKey,
  ];

  final SecureKeyValueStore _store;
  final Map<String, String> _cache = <String, String>{};

  Future<AuthStorage> init() async {
    for (final key in _keys) {
      final value = await _store.read(key);
      if (value != null && value.isNotEmpty) _cache[key] = value;
    }
    await _migrateLegacyPlaintextSession();
    return this;
  }

  String get token => _cache[_tokenKey] ?? '';
  String get name => _cache[_nameKey] ?? '';
  String get email => _cache[_emailKey] ?? '';
  String get mobile => _cache[_mobileKey] ?? '';
  String get employeeCode => _cache[_employeeCodeKey] ?? '';
  String get territory => _cache[_territoryKey] ?? '';

  bool get hasToken => token.isNotEmpty;

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final rawProfile = user['salesman_profile'];
    final profile = rawProfile is Map
        ? Map<String, dynamic>.from(rawProfile)
        : <String, dynamic>{};

    await _put(_tokenKey, token);
    await _put(_nameKey, user['name']?.toString() ?? '');
    await _put(_emailKey, user['email']?.toString() ?? '');
    await _put(_mobileKey, user['mobile']?.toString() ?? '');
    await _put(_employeeCodeKey, profile['employee_code']?.toString() ?? '');
    await _put(_territoryKey, profile['territory']?.toString() ?? '');
  }

  Future<void> clear() async {
    _cache.clear();
    for (final key in _keys) {
      await _store.delete(key);
    }
  }

  Future<void> _put(String key, String rawValue) async {
    final value = rawValue.trim();
    if (value.isEmpty) {
      _cache.remove(key);
      await _store.delete(key);
      return;
    }
    _cache[key] = value;
    await _store.write(key, value);
  }

  /// Moves a session written by an older build out of SharedPreferences, where
  /// it sat unencrypted, and erases the plaintext copy. Runs once: after the
  /// move the legacy keys no longer exist.
  Future<void> _migrateLegacyPlaintextSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_tokenKey)) return;

    for (final key in _keys) {
      final legacy = prefs.getString(key);
      if (legacy != null && legacy.isNotEmpty && !_cache.containsKey(key)) {
        await _put(key, legacy);
      }
      await prefs.remove(key);
    }
  }
}
