import 'package:calm_notes/colors.dart';
import 'package:calm_notes/widgets/entry_create_widget.dart';
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
          action: () => GoRouter.of(context).push('/')),
      _NavItem(
          icon: const Icon(Icons.add_circle),
          route: '/entry',
          iconSize: 44,
          action: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (context) {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double screenHeight =
                      MediaQuery.of(context).size.height;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                          top: -15,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: CustomColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ))),
                      SizedBox(
                        width: screenWidth,
                        height: screenHeight - 85,
                        child: const ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                          child: EntryCreate(),
                        ),
                      )
                    ],
                  );
                },
              )
          // showBarModalBottomSheet(
          //   context: context,
          //   useRootNavigator: true,
          //   expand: true,
          //   backgroundColor: CustomColors.backgroundColor,
          //   builder: (context) {
          //     return SizedBox(
          //       height: MediaQuery.of(context)
          //           .size
          //           .height, // Takes up the full height
          //       child: SingleChildScrollView(
          //         controller: ModalScrollController.of(context),
          //         child: Text('hello'),
          //       ),
          //     );
          //   },
          // ),
          ),
      _NavItem(
          icon: const Icon(
            Symbols.analytics,
            weight: 300,
          ),
          route: '/statistics',
          iconSize: 30,
          action: () => GoRouter.of(context).push('/statistics')),
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
