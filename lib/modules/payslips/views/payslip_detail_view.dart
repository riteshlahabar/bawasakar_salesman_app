import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/widgets/drawer_menu_button.dart';
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
      appBar: AppBar(
        title: Text(t('payslips.payslip_breakdown')),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.slip.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final slip = controller.slip.value;
        if (slip == null) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value.isEmpty
                ? t('common.nothing_here_yet')
                : controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        final month = ModuleRowMapper.toInt(slip['salary_month']);
        final payable = ModuleRowMapper.toDouble(slip['payable_days']);
        final working = ModuleRowMapper.toDouble(slip['working_days']);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Which payslip this is. The list row said so, but nothing on this
            // screen did once it was opened.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  month >= 1 && month <= 12
                      ? DateFilterMixin.monthName(
                          month,
                          ModuleRowMapper.toInt(slip['salary_year']),
                        )
                      : '${slip['salary_year'] ?? ''}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (working > 0)
                  Text(
                    t('payslips.paid_days_of')
                        .replaceFirst('{paid}', _days(payable))
                        .replaceFirst('{total}', _days(working)),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.softCard(radius: 16),
              child: Column(
                children: [
                  _kv(
                    t('payslips.basic_salary'),
                    ModuleRowMapper.money(slip['basic_salary']),
                  ),
                  const SizedBox(height: 10),
                  // Bonus, commission and incentives were all in the response
                  // and shown nowhere. A zero row is hidden rather than
                  // padding the card with three ₹0 lines.
                  ..._optional(t('common.incentives'), slip['incentives']),
                  ..._optional(t('payslips.bonus'), slip['bonus']),
                  ..._optional(t('payslips.commission'), slip['commission']),
                  _kv(
                    t('payslips.gross_salary'),
                    ModuleRowMapper.money(slip['gross_salary']),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 4),
                  _kv(
                    t('payslips.net_salary'),
                    ModuleRowMapper.money(slip['net_salary']),
                    emphasize: true,
                  ),
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

  /// A key/value row plus its spacer, or nothing at all when the amount is
  /// zero — an empty bonus or commission is noise on a payslip.
  List<Widget> _optional(String label, Object? amount) {
    if (ModuleRowMapper.toDouble(amount) <= 0) return const [];

    return [
      _kv(label, ModuleRowMapper.money(amount)),
      const SizedBox(height: 10),
    ];
  }

  /// `payable_days` and `working_days` are `decimal:2`, so a whole number
  /// arrives as "26.00" — trimmed here, while a half day stays "26.5".
  String _days(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();

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
  const _LinesCard({
    required this.title,
    required this.color,
    required this.lines,
  });

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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          if (lines.isEmpty)
            Text(
              t('payslips.no_lines_recorded'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
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
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      ModuleRowMapper.money(line['amount']),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
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
