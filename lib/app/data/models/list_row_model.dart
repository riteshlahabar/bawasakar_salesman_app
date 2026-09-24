import 'package:flutter/material.dart';

class ListRowModel {
  const ListRowModel({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    this.status,
    this.color,
    this.subtitleSpans,
    this.titleTrailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final String? status;
  final Color? color;

  /// A coloured subtitle, for rows whose second line carries several distinct
  /// values — the attendance sheet's check-in, check-out and hours. When it is
  /// null the plain [subtitle] string is drawn instead.
  final List<InlineSpan>? subtitleSpans;

  /// A second value on the title's own line, right-aligned — the visit log's
  /// date, which belongs beside the dealer rather than in the right-hand
  /// column where the time sits.
  final String? titleTrailing;

  /// What tapping the row does. Null on every module whose rows are only a
  /// record to read, which is most of them.
  final VoidCallback? onTap;
}
