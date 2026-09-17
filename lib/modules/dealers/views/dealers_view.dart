import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/dealers_controller.dart';
import 'widgets/dealer_card.dart';
import '../../../app/localization/t.dart';

class DealersView extends GetView<DealersController> {
  const DealersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dealers = controller.filteredDealers;

      return RefreshIndicator(
        onRefresh: controller.loadDealers,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
          children: [
            TextField(
              onChanged: (value) => controller.search.value = value,
              decoration: InputDecoration(
                hintText: t('dealers.search_assigned_dealer'),
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    t('common.assigned_dealers'),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${dealers.length}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.isLoading.value && dealers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (dealers.isEmpty)
              _empty()
            else
              ...dealers.map((dealer) => DealerCard(dealer: dealer)),
          ],
        ),
      );
    });
  }

  Widget _empty() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 52,
            color: AppColors.mutedGreen,
          ),
          SizedBox(height: 12),
          Text(
            t('dealers.no_assigned_dealers'),
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text(
            t('dealers.admin_has_not_assigned_any_dealer'),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
