import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_finance_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// History of changes to the salesman's own basic salary. Read-only — a
/// revision is recorded automatically whenever HR changes the employee's
/// basic salary.
class SalaryRevisionsController extends RemoteModuleController {
  SalaryRevisionsController(this._api)
    : super(
        title: t('salary_revisions.salary_revisions'),
        subtitle: t('salary_revisions.history_of_changes_to_your_basic'),
      );

  final SalesmanFinanceService _api;

  @override
  Future<ModuleData> fetch() async {
    final revisions = ModuleRowMapper.listFrom(
      await _api.salaryRevisions(),
      'revisions',
    );

    return (
      rows: revisions.map((revision) {
        final changeAmount = ModuleRowMapper.toDouble(
          revision['change_amount'],
        );
        final changePercent = ModuleRowMapper.toDouble(
          revision['change_percent'],
        );

        return ModuleRowMapper.row(
          title: revision['reason_label']?.toString() ?? '',
          subtitle: [
            t('salary_revisions.new_basic', {
              'amount': ModuleRowMapper.money(revision['new_basic']),
            }),
            if (revision['effective_from'] != null)
              t('salary_revisions.effective_from', {
                'date': ModuleRowMapper.date(revision['effective_from']),
              }),
          ].join(' • '),
          trailing: t('salary_revisions.change', {
            'amount': ModuleRowMapper.money(changeAmount),
            'percent': changePercent.toStringAsFixed(1),
          }),
          icon: changeAmount >= 0 ? Icons.trending_up : Icons.trending_down,
          status: revision['applied'] == true ? 'applied' : 'pending',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.records'),
          value: revisions.length.toString(),
          icon: Icons.history,
          color: AppColors.primary,
          subtitle: t('salary_revisions.salary_revisions'),
        ),
      ],
    );
  }
}
