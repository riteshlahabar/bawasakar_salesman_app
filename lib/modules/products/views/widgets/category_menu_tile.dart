import 'package:flutter/material.dart';

import '../../../../app/data/models/category_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// A single tappable entry in the vertical category rail.
///
/// Same design as the dealer and customer apps' catalog rail, so all three
/// apps browse the catalog the same way.
class CategoryMenuTile extends StatelessWidget {
  const CategoryMenuTile({
    super.key,
    required this.title,
    required this.active,
    required this.onTap,
    this.category,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;
  final CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    final hasImage = category?.imageUrl?.trim().isNotEmpty ?? false;

    return Material(
      color: active ? Colors.white : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 9, 6, 9),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active ? AppColors.primary : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: active ? AppColors.primarySoft : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.border,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: category == null
                    ? const Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.primary,
                        size: 25,
                      )
                    : hasImage
                    ? ProductImage(
                        imageUrl: category!.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Icon(_iconFor(title), color: AppColors.primary, size: 25),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  height: 1.15,
                  color: active ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    final value = name.toLowerCase();

    if (value.contains('medicine') || value.contains('veterinary')) {
      return Icons.medication_liquid_rounded;
    }

    if (value.contains('seed')) {
      return Icons.grass_rounded;
    }

    if (value.contains('fertil')) {
      return Icons.eco_rounded;
    }

    if (value.contains('tool') || value.contains('equipment')) {
      return Icons.agriculture_rounded;
    }

    if (value.contains('feed') || value.contains('supplement')) {
      return Icons.inventory_2_rounded;
    }

    return Icons.spa_rounded;
  }
}
