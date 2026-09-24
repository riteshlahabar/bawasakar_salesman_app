import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Colour for an order's workflow status, shared by the order card and the
/// order detail screen so one order never shows two different colours.
///
/// The statuses themselves come from the ERP's `OrderStatusService::FLOW`:
/// salesman_review → admin_review → approved → packing → dispatched →
/// out_for_delivery → delivered, or cancelled.
Color orderStatusColor(String status) {
  switch (status) {
    case 'salesman_review':
      return AppColors.accent;
    case 'admin_review':
      return AppColors.info;
    case 'approved':
      return AppColors.primary;
    case 'packing':
      return AppColors.orange;
    case 'dispatched':
    case 'out_for_delivery':
      return AppColors.info;
    case 'delivered':
      return AppColors.success;
    case 'cancelled':
      return AppColors.danger;
    default:
      return AppColors.textSecondary;
  }
}

/// "out_for_delivery" → "Out For Delivery".
String orderStatusText(String status) {
  return status
      .split('_')
      .map((word) {
        if (word.isEmpty) {
          return '';
        }

        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}
