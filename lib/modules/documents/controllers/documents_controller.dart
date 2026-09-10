import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// The salesman's HR documents on file.
///
/// Identity numbers arrive from the server already masked, and the stored file
/// path is never sent, so this screen confirms which documents HR holds
/// without putting a full Aadhaar or PAN on a screen that could be
/// shoulder-surfed or screenshot.
class DocumentsController extends RemoteModuleController {
  DocumentsController(this._api)
    : super(
        title: 'My Documents',
        subtitle:
            'Identity, bank and employment documents held by HR, with their verification status.',
      );

  final SalesmanHrService _api;

  static const _labels = <String, String>{
    'aadhaar': 'Aadhaar Card',
    'pan': 'PAN Card',
    'driving_license': 'Driving Licence',
    'bank': 'Bank Details',
    'appointment_letter': 'Appointment Letter',
    'id_card': 'ID Card',
    'certificate': 'Certificate',
  };

  @override
  Future<ModuleData> fetch() async {
    final documents = ModuleRowMapper.listFrom(
      await _api.documents(),
      'documents',
    );

    final verified = documents.where((d) => d['status'] == 'approved').length;
    final pending = documents.where((d) => d['status'] == 'pending').length;

    return (
      rows: documents.map((document) {
        final type = document['document_type']?.toString() ?? '';
        final number = document['document_no']?.toString() ?? '';

        return ModuleRowMapper.row(
          title: _labels[type] ?? type.replaceAll('_', ' ').toUpperCase(),
          subtitle: [
            if (number.isNotEmpty) number,
            if (document['expires_on'] != null)
              'Expires ${ModuleRowMapper.date(document['expires_on'])}',
            if ((document['remarks']?.toString() ?? '').isNotEmpty)
              document['remarks'].toString(),
          ].join(' • '),
          trailing: document['has_file'] == true ? 'On file' : 'Missing',
          icon: _iconFor(type),
          status: document['status']?.toString(),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'On file',
          value: documents.length.toString(),
          icon: Icons.folder_shared,
          color: AppColors.primary,
          subtitle: 'Documents',
        ),
        ModuleRowMapper.stat(
          title: 'Verified',
          value: verified.toString(),
          icon: Icons.verified_user,
          color: AppColors.success,
          subtitle: 'Approved',
        ),
        ModuleRowMapper.stat(
          title: 'Pending',
          value: pending.toString(),
          icon: Icons.hourglass_bottom,
          color: AppColors.orange,
          subtitle: 'In review',
        ),
      ],
    );
  }

  IconData _iconFor(String type) {
    return switch (type) {
      'aadhaar' || 'pan' || 'id_card' => Icons.badge_outlined,
      'driving_license' => Icons.drive_eta_outlined,
      'bank' => Icons.account_balance_outlined,
      'appointment_letter' || 'certificate' => Icons.description_outlined,
      _ => Icons.insert_drive_file_outlined,
    };
  }
}
