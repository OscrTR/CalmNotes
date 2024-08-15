import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: CustomColors.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: CustomColors.primaryColor,
      onPrimary: CustomColors.backgroundColor,
      surface: CustomColors.backgroundColor,
      onSurface: CustomColors.primaryColor,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 14,
        color: CustomColors.primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        color: CustomColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: CustomColors.primaryColor,
        fontFamily: 'PlayfairDisplay',
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(color: CustomColors.color10, elevation: 0),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CustomColors.primaryColor,
        side: const BorderSide(color: CustomColors.secondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      foregroundColor: CustomColors.primaryColor,
      splashFactory: NoSplash.splashFactory,
      overlayColor: Colors.transparent,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(0, 40),
    )),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: CustomColors.backgroundColor,
        backgroundColor: CustomColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: CustomColors.backgroundColor,
      dividerColor: CustomColors.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: CustomColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
