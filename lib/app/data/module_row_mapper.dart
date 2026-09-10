import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'models/list_row_model.dart';
import 'models/summary_card_model.dart';

/// Shared helpers for turning API payloads into module rows and stat tiles.
///
/// Every salesman module does the same handful of conversions — pull a list
/// out of a `data` envelope, read a number that may arrive as a string, colour
/// a row by its workflow status. Keeping them here stops twenty controllers
/// from each carrying their own slightly different version.
class ModuleRowMapper {
  ModuleRowMapper._();

  /// Extracts a list of JSON objects from `data.<key>`, tolerating both a bare
  /// array and Laravel's paginator shape (`{data: [...]}`).
  static List<Map<String, dynamic>> listFrom(
    Map<String, dynamic> response,
    String key,
  ) {
    final data = response['data'];
    if (data is! Map) return const [];

    var raw = data[key];
    if (raw is Map && raw['data'] is List) raw = raw['data'];
    if (raw is! List) return const [];

    return raw.whereType<Map<String, dynamic>>().toList();
  }

  /// Reads `data.<key>` as a nested object, or an empty map.
  static Map<String, dynamic> mapFrom(
    Map<String, dynamic> response,
    String key,
  ) {
    final data = response['data'];
    if (data is! Map) return const {};

    final raw = data[key];
    return raw is Map<String, dynamic> ? raw : const {};
  }

  /// JSON numbers arrive as int, double or string depending on the column
  /// type, so every numeric read goes through here.
  static double toDouble(Object? value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;

  static int toInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

  static String money(Object? value) =>
      '₹${toDouble(value).toStringAsFixed(0)}';

  /// Trims an ISO timestamp down to the date the UI shows.
  static String date(Object? value) {
    final text = value?.toString() ?? '';
    if (text.length < 10) return text;
    return text.substring(0, 10);
  }

  /// Maps a workflow status onto the palette, so "approved" is green and
  /// "rejected" is red on every screen without each one deciding for itself.
  static Color statusColor(String? status) {
    return switch (status?.toLowerCase()) {
      'approved' || 'paid' || 'completed' || 'present' || 'active' ||
      'delivered' || 'published' =>
        AppColors.success,
      'rejected' || 'cancelled' || 'absent' || 'overdue' => AppColors.danger,
      'pending' || 'requested' || 'draft' || 'half_day' => AppColors.orange,
      _ => AppColors.info,
    };
  }

  static ListRowModel row({
    required String title,
    required String subtitle,
    required String trailing,
    required IconData icon,
    String? status,
  }) {
    return ListRowModel(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      icon: icon,
      status: status,
      color: statusColor(status),
    );
  }

  static SummaryCardModel stat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return SummaryCardModel(
      title: title,
      value: value,
      icon: icon,
      color: color,
      subtitle: subtitle,
    );
  }
}
