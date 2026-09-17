import 'package:get/get.dart';

import 'app_strings_en.dart';
import 'translation_service.dart';

/// Short global helper so a view reads `t('cart.title')` rather than reaching
/// into the container itself.
///
/// Pass [params] for strings with placeholders: `t('cart.only_left', {'n': '3'})`
/// fills `{n}` in both the translated text and the English fallback, so a
/// translator never has to reproduce Dart string interpolation.
///
/// It never throws: if the service is not registered yet (very early startup,
/// or a widget test) the bundled English text is returned.
String t(String key, [Map<String, String>? params]) {
  final value = Get.isRegistered<TranslationService>()
      ? Get.find<TranslationService>().translate(key)
      : (kAppStringsEn[key] ?? key);

  if (params == null || params.isEmpty) return value;

  var result = value;
  params.forEach((name, replacement) {
    result = result.replaceAll('{$name}', replacement);
  });

  return result;
}
