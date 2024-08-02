import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/services/notification_service.dart';
import 'package:calm_notes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmotionProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => ReminderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: appTheme);
  }
}
