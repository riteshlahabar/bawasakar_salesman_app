import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Company assets issued to the signed-in salesman.
class AssetsController extends RemoteModuleController {
  AssetsController(this._api)
    : super(
        title: t('assets.salesman_assets'),
        subtitle: t('assets.company_assets_issued_to_you_laptop'),
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final assets = ModuleRowMapper.listFrom(await _api.assets(), 'assets');

    final issued = assets.where((a) => a['status'] == 'issued').length;
    final returned = assets.where((a) => a['status'] == 'returned').length;

    return (
      rows: assets
          .map(
            (asset) => ModuleRowMapper.row(
              title: asset['asset_name']?.toString() ?? t('common.asset'),
              subtitle: [
                if ((asset['serial_no']?.toString() ?? '').isNotEmpty)
                  'Serial ${asset['serial_no']}',
                if ((asset['issued_on']?.toString() ?? '').isNotEmpty)
                  'Issued ${ModuleRowMapper.date(asset['issued_on'])}',
                if ((asset['condition']?.toString() ?? '').isNotEmpty)
                  '${asset['condition']} condition',
              ].join(' • '),
              trailing: asset['asset_type']?.toString() ?? '',
              icon: _iconFor(asset['asset_type']?.toString()),
              status: asset['status']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('assets.issued'),
          value: issued.toString(),
          icon: Icons.inventory_2,
          color: AppColors.primary,
          subtitle: t('common.assets'),
        ),
        ModuleRowMapper.stat(
          title: t('assets.returned'),
          value: returned.toString(),
          icon: Icons.keyboard_return,
          color: AppColors.info,
          subtitle: t('common.assets'),
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: assets.length.toString(),
          icon: Icons.list_alt,
          color: AppColors.success,
          subtitle: t('common.records'),
        ),
      ],
    );
  }

  IconData _iconFor(String? type) {
    return switch (type) {
      'mobile' => Icons.phone_android,
      'laptop' => Icons.laptop_mac,
      'sim' => Icons.sim_card,
      'vehicle' => Icons.two_wheeler,
      _ => Icons.work_outline,
    };
  }
}
