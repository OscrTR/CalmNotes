import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> navItems = [
      _NavItem(
        icon: const Icon(
          Symbols.library_books,
          weight: 300,
        ),
        route: '/',
        iconSize: 30,
      ),
      _NavItem(
        icon: const Icon(Icons.add_circle),
        route: '/entry',
        iconSize: 44,
      ),
      _NavItem(
        icon: const Icon(
          Symbols.analytics,
          weight: 300,
        ),
        route: '/statistics',
        iconSize: 30,
      ),
    ];

    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) => _buildNavItem(context, item)).toList(),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item) {
    return IconButton(
      iconSize: item.iconSize,
      color: CustomColors.primaryColor,
      onPressed: () => GoRouter.of(context).push(item.route),
      icon: item.icon,
    );
  }
}

class _NavItem {
  final Icon icon;
  final String route;
  final double iconSize;

  _NavItem({
    required this.icon,
    required this.route,
    required this.iconSize,
  });
}
