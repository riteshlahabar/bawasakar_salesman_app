import '../config/api_config.dart';
import '../data/services/api_client.dart';

/// Talks to the app-translation endpoints on the ERP (`app_translations`).
///
/// The app never asks the server to translate anything: it registers its
/// English text, and reads whatever the admin Translate button has filled in.
/// Both calls are plain database reads/writes, so they never time out.
class TranslationApiService {
  TranslationApiService(this._client);

  /// Which app's rows to use on the shared `app_translations` table.
  static const appKey = 'salesman';

  final ApiClient _client;

  /// Every finished translation for this app and locale, plus the languages on offer.
  Future<({Map<String, String> translations, List<String> locales})> fetch(
    String locale,
  ) async {
    final response = await _client.getJson(
      ApiConfig.appTranslations,
      query: {'app': appKey, 'locale': locale},
    );
    final data = response['data'];
    final map = data is Map<String, dynamic> ? data : const <String, dynamic>{};

    return (
      translations: _stringMap(map['translations']),
      locales: _stringList(map['available_locales']),
    );
  }

  /// Stores the app's English labels on the server so the admin can translate them.
  Future<void> register(Map<String, String> items) async {
    await _client.postJson(ApiConfig.appTranslationsRegister, {
      'app': appKey,
      'items': items,
    });
  }

  Map<String, String> _stringMap(Object? raw) {
    if (raw is! Map) return const <String, String>{};

    final result = <String, String>{};
    raw.forEach((key, value) {
      final text = value?.toString() ?? '';
      if (text.isNotEmpty) result[key.toString()] = text;
    });

    return result;
  }

  List<String> _stringList(Object? raw) {
    if (raw is! List) return const <String>[];

    return raw
        .map((item) => item?.toString() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
