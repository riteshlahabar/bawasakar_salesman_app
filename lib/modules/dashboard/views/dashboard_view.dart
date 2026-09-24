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
                // Must be explicit: a nested scroll view with a null padding
                // silently adopts MediaQuery's vertical padding, and the
                // shell's `extendBody: true` Scaffold sets that bottom padding
                // to the bottom-nav height — which showed up as a large empty
                // gap between this grid and the Current Orders section below.
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.summaries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: SummaryCard.gridExtent,
                ),
                itemBuilder: (context, index) {
                  return SummaryCard(item: controller.summaries[index]);
                },
              ),
            const SizedBox(height: 22),
            const CurrentOrdersSection(),
          ],
        ),
      ),
    );
  }
}
