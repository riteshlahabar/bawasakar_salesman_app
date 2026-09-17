import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the last downloaded translation map per language so the app opens
/// already translated and still works offline.
///
/// The salesman app has no file cache, and a few hundred short labels fit
/// comfortably in SharedPreferences, so no new package is needed.
class TranslationCache {
  Future<Map<String, dynamic>?> read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return null;

      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      // A corrupt entry just means English until the next refresh.
      return null;
    }
  }

  Future<void> write(String key, Map<String, dynamic> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(value));
    } catch (_) {
      // Best effort: the in-memory map still applies for this session.
    }
  }
}
