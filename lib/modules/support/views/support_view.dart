import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/support_controller.dart';
import '../../../app/localization/t.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('common.help_and_support')),
        leading: const DrawerMenuButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.softCard(),
            child: Column(
              children: [
                AppTextField(
                  label: t('support.subject'),
                  icon: Icons.subject_rounded,
                  controller: controller.subject,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.message,
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: t('support.message'),
                    prefixIcon: Icon(
                      Icons.message_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submit,
                      child: Text(
                        controller.isLoading.value
                            ? t('support.sending')
                            : t('support.create_ticket'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
