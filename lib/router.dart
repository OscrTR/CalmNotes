import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/pages/entry_page.dart';
import 'package:calm_notes/providers/animation_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:calm_notes/widgets/navigation_bar.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:calm_notes/pages/settings_page.dart';
import 'package:calm_notes/pages/statistics_page.dart';
import 'package:calm_notes/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final DatabaseService _databaseService = DatabaseService.instance;
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    ShellRoute(
        routes: [
          GoRoute(
              path: '/home',
              pageBuilder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (context.mounted) {
                    await context
                        .read<AnimationStateNotifier>()
                        .setAnimate(false);
                  }
                });
                return CustomTransitionPage(
                    child: const HomePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    });
              }),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const StatisticsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                }),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const SettingsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                }),
          ),
          GoRoute(
            path: '/entry',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const EntryCreate(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                }),
          ),
          GoRoute(
            path: '/entry/:entryId',
            pageBuilder: (context, state) {
              final id = int.parse(state.pathParameters['entryId']!);
              return CustomTransitionPage(
                  child: EntryCreateFuture(entryId: id),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  });
            },
          ),
        ],
        builder: (context, state, child) {
          final bool isEntryPage = state.uri.toString() == '/entry';
          return Scaffold(
            body: SafeArea(
              child: child,
            ),
            bottomNavigationBar:
                isEntryPage ? null : const CustomNavigationBar(),
          );
        })
  ],
);

class EntryCreateFuture extends StatelessWidget {
  final int entryId;

  const EntryCreateFuture({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Entry>(
      future: _databaseService.getEntry(entryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Entry not found'));
        } else {
          final entry = snapshot.data!;
          return EntryCreate(entry: entry);
        }
      },
    );
  }
}
