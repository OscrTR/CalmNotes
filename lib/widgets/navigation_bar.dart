import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/widgets/entry_create_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

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
          route: '/home',
          iconSize: 30,
          action: () {
            if (GoRouterState.of(context).uri.toString() != '/home') {
              GoRouter.of(context).push('/home');
            }
          }),
      _NavItem(
          icon: const Icon(Icons.add_circle),
          route: '/entry',
          iconSize: 44,
          action: () async {
            await showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    maxChildSize: 0.9,
                    minChildSize: 0.5,
                    snap: true,
                    snapSizes: const [0.9],
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: CustomColors.backgroundColor,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        child: SingleChildScrollView(
                            clipBehavior: Clip.none,
                            controller: scrollController,
                            child: const EntryCreate()),
                      );
                    });
              },
            );
            Future.microtask(() => onModalSheetClosed(context));
          }),
      _NavItem(
        icon: const Icon(
          Symbols.analytics,
          weight: 300,
        ),
        route: '/statistics',
        iconSize: 30,
        action: () {
          if (GoRouterState.of(context).uri.toString() != '/statistics') {
            GoRouter.of(context).push('/statistics');
          }
        },
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
      onPressed: item.action,
      icon: item.icon,
    );
  }
}

void onModalSheetClosed(BuildContext context) {
  Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
  Provider.of<TagProvider>(context, listen: false).resetTags();
}

class _NavItem {
  final Icon icon;
  final String route;
  final double iconSize;
  final VoidCallback action;

  _NavItem({
    required this.icon,
    required this.route,
    required this.iconSize,
    required this.action,
  });
}
