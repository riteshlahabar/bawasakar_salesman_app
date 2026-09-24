import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/widgets/empty_state.dart';
import '../controllers/advances_controller.dart';
import '../../../app/localization/t.dart';

/// One advance or loan, and the EMI schedule behind it.
///
/// No binding and no API call: `SalesmanAdvanceController::index()` already
/// eager-loads `schedule`, so the whole record — instalments included — is
/// passed straight through as the route argument. It was being fetched and
/// thrown away until this screen existed.
class AdvanceDetailView extends StatelessWidget {
  const AdvanceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final record = Get.arguments;

    return Scaffold(
      // The bottom bar and FAB belong to NavShell, which wraps this route.
      appBar: AppBar(
        title: Text(t('advances.request_details')),
        leading: const DrawerMenuButton(),
      ),
      body: record is! Map
          ? EmptyState(
              title: t('common.could_not_load'),
              message: t('common.nothing_here_yet'),
              icon: Icons.cloud_off,
            )
          : _body(Map<String, dynamic>.from(record)),
    );
  }

  Widget _body(Map<String, dynamic> record) {
    final amount = ModuleRowMapper.toDouble(record['amount']);
    final recovered = ModuleRowMapper.toDouble(record['recovered_amount']);
    final installments = ModuleRowMapper.toInt(record['installments']);
    final isLoan = record['advance_type'] == AdvancesController.typeLoan;
    final reason = record['reason']?.toString() ?? '';

    final schedule = (record['schedule'] as List?)
        ?.whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList() ??
        const <Map<String, dynamic>>[];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                record['reference_no']?.toString() ?? '',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              ModuleRowMapper.statusLabel(record['status']?.toString() ?? ''),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
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
                t('advances.request_type'),
                isLoan ? t('advances.loan') : t('advances.advance'),
              ),
              const SizedBox(height: 10),
              _kv(t('advances.sanctioned'), ModuleRowMapper.money(amount)),
              const SizedBox(height: 10),
              _kv(t('advances.recovered'), ModuleRowMapper.money(recovered)),
              // An advance is recovered in one go, so its instalment count
              // says nothing worth a row.
              if (installments > 1) ...[
                const SizedBox(height: 10),
                _kv(
                  t('advances.installments'),
                  t('advances.emis_of', {
                    'n': '$installments',
                    'amount': ModuleRowMapper.money(record['emi_amount']),
                  }),
                ),
              ],
              if (record['disbursed_on'] != null) ...[
                const SizedBox(height: 10),
                _kv(
                  t('advances.disbursed_on'),
                  ModuleRowMapper.date(record['disbursed_on']),
                ),
              ],
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 4),
              _kv(
                t('common.outstanding'),
                ModuleRowMapper.money(amount - recovered),
                emphasize: true,
              ),
            ],
          ),
        ),
        if (reason.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.softCard(radius: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(t('advances.reason')),
                const SizedBox(height: 8),
                Text(
                  reason,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.softCard(radius: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(t('advances.emi_schedule')),
              const SizedBox(height: 12),
              if (schedule.isEmpty)
                Text(
                  t('advances.no_schedule_recorded'),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                )
              else
                ...schedule.map(_installment),
            ],
          ),
        ),
      ],
    );
  }

  /// One instalment: its number and due date on the left, the amount and
  /// what has been paid against it on the right.
  Widget _installment(Map<String, dynamic> row) {
    final paid = ModuleRowMapper.toDouble(row['paid_amount']);
    final status = row['status']?.toString() ?? '';
    final isPaid = status == 'paid';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '${ModuleRowMapper.toInt(row['installment_no'])}.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ModuleRowMapper.date(row['due_date']),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (paid > 0)
                  Text(
                    t('advances.paid_amount', {
                      'amount': ModuleRowMapper.money(paid),
                    }),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ModuleRowMapper.money(row['amount']),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                ModuleRowMapper.statusLabel(status),
                style: TextStyle(
                  color: isPaid ? AppColors.success : AppColors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _title(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w900,
    ),
  );

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
