import 'package:flutter/material.dart';

class SummaryCardModel {
  const SummaryCardModel({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
}
