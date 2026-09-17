/// The languages the apps and the ERP agree on.
///
/// The server is the real source of truth (admin → Languages), and
/// `GET /app-translations` returns `available_locales`; this list is the offline
/// fallback and supplies the native names for the picker.
class AppLocales {
  const AppLocales._();

  static const String fallback = 'en';

  static const Map<String, String> names = <String, String>{
    'en': 'English',
    'hi': 'हिन्दी',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'pa': 'ਪੰਜਾਬੀ',
    'te': 'తెలుగు',
  };

  static const Map<String, String> englishNames = <String, String>{
    'en': 'English',
    'hi': 'Hindi',
    'mr': 'Marathi',
    'gu': 'Gujarati',
    'pa': 'Punjabi',
    'te': 'Telugu',
  };

  static List<String> get codes => names.keys.toList();

  static bool isSupported(String code) => names.containsKey(code);

  static String nameOf(String code) => names[code] ?? code.toUpperCase();

  static String englishNameOf(String code) => englishNames[code] ?? code.toUpperCase();
}
