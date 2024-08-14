import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.backgroundColor,
      surface: AppColors.backgroundColor,
      onSurface: AppColors.primaryColor,
    ),
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
    cardTheme: const CardTheme(color: AppColors.color10, elevation: 0),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.secondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryColor,
      splashFactory: NoSplash.splashFactory,
      overlayColor: Colors.transparent,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(0, 40),
    )),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: AppColors.backgroundColor,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.backgroundColor,
      dividerColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
