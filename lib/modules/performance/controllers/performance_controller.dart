import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// Published performance reviews and their KPI scores.
///
/// Drafts are withheld server side, so a salesman only sees a review once HR
/// has released it.
class PerformanceController extends RemoteModuleController {
  PerformanceController(this._api)
    : super(
        title: 'Performance',
        subtitle:
            'Your KPI scores for sales, collections and dealer visits, with the reviewer remarks.',
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

        return ModuleRowMapper.row(
          title:
              '${ModuleRowMapper.date(review['period_start'])} to ${ModuleRowMapper.date(review['period_end'])}',
          subtitle:
              'Sales ${ModuleRowMapper.toDouble(review['sales_score'])}'
              ' • Collection ${ModuleRowMapper.toDouble(review['collection_score'])}'
              ' • Visits ${ModuleRowMapper.toDouble(review['visit_score'])}'
              '${reviewerName.isEmpty ? '' : ' • by $reviewerName'}',
          trailing: ModuleRowMapper.toDouble(
            review['overall_rating'],
          ).toStringAsFixed(1),
          icon: Icons.insights,
          status: review['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Overall',
          value: ModuleRowMapper.toDouble(
            latest['overall_rating'],
          ).toStringAsFixed(1),
          icon: Icons.star_rate,
          color: AppColors.primary,
          subtitle: 'Latest',
        ),
        ModuleRowMapper.stat(
          title: 'Sales',
          value: ModuleRowMapper.toDouble(
            latest['sales_score'],
          ).toStringAsFixed(1),
          icon: Icons.trending_up,
          color: AppColors.success,
          subtitle: 'Score',
        ),
        ModuleRowMapper.stat(
          title: 'Collection',
          value: ModuleRowMapper.toDouble(
            latest['collection_score'],
          ).toStringAsFixed(1),
          icon: Icons.payments,
          color: AppColors.info,
          subtitle: 'Score',
        ),
        ModuleRowMapper.stat(
          title: 'Visits',
          value: ModuleRowMapper.toDouble(
            latest['visit_score'],
          ).toStringAsFixed(1),
          icon: Icons.storefront,
          color: AppColors.orange,
          subtitle: 'Score',
        ),
      ],
    );
  }
}
