import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/apply_leave_sheet.dart';

/// Leave applications and the remaining balance per leave type.
class LeaveController extends RemoteModuleController with DateFilterMixin {
  LeaveController(this._api)
    : super(
        title: t('leave.leave_management'),
        subtitle: t('leave.apply_for_leave_track_approvals_and'),
        actionLabel: t('leave.apply_for_leave'),
        actionIcon: Icons.event_available,
      );

  /// Used only when the balance call fails — the real list comes from the
  /// admin Leave Policies master, so adding a policy there shows up here
  /// without an app change.
  static const fallbackLeaveTypes = <String>[
    'casual',
    'sick',
    'paid',
    'unpaid',
    'half_day',
  ];

  /// A policy the admin added that this app has no wording for still reads
  /// sensibly: `half_day` becomes "Half Day".
  static String leaveTypeLabel(String code) {
    final translated = t('leave.type_$code');
    if (translated != 'leave.type_$code') return translated;

    return code
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  final SalesmanHrService _api;

  final isSubmitting = false.obs;

  /// The types offered by the form, read off the balance response.
  final leaveTypes = <String>[...fallbackLeaveTypes].obs;

  /// The form's fields.
  final leaveType = ''.obs;
  final leaveFrom = Rx<DateTime>(DateTime.now());
  final leaveTo = Rx<DateTime>(DateTime.now());
  final reasonController = TextEditingController();

  /// Every application, kept so changing the filter re-reads this list
  /// instead of going back to the network.
  List<Map<String, dynamic>>? _cache;

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  /// Every page — the endpoint paginates 20 at a time, and the filter reads
  /// from this list rather than re-requesting.
  Future<List<Map<String, dynamic>>> _allLeaves() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.leaves(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'leaves');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'leaves');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    // The balance is fetched every time: it is what the stat tiles show, and
    // it changes as applications are approved.
    final balanceResponse = await _api.leaveBalance();
    final all = _cache ??= await _allLeaves();

    final balances = ModuleRowMapper.listFrom(balanceResponse, 'balances');

    final types = balances
        .map((balance) => balance['leave_type']?.toString() ?? '')
        .where((type) => type.isNotEmpty)
        .toList();
    if (types.isNotEmpty) leaveTypes.assignAll(types);

    // Filtered on the first day of the leave — the day the row is "about".
    final leaves = all
        .where(
          (leave) => isInWindow(
            DateTime.tryParse('${leave['from_date']}')?.toLocal(),
          ),
        )
        .toList();

    return (
      rows: leaves.map((leave) {
        final from = ModuleRowMapper.date(leave['from_date']);
        final to = ModuleRowMapper.date(leave['to_date']);

        final reason = leave['reason']?.toString() ?? '';
        final dates = from == to ? from : '$from - $to';

        final type = leaveTypeLabel(leave['leave_type']?.toString() ?? '');

        return ModuleRowMapper.row(
          // The dates lead the card; the leave type reads under them, with
          // the reason after it. The status badge is the only thing on the
          // right.
          title: dates,
          subtitle: reason.isEmpty ? type : '$type • $reason',
          trailing: '',
          icon: Icons.event_note,
          status: leave['status']?.toString(),
        );
      }).toList(),
      stats: balances
          .map(
            (balance) => ModuleRowMapper.stat(
              title: leaveTypeLabel(balance['leave_type']?.toString() ?? ''),
              value: ModuleRowMapper.toInt(balance['balance']).toString(),
              icon: Icons.event_available,
              color: AppColors.primary,
              subtitle: t('leave.of_entitled_left', {
                'n': ModuleRowMapper.toInt(balance['entitled']).toString(),
              }),
            ),
          )
          .toList(),
    );
  }

  /// Keeps the pair valid: a From after the current To drags To along with
  /// it, so the calendars can be used in either order.
  void setLeaveFrom(DateTime value) {
    leaveFrom.value = value;
    if (leaveTo.value.isBefore(value)) leaveTo.value = value;
  }

  /// Opens the application form. `RemoteModuleView` wires this to the
  /// screen's primary button because [actionLabel] is set — without this
  /// override the button fell through to the base class and only said the
  /// action was not available yet, which is why Apply for Leave did nothing.
  @override
  void primaryAction() {
    leaveType.value = '';
    leaveFrom.value = DateTime.now();
    leaveTo.value = DateTime.now();
    reasonController.clear();

    Get.bottomSheet<void>(
      ApplyLeaveSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> applyLeave() async {
    if (isSubmitting.value) return;

    if (leaveType.value.isEmpty) {
      Get.snackbar(t('leave.leave_type'), t('leave.type_required'));
      return;
    }

    if (leaveTo.value.isBefore(leaveFrom.value)) {
      Get.snackbar(t('leave.leave_type'), t('leave.dates_required'));
      return;
    }

    isSubmitting.value = true;

    try {
      await _api.applyLeave({
        'leave_type': leaveType.value,
        'from_date': DateFilterMixin.apiDay(leaveFrom.value),
        'to_date': DateFilterMixin.apiDay(leaveTo.value),
        if (reasonController.text.trim().isNotEmpty)
          'reason': reasonController.text.trim(),
      });

      Get.back<void>();
      Get.snackbar(title, t('leave.leave_application_submitted_for_approval'));

      // The new application is not in the cached list, so drop it and
      // refetch — the balance is re-read by the same load.
      _cache = null;
      await load();
    } catch (failure) {
      Get.snackbar(
        t('leave.leave_not_saved'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
