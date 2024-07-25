import 'package:calm_notes/navigation_bar.dart';
import 'package:calm_notes/screen_entry.dart';
import 'package:calm_notes/screen_home.dart';
import 'package:calm_notes/screen_settings.dart';
import 'package:calm_notes/screen_statistics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    ShellRoute(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ScreenHome(),
          ),
          GoRoute(
            path: '/statistics',
            builder: (context, state) => const ScreenStatistics(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const ScreenSettings(),
          ),
          GoRoute(
            path: '/entry',
            builder: (context, state) => const ScreenEntry(),
          ),
        ],
        builder: (context, state, child) {
          return Scaffold(
              body: child, bottomNavigationBar: const CustomNavigationBar());
        })
  ],
);
