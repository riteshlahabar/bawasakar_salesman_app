import 'package:get/get.dart';

import '../../../app/localization/translation_service.dart';
import '../controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(
      () => LanguageController(Get.find<TranslationService>()),
    );
  }
}
