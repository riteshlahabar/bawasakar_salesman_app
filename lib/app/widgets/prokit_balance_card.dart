import 'package:flutter/material.dart';

import '../config/app_assets.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';

class ProkitBalanceCard extends StatelessWidget {
  const ProkitBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
      decoration: AppDecorations.gradientCard(const [
        AppColors.primary,
        AppColors.primaryDark,
      ], radius: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              AppAssets.walletVisa,
              height: 46,
              width: 54,
              color: Colors.white,
            ),
          ),
          Text(
            'Today Collection',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .65),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rs 32,800',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Text(
                  '14 dealer visits',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .75),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'SM-0001',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .75),
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
