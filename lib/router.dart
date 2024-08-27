import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/pages/entry_page.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:calm_notes/widgets/navigation_bar.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:calm_notes/pages/settings_page.dart';
import 'package:calm_notes/pages/statistics_page.dart';
import 'package:calm_notes/widgets/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final DatabaseService _databaseService = DatabaseService.instance;
// GoRouter configuration
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
            pageBuilder: (context, state) =>
                const CupertinoPage(child: HomePage()),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: StatisticsPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: SettingsPage()),
          ),
          GoRoute(
            path: '/entry',
            pageBuilder: (context, state) =>
                const CupertinoPage(child: EntryCreate()),
          ),
          GoRoute(
            path: '/entry/:entryId',
            pageBuilder: (context, state) {
              final id = int.parse(state.pathParameters['entryId']!);
              return CupertinoPage(
                child: EntryCreateFuture(entryId: id),
              );
            },
          ),
          // GoRoute(
          //   path: '/home',
          //   pageBuilder: (context, state) => CustomTransitionPage(
          //     key: state.pageKey,
          //     child: const HomePage(),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       final String extraString =
          //           GoRouterState.of(context).extra.toString();
          //       if (extraString == 'splash') {
          //         return child;
          //       }
          //       const begin = Offset(-1.0, 0.0);
          //       const end = Offset.zero;
          //       const curve = Curves.ease;

          //       var tween = Tween(begin: begin, end: end)
          //           .chain(CurveTween(curve: curve));

          //       return SlideTransition(
          //         position: animation.drive(tween),
          //         child: child,
          //       );
          //     },
          //   ),
          // ),
          // GoRoute(
          //   path: '/statistics',
          //   pageBuilder: (context, state) => CustomTransitionPage(
          //     key: state.pageKey,
          //     child: const StatisticsPage(),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       const begin = Offset(1.0, 0.0);
          //       const end = Offset.zero;
          //       const curve = Curves.ease;

          //       var tween = Tween(begin: begin, end: end)
          //           .chain(CurveTween(curve: curve));

          //       return SlideTransition(
          //         position: animation.drive(tween),
          //         child: child,
          //       );
          //     },
          //   ),
          // ),
          // GoRoute(
          //   path: '/settings',
          //   pageBuilder: (context, state) => CustomTransitionPage(
          //     key: state.pageKey,
          //     child: const SettingsPage(),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       // No transition
          //       return child;
          //     },
          //   ),
          // ),
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

class EntryCreateFuture extends StatelessWidget {
  final int entryId;

  const EntryCreateFuture({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Entry>(
      future: _databaseService.getEntry(entryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Entry not found'));
        } else {
          final entry = snapshot.data!;
          return EntryCreate(
              entry: entry); // Pass the loaded entry to the EntryCreate widget
        }
      },
    );
  }
}
