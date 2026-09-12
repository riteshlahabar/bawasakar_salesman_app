import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/action_item_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_decorations.dart';

/// Single square shortcut button in the "Operations" row of [DashboardView].
class OperationButton extends StatelessWidget {
  const OperationButton({super.key, required this.item});

  final ActionItemModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(item.route),
      child: Container(
        width: 88,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: AppDecorations.softCard(radius: 18),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: AppDecorations.iconBox(item.color),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 3),
            Text(
              item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
