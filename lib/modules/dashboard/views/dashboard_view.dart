import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/section_header.dart';
import '../../../app/widgets/summary_card.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/attendance_quick_actions.dart';
import 'widgets/current_orders_section.dart';
import '../../../app/localization/t.dart';

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
            const AttendanceQuickActions(),
            const SizedBox(height: 22),
            SectionHeader(title: t('common.performance')),
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
                      mainAxisExtent: 84,
                    ),
                itemBuilder: (context, index) {
                  return SummaryCard(item: controller.summaries[index]);
                },
              ),
            const CurrentOrdersSection(),
          ],
        ),
      ),
    );
  }
}
