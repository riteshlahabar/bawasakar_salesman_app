import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/login_controller.dart';
import '../../../../app/localization/t.dart';

/// Email/password card with the login button, for [LoginView].
class LoginFormCard extends StatelessWidget {
  const LoginFormCard({super.key, required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('common.email'),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: t('auth.salesman_email'),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t('auth.password'),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Obx(
            () => TextField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              onSubmitted: (_) => controller.login(),
              decoration: InputDecoration(
                hintText: t('auth.password'),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: controller.togglePassword,
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(t('auth.login')),
            ),
          ),
        ],
      ),
    );
  }
}
