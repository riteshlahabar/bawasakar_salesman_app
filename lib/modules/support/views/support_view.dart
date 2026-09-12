import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.softCard(),
            child: Column(
              children: [
                AppTextField(
                  label: 'Subject',
                  icon: Icons.subject_rounded,
                  controller: controller.subject,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.message,
                  minLines: 5,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    prefixIcon: Icon(Icons.message_outlined, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.submit,
                      child: Text(controller.isLoading.value ? 'Sending...' : 'Create Ticket'),
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
