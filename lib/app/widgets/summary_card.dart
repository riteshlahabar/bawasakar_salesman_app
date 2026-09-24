import 'package:flutter/material.dart';

import '../data/models/summary_card_model.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';

/// One metric tile: its label on the left, its value on the right, both on a
/// single line. The coloured icon box this used to lead with was dropped at
/// the user's request — with eight tiles on the dashboard the icons added
/// height without adding meaning.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.item});

  /// Height a grid cell needs for this card, so every grid using it stays in
  /// step with the layout instead of guessing its own `mainAxisExtent`.
  static const double gridExtent = 56;

  final SummaryCardModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.color,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
