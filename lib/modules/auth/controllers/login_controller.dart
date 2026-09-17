import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/salesman_auth_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/localization/t.dart';

class LoginController
    extends GetxController {
  final SalesmanAuthService _api = Get.find<SalesmanAuthService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final isLoading = false.obs;

  final obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value =
        !obscurePassword.value;
  }

  Future<void> login() async {
    if (isLoading.value) {
      return;
    }

    final email =
        emailController.text.trim();

    final password =
        passwordController.text;

    if (!GetUtils.isEmail(
      email,
    )) {
      Get.snackbar(
        t('auth.invalid_email'),
        t('auth.enter_a_valid_salesman_email_address'),
      );
      return;
    }

    if (password.trim().isEmpty) {
      Get.snackbar(
        t('auth.password_required'),
        t('auth.enter_your_password'),
      );
      return;
    }

    isLoading.value = true;

    try {
      final response =
          await _api.login(
        email: email,
        password: password,
      );

      final rawData =
          response['data'];

      if (rawData is! Map) {
        throw FormatException(
          t('auth.invalid_login_response'),
        );
      }

      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      final token =
          data['token']
                  ?.toString()
                  .trim() ??
              '';

      final rawUser =
          data['user'];

      if (token.isEmpty ||
          rawUser is! Map) {
        throw FormatException(
          t('auth.login_token_or_salesman_information_missing'),
        );
      }

      final user =
          Map<String, dynamic>.from(
        rawUser,
      );

      await _storage.saveSession(
        token: token,
        user: user,
      );

      passwordController.clear();

      Get.offAllNamed(
        AppRoutes.main,
      );
    } catch (error) {
      Get.snackbar(
        t('auth.login_failed'),
        _message(
          error,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _message(
    Object error,
  ) {
    var message =
        error.toString();

    if (message.startsWith(
      'Exception: ',
    )) {
      message = message.substring(
        'Exception: '.length,
      );
    }

    return message;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}