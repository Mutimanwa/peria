import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/shared/widgets/custom_bottom_nav.dart';

/// Shell widget that wraps authenticated routes with custom bottom navigation
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
  @override
  void initState() {
    super.initState();
    // Listen to route changes to update the selected index
    GoRouter.of(context).routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    GoRouter.of(context).routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    setState(() {});
  }

  NavItem get _currentItem {
    final route = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    if (route.startsWith('/cycle')) {
      return NavItem.cycle;
    } else if (route.startsWith('/journal')) {
      return NavItem.journal;
    } else if (route.startsWith('/education')) {
      return NavItem.education;
    }
    return NavItem.cycle; // Default to cycle
  }

  void _onNavItemTapped(NavItem item) {
    // Navigate to different routes based on item
    switch (item) {
      case NavItem.cycle:
        context.go('/cycle');
        break;
      case NavItem.journal:
        context.go('/journal');
        break;
      case NavItem.education:
        context.go('/education');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomBottomNav(
            currentIndex: _currentItem,
            onTap: _onNavItemTapped,
          ),
        ),
      ],
    );
  }
}