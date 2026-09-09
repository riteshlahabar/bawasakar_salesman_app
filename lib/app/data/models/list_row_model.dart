import 'package:flutter/material.dart';

class ListRowModel {
  const ListRowModel({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    this.status,
    this.color,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;
  final String? status;
  final Color? color;
}
