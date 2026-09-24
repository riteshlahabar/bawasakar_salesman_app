import 'package:get/get.dart';

import '../localization/t.dart';
import 'remote_module_controller.dart';

/// Which window a filtered module screen is showing.
enum DateFilterMode { today, month, range }

/// The date window shared by the screens that offer a Today / month /
/// From–To filter (Attendance, Dealer Visits).
///
/// It owns nothing but the window itself: the observables, the labels and the
/// four ways to change it. How a screen reacts is left to
/// [onWindowChanged] — Attendance re-requests the range from the API, while
/// Dealer Visits already holds every row and only re-filters in memory.
mixin DateFilterMixin on RemoteModuleController {
  /// The window a screen starts on. Attendance opens on the month (which the
  /// Month chip shows as the current one); Dealer Visits opens on today.
  DateFilterMode get initialFilterMode => DateFilterMode.month;

  /// `late` so the override above is read at first use, not at field-init
  /// time when the subclass has not been set up yet.
  late final mode = initialFilterMode.obs;

  /// The month being shown, as its first day — used by both month modes.
  final month = Rx<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month),
  );

  /// The custom window; only read in [DateFilterMode.range].
  final from = Rxn<DateTime>();
  final to = Rxn<DateTime>();

  bool get isToday => mode.value == DateFilterMode.today;

  bool get isRange => mode.value == DateFilterMode.range;

  /// `YYYY-MM`, for a request that takes a month.
  String get monthParam => '${month.value.year}-${two(month.value.month)}';

  /// "September 2026" — the selected month.
  String get monthLabel => monthName(month.value.month, month.value.year);

  String get todayLabel => t('common.today');

  String get fromLabel => dayLabel(from.value);

  String get toLabel => dayLabel(to.value);

  /// What the figures cover, for a stat tile's subtitle.
  String get windowLabel {
    if (isToday) return todayLabel;
    if (isRange && from.value != null) return '$fromLabel - $toLabel';

    return monthLabel;
  }

  /// Today only — the narrowest window.
  void showToday() {
    mode.value = DateFilterMode.today;
    clearRange();
    onWindowChanged();
  }

  /// A month picked from the month sheet.
  void selectMonth(DateTime value) {
    mode.value = DateFilterMode.month;
    month.value = DateTime(value.year, value.month);
    clearRange();
    onWindowChanged();
  }

  /// Forgets a From-To pair, so its two chips fall back to their "From Date"
  /// / "To Date" labels. Picking Today or a month drops the range: leaving
  /// the old dates on screen would suggest a window that is no longer being
  /// applied, including after the screen is left and reopened.
  void clearRange() {
    from.value = null;
    to.value = null;
  }

  /// The two ends are picked from their own calendars, so either can be set
  /// first. Switching to range mode is immediate — the chips must show what
  /// was chosen — but the screen is only reloaded once both ends exist, and a
  /// reversed pair is swapped so the labels read correctly.
  void setFromDate(DateTime value) => _setRangeEnd(start: value);

  void setToDate(DateTime value) => _setRangeEnd(end: value);

  void _setRangeEnd({DateTime? start, DateTime? end}) {
    mode.value = DateFilterMode.range;

    if (start != null) {
      from.value = DateTime(start.year, start.month, start.day);
    }
    if (end != null) {
      to.value = DateTime(end.year, end.month, end.day);
    }

    final first = from.value;
    final last = to.value;
    if (first == null || last == null) return;

    if (first.isAfter(last)) {
      from.value = last;
      to.value = first;
    }

    onWindowChanged();
  }

  /// What to do when the window changes. Reloading is the safe default; a
  /// screen that already holds all of its rows can override this to re-filter
  /// without going back to the network.
  Future<void> onWindowChanged() => load();

  /// Whether a record's own date falls inside the current window.
  ///
  /// A half-set range narrows nothing — the user has only picked one end yet.
  bool isInWindow(DateTime? value) {
    if (value == null) return false;

    final day = DateTime(value.year, value.month, value.day);

    switch (mode.value) {
      case DateFilterMode.today:
        final now = DateTime.now();

        return day == DateTime(now.year, now.month, now.day);

      case DateFilterMode.month:
        return day.year == month.value.year && day.month == month.value.month;

      case DateFilterMode.range:
        final first = from.value;
        final last = to.value;
        if (first == null || last == null) return true;

        return !day.isBefore(first) && !day.isAfter(last);
    }
  }

  /// "September 2026", or just "September" when [year] is omitted. The names
  /// come from the translation table rather than a hardcoded list, so they
  /// follow the app's language like every other string.
  static String monthName(int monthNumber, [int? year]) {
    final name = t('months.$monthNumber');

    return year == null ? name : '$name $year';
  }

  static String two(int value) => value.toString().padLeft(2, '0');

  static String dayLabel(DateTime? value) => value == null
      ? ''
      : '${two(value.day)}-${two(value.month)}-${value.year}';

  /// `YYYY-MM-DD`, the shape every salesman endpoint expects.
  static String apiDay(DateTime value) =>
      '${value.year}-${two(value.month)}-${two(value.day)}';
}
