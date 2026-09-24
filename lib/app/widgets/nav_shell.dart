import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/main_shell/controllers/main_shell_controller.dart';
import '../../modules/main_shell/views/widgets/salesman_drawer.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'salesman_bottom_navigation.dart';

/// Puts the bottom navigation bar and the drawer under a pushed screen.
///
/// [MainShellView] builds both itself for its four tabs; every other route is
/// wrapped in this in `AppPages`, so they are on every screen. The child keeps
/// its own `Scaffold` — nested scaffolds are fine, and the inner one still
/// owns the app bar and body.
///
/// The drawer lives on *this* Scaffold, which the child's app bar cannot see,
/// so the key is handed down through [NavShellScope] and opened by
/// [DrawerMenuButton] in the child's own `AppBar`.
///
/// `selectedIndex: -1` leaves every tab unhighlighted, and the bar's own
/// `openMainTab` fallback handles the tap: it returns to the shell on the
/// chosen tab, so no callback is needed here.
class NavShell extends StatefulWidget {
  const NavShell({super.key, required this.child});

  final Widget child;

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // The shell route below this one owns the controller, so it is registered
    // for as long as any of these screens can be on screen; the guard only
    // covers a deep link straight to a pushed route.
    final shell = Get.isRegistered<MainShellController>()
        ? Get.find<MainShellController>()
        : null;

    return Scaffold(
      key: _scaffoldKey,
      // The child's own Scaffold already resizes for the keyboard; letting
      // this one do it as well would shift the page twice.
      resizeToAvoidBottomInset: false,
      drawer: shell == null ? null : SalesmanDrawer(controller: shell),
      // Deliberately NOT extendBody: that would hand the child a bottom
      // MediaQuery inset the size of the bar, which only the scroll views
      // that pass `padding: null` would honour — every other screen would
      // end up with its last row hidden behind the bar.
      body: NavShellScope(
        scaffoldKey: shell == null ? null : _scaffoldKey,
        child: widget.child,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          onPressed: () => Get.toNamed(AppRoutes.products),
          child: const Icon(Icons.inventory_2_outlined),
        ),
      ),
      bottomNavigationBar: const SalesmanBottomNavigation(selectedIndex: -1),
    );
  }
}

/// Hands the enclosing [NavShell]'s scaffold key down to the pushed screen, so
/// a widget inside the child's own `Scaffold` can still open the drawer that
/// belongs to the outer one.
class NavShellScope extends InheritedWidget {
  const NavShellScope({
    super.key,
    required this.scaffoldKey,
    required super.child,
  });

  /// Null when there is no drawer to open — see [NavShell.build].
  final GlobalKey<ScaffoldState>? scaffoldKey;

  static GlobalKey<ScaffoldState>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavShellScope>()
        ?.scaffoldKey;
  }

  @override
  bool updateShouldNotify(NavShellScope oldWidget) =>
      oldWidget.scaffoldKey != scaffoldKey;
}
