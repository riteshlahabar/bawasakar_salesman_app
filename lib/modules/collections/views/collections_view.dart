import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/collections_controller.dart';
import 'widgets/collection_form_card.dart';
import 'widgets/collection_success_banner.dart';

class CollectionsView extends GetView<CollectionsController> {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.loadDealers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
          children: [
            const Text(
              'Payment Collection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Record a payment received from an assigned dealer.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            CollectionFormCard(
              dealers: controller.dealers,
              selectedDealerId: controller.selectedDealerId.value,
              onDealerChanged: (value) =>
                  controller.selectedDealerId.value = value ?? 0,
              amountController: controller.amountController,
              paymentMode: controller.paymentMode.value,
              onPaymentModeChanged: (value) {
                if (value != null) {
                  controller.paymentMode.value = value;
                }
              },
              transactionController: controller.transactionController,
              isLoading: controller.isLoading.value,
              onSubmit: controller.collect,
            ),
            if (controller.lastMessage.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              CollectionSuccessBanner(message: controller.lastMessage.value),
            ],
          ],
        ),
      ),
    );
  }
}
