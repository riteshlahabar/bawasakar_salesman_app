import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// Company announcements, circulars and notices.
class AnnouncementsController extends RemoteModuleController {
  AnnouncementsController(this._api)
    : super(
        title: 'Announcements',
        subtitle:
            'Company announcements, circulars and notices published for field staff.',
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final announcements = ModuleRowMapper.listFrom(
      await _api.announcements(),
      'announcements',
    );

    final circulars = announcements
        .where((a) => a['category'] == 'circular')
        .length;

    return (
      rows: announcements
          .map(
            (announcement) => ModuleRowMapper.row(
              title: announcement['title']?.toString() ?? '',
              subtitle: announcement['body']?.toString() ?? '',
              trailing: ModuleRowMapper.date(announcement['published_at']),
              icon: _iconFor(announcement['category']?.toString()),
              status: announcement['category']?.toString(),
            ),
          )
          .toList(),
      stats: [
        ModuleRowMapper.stat(
          title: 'Notices',
          value: announcements.length.toString(),
          icon: Icons.campaign,
          color: AppColors.primary,
          subtitle: 'Published',
        ),
        ModuleRowMapper.stat(
          title: 'Circulars',
          value: circulars.toString(),
          icon: Icons.article_outlined,
          color: AppColors.info,
          subtitle: 'Official',
        ),
      ],
    );
  }

  IconData _iconFor(String? category) {
    return switch (category) {
      'circular' => Icons.article_outlined,
      'notice' => Icons.push_pin_outlined,
      _ => Icons.campaign_outlined,
    };
  }
}
