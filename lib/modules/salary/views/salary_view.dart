import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/module_list_view.dart';
import '../../../app/widgets/summary_card.dart';
import '../controllers/salary_controller.dart';
import '../../../app/widgets/year_month_filter_bar.dart';
import '../../../app/localization/t.dart';

/// Same shape as [RemoteModuleView] but with its own body, because the rows
/// are tappable: a slip opens its allowance/deduction breakdown, which the
/// generic row cannot carry an id for. This screen took over the commented-out
/// Payslips menu on 2026-09-24.
class SalaryView extends GetView<SalaryController> {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom bar and FAB belong to NavShell, which wraps this route.
      appBar: AppBar(
        title: Text(controller.title),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(() {
        final filter = YearMonthFilterBar(controller: controller);

        if (controller.isLoading.value && controller.rows.isEmpty) {
          return _chrome(
            filter,
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        if (controller.error.value.isNotEmpty && controller.rows.isEmpty) {
          return _chrome(
            filter,
            Expanded(
              child: EmptyState(
                title: t('common.could_not_load'),
                message: controller.error.value,
                icon: Icons.cloud_off,
              ),
            ),
          );
        }

        if (controller.isEmpty) {
          return _chrome(
            filter,
            Expanded(
              child: EmptyState(
                title: t('common.nothing_here_yet'),
                message: t('salary.no_payslips_for_this_window'),
                icon: Icons.inbox_outlined,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            // Never null: a shrink-wrapped list inside another scroll view
            // silently adopts MediaQuery.padding otherwise.
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              filter,
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
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
                // GestureDetector, not InkWell: the row card paints its own
                // opaque background, so a ripple would be hidden behind it.
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

  /// Keeps the filter on screen in the loading, error and empty states — the
  /// control must never vanish mid-request, or the window cannot be changed
  /// back once it returns nothing.
  Widget _chrome(Widget filter, Widget body) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(children: [filter, const SizedBox(height: 16), body]),
    );
  }
}
