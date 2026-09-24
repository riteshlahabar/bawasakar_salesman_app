import 'package:get/get.dart';

import '../data/module_row_mapper.dart';
import '../localization/t.dart';
import 'date_filter_mixin.dart';
import 'remote_module_controller.dart';

/// The year/month window shared by the screens built on `salary_slips` —
/// Salary and Incentives.
///
/// [DateFilterMixin] does not fit those: a slip has only a year and a month,
/// so that mixin's day-level From–To pair cannot select one — a range would
/// match a month only when its 1st happened to fall inside. Here the Year
/// chip refetches (the endpoints take `?year=`) and the Month chip narrows
/// what is already held, with `null` meaning the whole year.
mixin YearMonthFilterMixin on RemoteModuleController {
  final year = DateTime.now().year.obs;

  /// `null` is every month of [year] — what both screens open on.
  final selectedMonth = Rxn<int>();

  /// The last five years, newest first.
  static List<int> get selectableYears {
    final now = DateTime.now().year;

    return List.generate(5, (index) => now - index);
  }

  String get yearLabel => year.value.toString();

  String get monthLabel => selectedMonth.value == null
      ? t('common.all_months')
      : DateFilterMixin.monthName(selectedMonth.value!);

  /// What the stat tiles cover.
  String get windowLabel => selectedMonth.value == null
      ? yearLabel
      : '${DateFilterMixin.monthName(selectedMonth.value!)} ${year.value}';

  /// A different year is a different request, so this goes through [load] —
  /// which each screen overrides to drop its cache first.
  void selectYear(int value) {
    if (value == year.value) return;
    year.value = value;
    load();
  }

  /// `super.load()`, deliberately — not [load], which drops the cache and
  /// refetches. The year's rows are already held, so narrowing to one month
  /// only re-runs the in-memory filter and costs no request.
  void selectMonth(int? value) {
    if (value == selectedMonth.value) return;
    selectedMonth.value = value;
    super.load();
  }

  /// Whether a `salary_slips` row falls in the selected month. Both screens
  /// read the same two columns, so the test lives here rather than twice.
  bool isInMonth(Map<String, dynamic> row) {
    final month = selectedMonth.value;

    return month == null ||
        ModuleRowMapper.toInt(row['salary_month']) == month;
  }

  /// The month's name, for a row title.
  static String rowMonth(Object? month) {
    final index = ModuleRowMapper.toInt(month);

    return index >= 1 && index <= 12 ? DateFilterMixin.monthName(index) : '';
  }
}
