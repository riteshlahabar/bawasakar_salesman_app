import 'package:shared_preferences/shared_preferences.dart';

import 'app_locales.dart';

/// Remembers the language the salesman picked.
///
/// The choice is a display preference, not a secret, so it lives in
/// SharedPreferences rather than the secure store — and it survives logout, so
/// the login screen itself stays in the chosen language.
class LocaleStorage {
  static const _key = 'salesman_locale';

  String _current = AppLocales.fallback;

  String get current => _current;

  bool get isDefault => _current == AppLocales.fallback;

  Future<LocaleStorage> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);

      if (saved != null && AppLocales.isSupported(saved)) {
        _current = saved;
      }
    } catch (_) {
      // A missing preference just means English.
    }

    return this;
  }

  Future<void> save(String locale) async {
    if (!AppLocales.isSupported(locale)) return;

    _current = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale);
    } catch (_) {
      // Best effort: the in-memory value still applies for this session.
    }
  }
}
