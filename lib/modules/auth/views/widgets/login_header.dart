import 'package:flutter/material.dart';

import '../../../../app/config/app_assets.dart';

/// Brand artwork shown above the login form. The image already carries the
/// company logo on its own green ground, so nothing is drawn over it — the
/// panel is taller than the image's own proportions, which crops its sides
/// (the outer leaf shapes, never the centred logo).
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: Image.asset(
        AppAssets.loginImage,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}
