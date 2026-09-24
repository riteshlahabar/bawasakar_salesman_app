import 'package:flutter/material.dart';

import '../localization/t.dart';
import 'nav_shell.dart';

/// The three-line drawer button for a pushed screen's own `AppBar`.
///
/// It goes in `leading`, where the Home screen's hamburger sits, so the menu
/// is in the same place on every screen — which means these screens show no
/// back arrow and are left with the phone's own back button. The drawer
/// itself belongs to the enclosing [NavShell]'s Scaffold, reached through
/// [NavShellScope]; on a screen with no NavShell around it (the main shell's
/// own tabs, which have their own drawer) this renders nothing.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = NavShellScope.of(context);
    if (scaffoldKey == null) return const SizedBox.shrink();

    return IconButton(
      tooltip: t('common.menu'),
      icon: const Icon(Icons.menu),
      onPressed: () => scaffoldKey.currentState?.openDrawer(),
    );
  }
}
