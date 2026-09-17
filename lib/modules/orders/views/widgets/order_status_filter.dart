import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Horizontal scrollable row of status choice chips for [OrdersView].
class OrderStatusFilter extends StatelessWidget {
  const OrderStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  final String selectedStatus;
  final ValueChanged<String> onSelected;

  static Map<String, String> get statuses => <String, String>{
    'all': t('orders.all'),
    'salesman_review': t('orders.my_review'),
    'admin_review': t('orders.admin_review'),
    'approved': t('common.approved'),
    'packing': t('orders.packing'),
    'dispatched': t('orders.dispatched'),
    'delivered': t('common.delivered'),
    'cancelled': t('orders.cancelled'),
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
