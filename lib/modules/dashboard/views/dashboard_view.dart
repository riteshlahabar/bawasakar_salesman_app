import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/section_header.dart';
import '../../../app/widgets/summary_card.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/dashboard_overview_card.dart';
import 'widgets/operation_button.dart';
import 'widgets/quick_status_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.loadDashboard,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          children: [
            Text(
              'Hey ${controller.salesmanName.value},',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome Back',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            DashboardOverviewCard(
              todayCollection: controller.todayCollections.value,
              territory: controller.territory.value,
              employeeCode: controller.employeeCode.value,
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Operations'),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.operations
                    .map((item) => OperationButton(item: item))
                    .toList(),
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Performance'),
            const SizedBox(height: 14),
            if (controller.isLoading.value)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.summaries.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 144,
                    ),
                itemBuilder: (context, index) {
                  return SummaryCard(item: controller.summaries[index]);
                },
              ),
            const SizedBox(height: 18),
            QuickStatusCard(items: controller.quickStats.toList()),
          ],
        ),
      ),
    );
  }
}
