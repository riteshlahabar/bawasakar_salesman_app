import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/date_filter_mixin.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/leave_controller.dart';

/// The apply-for-leave form: type, from, to, reason.
///
/// Same shape as the expense sheet — no `viewInsets` padding of its own
/// (Get.bottomSheet's route already lifts it for the keyboard) and the type
/// picker is the shared [MenuSelectField].
class ApplyLeaveSheet extends StatelessWidget {
  const ApplyLeaveSheet({super.key, required this.controller});

  final LeaveController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * .85),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('leave.apply_for_leave'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _label(t('leave.leave_type')),
            Obx(() {
              // Read in the closure: the list and the selection are both
              // observables, and passing them down alone registers nothing.
              final types = controller.leaveTypes.toList();
              final selected = controller.leaveType.value;

              return MenuSelectField<String>(
                items: types,
                selected: selected.isEmpty ? null : selected,
                labelOf: LeaveController.leaveTypeLabel,
                placeholder: t('leave.select_leave_type'),
                onSelected: (value) => controller.leaveType.value = value,
              );
            }),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(t('leave.from_date')),
                      Obx(
                        () => _DateField(
                          label: DateFilterMixin.dayLabel(
                            controller.leaveFrom.value,
                          ),
                          onTap: () => _pickFrom(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(t('leave.to_date')),
                      Obx(
                        () => _DateField(
                          label: DateFilterMixin.dayLabel(
                            controller.leaveTo.value,
                          ),
                          onTap: () => _pickTo(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _label(t('leave.reason')),
            TextField(
              controller: controller.reasonController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('leave.reason_hint')),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.applyLeave,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSubmitting.value
                        ? t('collections.saving')
                        : t('leave.submit_application'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
    ),
  );

  /// Leave can be applied for ahead of time, so unlike an expense these
  /// calendars run into the future. To can never start before From.
  Future<void> _pickFrom(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.leaveFrom.value,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked != null) controller.setLeaveFrom(picked);
  }

  Future<void> _pickTo(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.leaveTo.value,
      firstDate: controller.leaveFrom.value,
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked != null) controller.leaveTo.value = picked;
  }
}

/// The date shown like a text field, so the form reads as one set of
/// identical inputs.
class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
