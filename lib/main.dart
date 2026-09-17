import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'app/core/security/flutter_secure_key_value_store.dart';
import 'app/core/security/secure_key_value_store.dart';
import 'app/data/services/auth_storage.dart';
import 'app/localization/locale_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<SecureKeyValueStore>(
    const FlutterSecureKeyValueStore(),
    permanent: true,
  );
  await Get.putAsync<AuthStorage>(
    () => AuthStorage(Get.find<SecureKeyValueStore>()).init(),
  );

  // Loaded before the first frame so the app opens in the saved language.
  await Get.putAsync<LocaleStorage>(() => LocaleStorage().init());

  runApp(const SalesmanApp());
}
