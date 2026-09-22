import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// App icon badge plus title/subtitle shown above the login form.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Image.asset('assets/images/app_logo.png'),
        ),
        const SizedBox(height: 22),
        Text(
          t('auth.welcome_salesman'),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
