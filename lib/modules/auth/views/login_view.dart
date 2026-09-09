import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView
    extends GetView<LoginController> {
  const LoginView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment.topCenter,
            end:
                Alignment.bottomCenter,
            colors: [
              AppColors.primarySoft,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              22,
              50,
              22,
              30,
            ),
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.primary,
                    borderRadius:
                        BorderRadius
                            .circular(
                      26,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: .22,
                        ),
                        blurRadius: 24,
                        offset:
                            const Offset(
                          0,
                          10,
                        ),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons
                        .business_center_rounded,
                    size: 46,
                    color:
                        Colors.white,
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                const Text(
                  'Bawaskar Salesman',
                  style: TextStyle(
                    color: AppColors
                        .textPrimary,
                    fontSize: 25,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                const Text(
                  'Salesman ERP Login',
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets
                          .all(
                    20,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                      24,
                    ),
                    border:
                        Border.all(
                      color: AppColors
                          .border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withValues(
                          alpha: .04,
                        ),
                        blurRadius: 18,
                        offset:
                            const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Email',
                        style:
                            TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      TextField(
                        controller:
                            controller
                                .emailController,
                        keyboardType:
                            TextInputType
                                .emailAddress,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Salesman email',
                          prefixIcon:
                              Icon(
                            Icons
                                .email_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      const Text(
                        'Password',
                        style:
                            TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Obx(
                        () =>
                            TextField(
                          controller:
                              controller
                                  .passwordController,
                          obscureText:
                              controller
                                  .obscurePassword
                                  .value,
                          onSubmitted:
                              (_) {
                            controller
                                .login();
                          },
                          decoration:
                              InputDecoration(
                            hintText:
                                'Password',
                            prefixIcon:
                                const Icon(
                              Icons
                                  .lock_outline,
                            ),
                            suffixIcon:
                                IconButton(
                              onPressed:
                                  controller
                                      .togglePassword,
                              icon: Icon(
                                controller
                                        .obscurePassword
                                        .value
                                    ? Icons
                                        .visibility_off_outlined
                                    : Icons
                                        .visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      Obx(
                        () =>
                            ElevatedButton(
                          onPressed:
                              controller
                                      .isLoading
                                      .value
                                  ? null
                                  : controller
                                      .login,
                          child: controller
                                  .isLoading
                                  .value
                              ? const SizedBox(
                                  width:
                                      22,
                                  height:
                                      22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                    color:
                                        Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(
                  'Use the Salesman account created by Admin.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 11.5,
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