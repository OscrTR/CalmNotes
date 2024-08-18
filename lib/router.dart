import 'package:calm_notes/widgets/navigation_bar.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:calm_notes/pages/settings_page.dart';
import 'package:calm_notes/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    ShellRoute(
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const StatisticsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const SettingsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
        ],
        builder: (context, state, child) {
          return Scaffold(
              body: SafeArea(
                child: child,
              ),
              bottomNavigationBar: const CustomNavigationBar());
        })
  ],
);
