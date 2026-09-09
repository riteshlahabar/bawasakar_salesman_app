/// Abstraction over encrypted key/value persistence.
///
/// Controllers and services depend on this interface, never on a concrete
/// plugin, so the storage backend can be swapped (or faked in tests) without
/// touching a single caller. This is the "D" of SOLID applied to persistence.
abstract class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> deleteAll();
}
