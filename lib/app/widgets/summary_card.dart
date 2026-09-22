import 'package:flutter/material.dart';

import '../data/models/summary_card_model.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.item});

  final SummaryCardModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: AppDecorations.iconBox(item.color),
                child: Icon(item.icon, color: item.color, size: 16),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
