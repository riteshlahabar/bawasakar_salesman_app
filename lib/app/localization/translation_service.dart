import 'translation_cache.dart';
import 'app_locales.dart';
import 'app_strings_en.dart';
import 'locale_storage.dart';
import 'translation_api_service.dart';

/// Resolves every UI label for the chosen language.
///
/// Lookup order is: translated value for the active locale, then the bundled
/// English text, then the key itself. A missing translation therefore degrades
/// to readable English instead of a blank screen, which is why the app stays
/// usable offline and on the very first launch.
class TranslationService {
  TranslationService(this._api, this._storage, this._cache);

  final TranslationApiService _api;
  final LocaleStorage _storage;
  final TranslationCache _cache;

  static const _keysHashCacheKey = 'salesman_translation_keys';

  Map<String, String> _active = const <String, String>{};
  List<String> _availableLocales = AppLocales.codes;

  String get locale => _storage.current;

  List<String> get availableLocales => _availableLocales;

  /// Reads the cached map so the first frame is already translated, then
  /// refreshes from the server in the background.
  Future<void> load() async {
    if (_storage.current == AppLocales.fallback) {
      _active = const <String, String>{};
      return;
    }

    _active = await _readCache(_storage.current);
  }

  /// Registers the app's English text (only when it changed) and downloads the
  /// translations the admin has produced. Failures are swallowed: the cached
  /// or English text keeps showing.
  Future<void> refresh() async {
    await _registerKeys();

    final locale = _storage.current;

    if (locale == AppLocales.fallback) {
      _active = const <String, String>{};
      return;
    }

    try {
      final remote = await _api.fetch(locale);

      if (remote.locales.isNotEmpty) {
        _availableLocales = remote.locales;
      }

      // Replaced, not merged, so admin corrections and disabled rows apply.
      _active = remote.translations;
      await _writeCache(locale, _active);
    } catch (_) {
      // Keep whatever is already cached.
    }
  }

  /// Switches language: saves the choice, then loads that language's strings.
  Future<bool> change(String locale) async {
    if (!AppLocales.isSupported(locale)) return false;

    await _storage.save(locale);

    if (locale == AppLocales.fallback) {
      _active = const <String, String>{};
      return true;
    }

    _active = await _readCache(locale);
    await refresh();

    return _active.isNotEmpty;
  }

  String translate(String key, [String? fallback]) {
    final value = _active[key];

    if (value != null && value.isNotEmpty) return value;

    return fallback ?? kAppStringsEn[key] ?? key;
  }

  /// Sends the English strings once per app version: the server stores them
  /// for the admin's Translate button. Skipped while the key set is unchanged.
  Future<void> _registerKeys() async {
    final hash = _keysHash();

    try {
      final saved = await _cache.read(_keysHashCacheKey);
      if (saved?['hash'] == hash) return;

      await _api.register(kAppStringsEn);
      await _cache.write(_keysHashCacheKey, <String, dynamic>{'hash': hash});
    } catch (_) {
      // Retried on the next refresh.
    }
  }

  /// FNV-1a over every key and English text — stable across app runs, unlike
  /// `String.hashCode`, so an unchanged app never re-registers.
  static String _keysHash() {
    var hash = 0x811c9dc5;

    for (final entry in kAppStringsEn.entries) {
      for (final unit in '${entry.key}=${entry.value};'.codeUnits) {
        hash ^= unit;
        hash = (hash * 0x01000193) & 0xffffffff;
      }
    }

    return hash.toRadixString(16);
  }

  String _cacheKey(String locale) => 'salesman_translations_$locale';

  Future<Map<String, String>> _readCache(String locale) async {
    final cached = await _cache.read(_cacheKey(locale));

    if (cached == null) return <String, String>{};

    return <String, String>{
      for (final entry in cached.entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value.toString(),
    };
  }

  Future<void> _writeCache(String locale, Map<String, String> value) =>
      _cache.write(_cacheKey(locale), value);
}
