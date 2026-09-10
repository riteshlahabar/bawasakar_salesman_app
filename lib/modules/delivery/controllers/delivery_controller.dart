import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_order_service.dart';
import '../../../app/theme/app_colors.dart';

/// Dispatches heading to the salesman's dealers.
class DeliveryController extends RemoteModuleController {
  DeliveryController(this._api)
    : super(
        title: 'Delivery',
        subtitle:
            'Dispatches for your dealers, with courier, tracking number and delivery state.',
      );

  final SalesmanOrderService _api;

  @override
  Future<ModuleData> fetch() async {
    final deliveries = ModuleRowMapper.listFrom(
      await _api.deliveries(),
      'deliveries',
    );

    final delivered = deliveries.where((d) => d['delivered_at'] != null).length;
    final inTransit = deliveries
        .where((d) => d['dispatched_at'] != null && d['delivered_at'] == null)
        .length;

    return (
      rows: deliveries
          .map(
            (delivery) => ModuleRowMapper.row(
              title: delivery['dispatch_no']?.toString() ?? 'Dispatch',
              subtitle: [
                if ((delivery['courier_name']?.toString() ?? '').isNotEmpty)
                  delivery['courier_name'].toString(),
                if ((delivery['tracking_no']?.toString() ?? '').isNotEmpty)
                  'AWB ${delivery['tracking_no']}',
                if (delivery['dispatched_at'] != null)
                  'Sent ${ModuleRowMapper.date(delivery['dispatched_at'])}',
              ].join(' • '),
              trailing: delivery['delivered_at'] == null
                  ? ''
                  : ModuleRowMapper.date(delivery['delivered_at']),
              icon: Icons.local_shipping,
              status: delivery['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'In transit',
          value: inTransit.toString(),
          icon: Icons.local_shipping,
          color: AppColors.orange,
          subtitle: 'Dispatches',
        ),
        ModuleRowMapper.stat(
          title: 'Delivered',
          value: delivered.toString(),
          icon: Icons.task_alt,
          color: AppColors.success,
          subtitle: 'Completed',
        ),
        ModuleRowMapper.stat(
          title: 'Total',
          value: deliveries.length.toString(),
          icon: Icons.inventory,
          color: AppColors.primary,
          subtitle: 'Records',
        ),
      ],
    );
  }
}
