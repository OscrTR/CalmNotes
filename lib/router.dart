import 'package:calm_notes/navigation_bar.dart';
import 'package:calm_notes/pages/screen_entry.dart';
import 'package:calm_notes/pages/screen_home.dart';
import 'package:calm_notes/pages/screen_settings.dart';
import 'package:calm_notes/pages/screen_statistics.dart';
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
              child: const ScreenHome(),
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
              child: const ScreenStatistics(),
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
              child: const ScreenSettings(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
          GoRoute(
            path: '/entry',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ScreenEntry(),
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
                  child: child,
                ),
              ),
              bottomNavigationBar: const CustomNavigationBar());
        })
  ],
);
