import 'package:dyphic/res/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: AppColors.themeColor,
    primaryColorDark: AppColors.themeAccent,
    dividerColor: AppColors.themeAccent,
    toggleableActiveColor: AppColors.themeColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.themeColor,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.themeColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: AppColors.themeAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppColors.themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: AppColors.themeAccent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.themeColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.themeColor,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.themeColor,
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
    dividerColor: AppColors.themeAccent,
    toggleableActiveColor: AppColors.themeAccent,
    appBarTheme: const AppBarTheme(
      color: AppColors.themeColor,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.themeColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: AppColors.themeAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppColors.themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: AppColors.themeAccent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.themeColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.themeColor,
    ),
  );
}
