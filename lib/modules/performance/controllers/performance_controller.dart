import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Published performance reviews and their KPI scores.
///
/// Drafts are withheld server side, so a salesman only sees a review once HR
/// has released it.
class PerformanceController extends RemoteModuleController {
  PerformanceController(this._api)
    : super(
        title: t('common.performance'),
        subtitle: t('performance.your_kpi_scores_for_sales_collections'),
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.performance();
    final reviews = ModuleRowMapper.listFrom(response, 'reviews');
    final latest = ModuleRowMapper.mapFrom(response, 'latest');

    return (
      rows: reviews.map((review) {
        final reviewer = review['reviewer'];
        final reviewerName = reviewer is Map
            ? reviewer['name']?.toString() ?? ''
            : '';

        final kpiLine = _kpiLine(review['kpis']);

        return ModuleRowMapper.row(
          title:
              '${ModuleRowMapper.date(review['period_start'])} to ${ModuleRowMapper.date(review['period_end'])}',
          // The reviewer's name moves onto the title line so the subtitle's
          // two lines can be the scores and the KPIs — ModuleRow caps the
          // subtitle at 2 lines, so a third thing there would be clipped.
          titleTrailing: reviewerName.isEmpty
              ? null
              : t('performance.by', {'name': reviewerName}),
          subtitle:
              t('performance.row', {
                'sales': '${ModuleRowMapper.toDouble(review['sales_score'])}',
                'collection':
                    '${ModuleRowMapper.toDouble(review['collection_score'])}',
                'visits': '${ModuleRowMapper.toDouble(review['visit_score'])}',
              }) +
              (kpiLine.isEmpty ? '' : '\n$kpiLine'),
          trailing: ModuleRowMapper.toDouble(
            review['overall_rating'],
          ).toStringAsFixed(1),
          icon: Icons.insights,
          status: review['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.overall'),
          value: ModuleRowMapper.toDouble(
            latest['overall_rating'],
          ).toStringAsFixed(1),
          icon: Icons.star_rate,
          color: AppColors.primary,
          subtitle: t('performance.latest'),
        ),
        ModuleRowMapper.stat(
          title: t('common.sales'),
          value: ModuleRowMapper.toDouble(
            latest['sales_score'],
          ).toStringAsFixed(1),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: t('performance.score'),
        ),
        ModuleRowMapper.stat(
          title: t('performance.collection'),
          value: ModuleRowMapper.toDouble(
            latest['collection_score'],
          ).toStringAsFixed(1),
          icon: Icons.payments,
          color: AppColors.info,
          subtitle: t('performance.score'),
        ),
        ModuleRowMapper.stat(
          title: t('common.visits'),
          value: ModuleRowMapper.toDouble(
            latest['visit_score'],
          ).toStringAsFixed(1),
          icon: Icons.storefront,
          color: AppColors.orange,
          subtitle: t('performance.score'),
        ),
      ],
    );
  }

  /// The review's KPI rows as one line — "New Dealers: 7 of 10 • Repeat
  /// Orders: 62%".
  ///
  /// `performance_reviews.kpis` is a label/value table (the `KeyValueRows`
  /// cast), filled from the admin review form. It is the Phase 1 spec's "KPI"
  /// item under Performance Management; the column existed from the start but
  /// had no admin field and no display until 2026-09-24, so it reads empty on
  /// every review recorded before then.
  String _kpiLine(Object? kpis) {
    if (kpis is! List) return '';

    return kpis
        .whereType<Map>()
        .map((kpi) {
          final label = kpi['label']?.toString().trim() ?? '';
          final value = kpi['value']?.toString().trim() ?? '';

          if (label.isEmpty) return value;

          return value.isEmpty ? label : '$label: $value';
        })
        .where((line) => line.isNotEmpty)
        .join(' • ');
  }
}
