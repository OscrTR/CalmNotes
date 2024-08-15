import 'package:calm_notes/components/navigation_bar.dart';
import 'package:calm_notes/pages/entry_detail_page.dart';
import 'package:calm_notes/pages/entry_create.page.dart';
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
          GoRoute(
            path: '/entry',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const EntryCreationPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
          GoRoute(
            path: '/entry/:entryId',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: EntryDetailPage(
                  entryId: int.parse(state.pathParameters['entryId']!)),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // No transition
                return child;
              },
            ),
          ),
        ],
        builder: (context, state, child) {
          final RegExp entryPattern = RegExp(r'^/entry($|/.*)');
          return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
                  child: child,
                ),
              ),
              bottomNavigationBar: !entryPattern
                      .hasMatch(GoRouterState.of(context).uri.toString())
                  ? const CustomNavigationBar()
                  : null);
        })
  ],
);
