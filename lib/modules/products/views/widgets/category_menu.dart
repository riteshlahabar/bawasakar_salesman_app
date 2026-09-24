import 'package:flutter/material.dart';

import '../../../../app/data/models/category_model.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import 'category_menu_tile.dart';

/// Vertical category rail on the left of the dealer products screen, with a
/// leading "All" entry — the same rail the dealer and customer apps use on
/// their catalog tab.
class CategoryMenu extends StatelessWidget {
  const CategoryMenu({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final int selectedCategoryId;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8F5),
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 6, bottom: 18),
        itemCount: categories.length + 1,
        itemBuilder: (_, index) {
          final isAll = index == 0;

          final category = isAll ? null : categories[index - 1];

          final id = category?.id ?? 0;

          final active = selectedCategoryId == id;

          return CategoryMenuTile(
            title: isAll ? t('orders.all') : category!.name,
            active: active,
            category: category,
            onTap: () => onCategorySelected(id),
          );
        },
      ),
    );
  }
}
