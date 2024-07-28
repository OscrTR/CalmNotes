import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmotionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: appTheme);
  }
}
