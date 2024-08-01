import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              iconSize: 30,
              color: AppColors.primaryColor,
              onPressed: () => GoRouter.of(context).push('/'),
              icon: const Icon(
                Symbols.library_books,
                weight: 300,
              )),
          IconButton(
              iconSize: 44,
              color: AppColors.primaryColor,
              onPressed: () {
                GoRouter.of(context).push('/entry');
              },
              icon: const Icon(Icons.add_circle)),
          IconButton(
              iconSize: 30,
              color: AppColors.primaryColor,
              onPressed: () => GoRouter.of(context).push('/statistics'),
              icon: const Icon(
                Symbols.analytics,
                weight: 300,
              )),
        ],
      ),
    );
  }
}
