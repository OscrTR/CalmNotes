import 'package:calm_notes/colors.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                  iconSize: 30,
                  color: AppColors.primaryColor,
                  onPressed: () => GoRouter.of(context).push('/settings'),
                  icon: const Icon(
                    Symbols.settings,
                    weight: 300,
                  )),
            ],
          ),
          Text(
            "Don't make a bad day make you feel like you have a bad life.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}