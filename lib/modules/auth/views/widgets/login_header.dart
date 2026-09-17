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
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.business_center_rounded,
            size: 46,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          t('auth.bawaskar_salesman'),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          t('auth.salesman_erp_login'),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
