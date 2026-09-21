import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/empty_state.dart';
import '../controllers/payslip_detail_controller.dart';
import '../../../app/localization/t.dart';

class PayslipDetailView extends GetView<PayslipDetailController> {
  const PayslipDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('payslips.payslip_breakdown'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.slip.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final slip = controller.slip.value;
        if (slip == null) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value.isEmpty ? t('common.nothing_here_yet') : controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.softCard(radius: 16),
              child: Column(
                children: [
                  _kv(t('payslips.basic_salary'), ModuleRowMapper.money(slip['basic_salary'])),
                  const SizedBox(height: 10),
                  _kv(t('payslips.gross_salary'), ModuleRowMapper.money(slip['gross_salary'])),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 4),
                  _kv(t('payslips.net_salary'), ModuleRowMapper.money(slip['net_salary']), emphasize: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _LinesCard(
              title: t('payslips.allowances'),
              color: AppColors.success,
              lines: controller.allowances,
            ),
            const SizedBox(height: 16),
            _LinesCard(
              title: t('payslips.deductions'),
              color: AppColors.danger,
              lines: controller.deductions,
            ),
          ],
        );
      }),
    );
  }

  Widget _kv(String label, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasize ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: emphasize ? 14 : 12,
            fontWeight: emphasize ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasize ? AppColors.primary : AppColors.textPrimary,
            fontSize: emphasize ? 16 : 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.title, required this.color, required this.lines});

  final String title;
  final Color color;
  final List<Map<String, dynamic>> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.softCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          if (lines.isEmpty)
            Text(
              t('payslips.no_lines_recorded'),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            )
          else
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        line['label']?.toString() ?? '',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                    Text(
                      ModuleRowMapper.money(line['amount']),
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
