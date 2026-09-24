import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/app_assets.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // The splash artwork already carries the branding, so it fills the whole
    // screen — status bar included — instead of a logo on a white ground.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(AppAssets.splashScreen, fit: BoxFit.cover),
      ),
    );
  }
}
