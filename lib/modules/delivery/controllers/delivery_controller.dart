import 'package:flutter/material.dart';
import '../../../app/controllers/module_controller.dart';
import '../../../app/data/models/list_row_model.dart';
import '../../../app/theme/app_colors.dart';

class DeliveryController extends ModuleController {
  DeliveryController()
    : super(
        title: 'Delivery Tracking',
        subtitle:
            'Packing, dispatch, transport, LR/courier number, expected delivery, proof of delivery, and failed delivery follow-up.',
        actionLabel: 'Track Order',
        actionIcon: Icons.local_shipping,
        initialRows: const [
          ListRowModel(
            title: 'ORD-24068',
            subtitle: 'Farmer Care Agency • VRL Transport • LR 882918',
            trailing: '2 days',
            icon: Icons.local_shipping,
            status: 'Dispatched',
            color: AppColors.info,
          ),
          ListRowModel(
            title: 'ORD-24070',
            subtitle: 'Kisan Krushi Seva • Packing completed',
            trailing: 'Today',
            icon: Icons.inventory,
            status: 'Packing',
            color: AppColors.accent,
          ),
          ListRowModel(
            title: 'ORD-24061',
            subtitle: 'Shree Agro Center • Proof uploaded',
            trailing: 'Done',
            icon: Icons.task_alt,
            status: 'Delivered',
            color: AppColors.success,
          ),
        ],
      );
}
