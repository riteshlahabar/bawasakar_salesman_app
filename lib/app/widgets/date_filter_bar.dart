import 'package:flutter/material.dart';

import '../controllers/date_filter_mixin.dart';
import '../localization/t.dart';
import '../theme/app_colors.dart';
import 'filter_chip_button.dart';

/// The window picker shared by the filtered module screens: today (optional),
/// this month, another month, or a custom From–To range whose two ends have
/// their own calendars.
///
/// Month names come from the `months.*` translation keys; the range dates are
/// written `dd-mm-yyyy` like every other date in the app.
class DateFilterBar extends StatelessWidget {
  const DateFilterBar({
    super.key,
    required this.controller,
    this.showToday = false,
  });

  final DateFilterMixin controller;

  /// Adds a Today chip ahead of the month chips. Attendance is read a month
  /// at a time and leaves it off; Dealer Visits opens on it.
  final bool showToday;

  @override
  Widget build(BuildContext context) {
    final mode = controller.mode.value;
    // Only a complete range counts as selected: one end on its own does not
    // change what is listed yet, so colouring its chip would promise a filter
    // that has not been applied.
    final inRange =
        mode == DateFilterMode.range &&
        controller.from.value != null &&
        controller.to.value != null;

    // A tinted, bordered panel so the controls read as a filter rather than
    // as another row of content cards. The tint alone carries that — the user
    // asked for the "Filter" caption to go.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two rows, not four chips side by side: the month name and the two
          // dates are too long to stay readable in a quarter of the width.
          Row(
            children: [
              if (showToday) ...[
                Expanded(
                  child: FilterChipButton(
                    label: controller.todayLabel,
                    selected: mode == DateFilterMode.today,
                    onTap: controller.showToday,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // One month chip, not two: it always names the month it is
              // showing — the current one until another is picked — and
              // tapping it is how the month is changed.
              Expanded(
                child: FilterChipButton(
                  label: controller.monthLabel,
                  selected: mode == DateFilterMode.month,
                  onTap: () => _pickMonth(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilterChipButton(
                  label: controller.fromLabel.isEmpty
                      ? t('attendance.from_date')
                      : controller.fromLabel,
                  selected: inRange,
                  onTap: () => _pickFrom(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChipButton(
                  label: controller.toLabel.isEmpty
                      ? t('attendance.to_date')
                      : controller.toLabel,
                  selected: inRange,
                  onTap: () => _pickTo(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The last 24 months as "September 2026". A list beats Material's date
  /// picker here: a month needs no day to pick.
  Future<void> _pickMonth(BuildContext context) async {
    final now = DateTime.now();
    final months = List.generate(
      24,
      (index) => DateTime(now.year, now.month - index),
    );

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: months.length,
          itemBuilder: (_, index) {
            final value = months[index];

            return ListTile(
              dense: true,
              title: Text(DateFilterMixin.monthName(value.month, value.year)),
              onTap: () => Navigator.of(sheetContext).pop(value),
            );
          },
        ),
      ),
    );

    if (picked != null) controller.selectMonth(picked);
  }

  /// The From calendar cannot run past the To date already chosen, and the To
  /// calendar cannot start before the From date — so the pair stays valid
  /// whichever one is picked first.
  Future<void> _pickFrom(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: controller.from.value ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: controller.to.value ?? now,
    );

    if (picked != null) controller.setFromDate(picked);
  }

  Future<void> _pickTo(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: controller.to.value ?? now,
      firstDate: controller.from.value ?? DateTime(now.year - 3),
      lastDate: now,
    );

    if (picked != null) controller.setToDate(picked);
  }
}

