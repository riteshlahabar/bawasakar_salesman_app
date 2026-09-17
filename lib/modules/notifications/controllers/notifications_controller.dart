import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// The salesman's notification inbox.
class NotificationsController extends RemoteModuleController {
  NotificationsController(this._api)
    : super(
        title: t('common.notifications'),
        subtitle:
            t('notifications.order_approvals_dispatch_updates_leave_decisions'),
        actionLabel: t('notifications.mark_all_read'),
        actionIcon: Icons.mark_email_read_outlined,
      );

  final SalesmanDashboardService _api;

  final unreadCount = 0.obs;

  @override
  Future<ModuleData> fetch() async {
    final response = await _api.notifications();
    final items = ModuleRowMapper.listFrom(response, 'notifications');
    final data = response['data'];
    unreadCount.value = ModuleRowMapper.toInt(
      data is Map ? data['unread_count'] : null,
    );

    return (
      rows: items.map((item) {
        final unread = item['read_at'] == null;

        return ModuleRowMapper.row(
          title: item['title']?.toString() ?? '',
          subtitle: item['message']?.toString() ?? '',
          trailing: ModuleRowMapper.date(item['created_at']),
          icon: unread
              ? Icons.mark_email_unread_outlined
              : Icons.drafts_outlined,
          status: unread ? 'pending' : 'completed',
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('notifications.unread'),
          value: unreadCount.value.toString(),
          icon: Icons.notifications_active,
          color: AppColors.orange,
          subtitle: t('notifications.messages'),
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: items.length.toString(),
          icon: Icons.inbox,
          color: AppColors.primary,
          subtitle: t('notifications.in_inbox'),
        ),
      ],
    );
  }

  @override
  void primaryAction() {
    _markAllRead();
  }

  Future<void> _markAllRead() async {
    if (unreadCount.value == 0) return;
    try {
      await _api.markNotificationsRead(const []);
      await load();
    } catch (failure) {
      Get.snackbar(title, failure.toString());
    }
  }
}
