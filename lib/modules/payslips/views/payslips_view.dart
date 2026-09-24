import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/module_list_view.dart';
import '../../../app/widgets/section_header.dart';
import '../../../app/widgets/summary_card.dart';
import '../controllers/payslips_controller.dart';
import '../../../app/localization/t.dart';

/// Same shape as [RemoteModuleView] but with tappable rows — a payslip opens
/// its own allowance/deduction breakdown, which the generic list row cannot
/// carry an id for.
class PayslipsView extends GetView<PayslipsController> {
  const PayslipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom bar and FAB belong to NavShell, which wraps this route.
      appBar: AppBar(
        title: Text(controller.title),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.rows.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.rows.isEmpty) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        if (controller.isEmpty) {
          return EmptyState(
            title: t('common.nothing_here_yet'),
            message: controller.subtitle,
            icon: Icons.inbox_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SectionHeader(
                title: controller.title,
                subtitle: controller.subtitle,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.stats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: SummaryCard.gridExtent,
                ),
                itemBuilder: (context, index) =>
                    SummaryCard(item: controller.stats[index]),
              ),
              const SizedBox(height: 18),
              Text(
                t('payslips.tap_a_payslip_to_see_its'),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < controller.rows.length; i++)
                GestureDetector(
                  onTap: () => Get.toNamed<void>(
                    AppRoutes.payslipDetail,
                    arguments: ModuleRowMapper.toInt(controller.slips[i]['id']),
                  ),
                  child: ModuleRow(controller.rows[i]),
                ),
            ],
          ),
        );
      }),
    );
  }
}
