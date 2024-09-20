import 'package:calm_notes/providers/animation_provider.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:calm_notes/services/notification_service.dart';
import 'package:calm_notes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';

final DatabaseService _databaseService = DatabaseService.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.initializeNotifications();
  await _databaseService.checkIfColumnExists();
  await _databaseService.convertOldEntries();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmotionProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => ReminderProvider()),
        ChangeNotifierProvider(create: (context) => EntryProvider()),
        ChangeNotifierProvider(create: (context) => AnimationStateNotifier()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
