import 'package:flutter/material.dart';

import '../controllers/date_filter_mixin.dart';
import '../controllers/year_month_filter_mixin.dart';
import '../localization/t.dart';
import '../theme/app_colors.dart';
import 'filter_chip_button.dart';

/// Year and month chips, for the screens built on `salary_slips` — Salary and
/// Incentives.
///
/// Not [DateFilterBar]: a slip has only a year and a month, so that bar's
/// day-level From–To pair cannot select one. The Year chip refetches; the
/// Month chip narrows the year already held, and its first entry is "All
/// months". Shares [FilterChipButton] with the date bar so the two controls
/// cannot drift apart visually.
class YearMonthFilterBar extends StatelessWidget {
  const YearMonthFilterBar({super.key, required this.controller});

  final YearMonthFilterMixin controller;

  @override
  Widget build(BuildContext context) {
    // Read in this closure's own scope: passing the observables down to the
    // chips would register nothing with the enclosing Obx.
    final year = controller.year.value;
    final month = controller.selectedMonth.value;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: FilterChipButton(
              label: year.toString(),
              // Always on: a year is always being shown, unlike a month.
              selected: true,
              onTap: () => _pickYear(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilterChipButton(
              label: month == null
                  ? t('common.all_months')
                  : DateFilterMixin.monthName(month),
              selected: month != null,
              onTap: () => _pickMonth(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickYear(BuildContext context) async {
    final picked = await _pick<int>(context, [
      for (final value in YearMonthFilterMixin.selectableYears)
        (value: value, label: value.toString()),
    ]);

    if (picked != null) controller.selectYear(picked.value);
  }

  /// "All months" leads, so clearing the month is one tap from the same place
  /// that set it. Its value is `null`, which is why the sheet hands back a
  /// record rather than the value itself — a bare `null` could not be told
  /// apart from the sheet being dismissed.
  Future<void> _pickMonth(BuildContext context) async {
    final picked = await _pick<int?>(context, [
      (value: null, label: t('common.all_months')),
      for (var index = 1; index <= 12; index++)
        (value: index, label: DateFilterMixin.monthName(index)),
    ]);

    if (picked != null) controller.selectMonth(picked.value);
  }

  /// A plain list sheet. Returns the chosen entry, or null if dismissed.
  Future<({T value, String label})?> _pick<T>(
    BuildContext context,
    List<({T value, String label})> options,
  ) {
    return showModalBottomSheet<({T value, String label})>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: options.length,
          itemBuilder: (_, index) {
            final option = options[index];

            return ListTile(
              dense: true,
              title: Text(option.label),
              onTap: () => Navigator.of(sheetContext).pop(option),
            );
          },
        ),
      ),
    );
  }
}
