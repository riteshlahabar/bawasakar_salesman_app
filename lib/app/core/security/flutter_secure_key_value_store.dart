import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_key_value_store.dart';

/// Hardware-backed implementation of [SecureKeyValueStore].
///
/// On Android the values live in EncryptedSharedPreferences (AES via the
/// Android Keystore); on iOS they live in the Keychain and are only readable
/// once the device has been unlocked at least once since boot. Auth tokens
/// must never sit in plain SharedPreferences, which is world-readable on a
/// rooted device and is copied by ADB backups.
class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  const FlutterSecureKeyValueStore([
    this._storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  ]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
