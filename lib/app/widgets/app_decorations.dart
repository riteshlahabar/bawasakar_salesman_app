import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration softCard({
    Color color = AppColors.card,
    double radius = 16,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: .55),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration iconBox(Color color, {double radius = 16}) {
    return BoxDecoration(
      color: color.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration gradientCard(List<Color> colors, {double radius = 30}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      boxShadow: [
        BoxShadow(
          color: colors.first.withValues(alpha: .28),
          blurRadius: 18,
          spreadRadius: 2,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
