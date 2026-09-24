import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/login_controller.dart';
import 'widgets/login_form_card.dart';
import 'widgets/login_header.dart';
import '../../../app/localization/t.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Light status-bar icons, since the artwork behind them is dark green.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primarySoft, Colors.white],
            ),
          ),
          // No SafeArea: the artwork runs edge to edge, under the status bar.
          child: SingleChildScrollView(
            child: Column(
              children: [
                const LoginHeader(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
                  child: Column(
                    children: [
                      LoginFormCard(controller: controller),
                      const SizedBox(height: 24),
                      Text(
                        t('auth.use_the_salesman_account_created_by'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
