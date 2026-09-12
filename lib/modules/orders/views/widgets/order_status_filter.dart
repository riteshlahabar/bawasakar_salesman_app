import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Horizontal scrollable row of status choice chips for [OrdersView].
class OrderStatusFilter extends StatelessWidget {
  const OrderStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  final String selectedStatus;
  final ValueChanged<String> onSelected;

  static const statuses = <String, String>{
    'all': 'All',
    'salesman_review': 'My Review',
    'admin_review': 'Admin Review',
    'approved': 'Approved',
    'packing': 'Packing',
    'dispatched': 'Dispatched',
    'delivered': 'Delivered',
    'cancelled': 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final entry = statuses.entries.elementAt(index);

          final selected = selectedStatus == entry.key;

          return ChoiceChip(
            selected: selected,
            label: Text(entry.value),
            onSelected: (_) => onSelected(entry.key),
            selectedColor: AppColors.primarySoft,
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.border,
            ),
            labelStyle: TextStyle(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          );
        },
      ),
    );
  }
}
