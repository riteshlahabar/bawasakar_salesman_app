import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/app_assets.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(AppAssets.appLogo, width: 130, height: 130),
      ),
    );
  }
}
