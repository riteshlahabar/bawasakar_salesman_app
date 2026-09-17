import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// "Today Collection" gradient hero card at the top of [DashboardView].
class DashboardOverviewCard extends StatelessWidget {
  const DashboardOverviewCard({
    super.key,
    required this.todayCollection,
    required this.territory,
    required this.employeeCode,
  });

  final double todayCollection;
  final String territory;
  final String employeeCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('dashboard.today_collection'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: .80),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${todayCollection.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  territory.trim().isEmpty ? t('dashboard.sales_territory') : territory,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                employeeCode.trim().isEmpty ? t('common.salesman') : employeeCode,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .82),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
