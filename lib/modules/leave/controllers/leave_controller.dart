import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';

/// Leave applications and the remaining balance per leave type.
class LeaveController extends RemoteModuleController {
  LeaveController(this._api)
    : super(
        title: 'Leave Management',
        subtitle:
            'Apply for leave, track approvals and see how much of each entitlement you have left this year.',
        actionLabel: 'Apply for Leave',
        actionIcon: Icons.event_available,
      );

  final SalesmanHrService _api;

  final isSubmitting = false.obs;

  @override
  Future<ModuleData> fetch() async {
    // The list and the balance are fetched together so the stat tiles can
    // never disagree with the rows beneath them.
    final responses = await Future.wait([_api.leaves(), _api.leaveBalance()]);

    final leaves = ModuleRowMapper.listFrom(responses[0], 'leaves');
    final balances = ModuleRowMapper.listFrom(responses[1], 'balances');

    return (
      rows: leaves
          .map(
            (leave) => ModuleRowMapper.row(
              title: '${leave['leave_type']} leave'.toUpperCase(),
              subtitle:
                  '${ModuleRowMapper.date(leave['from_date'])} to ${ModuleRowMapper.date(leave['to_date'])}'
                  '${(leave['reason']?.toString() ?? '').isEmpty ? '' : ' • ${leave['reason']}'}',
              trailing: '',
              icon: Icons.event_note,
              status: leave['status']?.toString(),
            ),
          )
          .toList(),
      stats: balances
          .map(
            (balance) => ModuleRowMapper.stat(
              title: balance['leave_type']?.toString().toUpperCase() ?? '',
              value: ModuleRowMapper.toInt(balance['balance']).toString(),
              icon: Icons.event_available,
              color: AppColors.primary,
              subtitle: 'of ${ModuleRowMapper.toInt(balance['entitled'])} left',
            ),
          )
          .toList(),
    );
  }

  /// Submits a leave application and refreshes so the new row and the reduced
  /// balance appear together.
  Future<void> apply({
    required String leaveType,
    required DateTime from,
    required DateTime to,
    String? reason,
  }) async {
    isSubmitting.value = true;
    try {
      await _api.applyLeave({
        'leave_type': leaveType,
        'from_date': from.toIso8601String().substring(0, 10),
        'to_date': to.toIso8601String().substring(0, 10),
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      });
      await load();
      Get.snackbar(title, 'Leave application submitted for approval.');
    } catch (failure) {
      Get.snackbar(title, failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
