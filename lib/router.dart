import 'package:calm_notes/widgets/navigation_bar.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:calm_notes/pages/settings_page.dart';
import 'package:calm_notes/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(-1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const StatisticsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
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
