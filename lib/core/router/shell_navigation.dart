import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/shared/widgets/custom_bottom_nav.dart';

/// Shell widget that wraps the main tabs with a full-width bottom menu.
class ShellNavigation extends StatefulWidget {
  final Widget child;

  const ShellNavigation({
    required this.child,
    super.key,
  });

  @override
  State<ShellNavigation> createState() => _ShellNavigationState();
}

class _ShellNavigationState extends State<ShellNavigation> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (_router == router) return;
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _router = router;
    _router?.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    if (mounted) setState(() {});
  }

  NavItem get _currentItem {
    final route =
        _router?.routerDelegate.currentConfiguration.uri.toString() ?? '';
    if (route.startsWith('/journal')) return NavItem.journal;
    if (route.startsWith('/education')) return NavItem.education;
    return NavItem.cycle;
  }

  void _onNavItemTapped(NavItem item) {
    switch (item) {
      case NavItem.cycle:
        context.go('/cycle');
      case NavItem.journal:
        context.go('/journal');
      case NavItem.education:
        context.go('/education');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentItem,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
