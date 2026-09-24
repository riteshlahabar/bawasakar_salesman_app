/// Turns an API timestamp into a clock time the salesman can read.
///
/// The server sends UTC (`2026-09-22T11:05:00.000000Z`), so the string has to
/// be parsed and converted to the device's timezone — slicing `HH:mm` straight
/// out of the text, as this app used to, showed UTC and was 5h30m out in
/// India. Written by hand because this app has no `intl` dependency.
String clockTime(String? timestamp, {String fallback = '--:--'}) {
  final parsed = DateTime.tryParse(timestamp ?? '');
  if (parsed == null) return fallback;

  final local = parsed.toLocal();
  final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');

  return '$hour12:$minute ${local.hour < 12 ? 'AM' : 'PM'}';
}
