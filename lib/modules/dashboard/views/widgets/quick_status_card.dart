import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_decorations.dart';

/// "Quick Status" checklist card at the bottom of [DashboardView].
class QuickStatusCard extends StatelessWidget {
  const QuickStatusCard({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Status',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
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
