import 'package:flutter/material.dart';
import 'colors.dart';
import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppColors.primaryColor,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
