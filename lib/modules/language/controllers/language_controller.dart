import 'package:get/get.dart';

import '../../../app/localization/app_locales.dart';
import '../../../app/localization/translation_service.dart';

/// Lets the salesman pick the language the app and product names appear in.
class LanguageController extends GetxController {
  LanguageController(this._translations);

  final TranslationService _translations;

  final selected = ''.obs;
  final isApplying = false.obs;

  List<String> get locales {
    final fromServer = _translations.availableLocales
        .where(AppLocales.isSupported)
        .toList();

    return fromServer.isEmpty ? AppLocales.codes : fromServer;
  }

  @override
  void onInit() {
    selected.value = _translations.locale;
    super.onInit();
  }

  Future<void> choose(String locale) async {
    if (isApplying.value || locale == selected.value) return;

    isApplying.value = true;
    try {
      await _translations.change(locale);
      selected.value = _translations.locale;
      // Rebuilds every screen with the new strings.
      Get.forceAppUpdate();
    } finally {
      isApplying.value = false;
    }
  }
}
