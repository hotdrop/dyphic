import 'package:dyphic/res/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: AppColors.themeColor,
    primaryColorDark: AppColors.themeAccent,
    dividerColor: AppColors.themeAccent,
    appBarTheme: const AppBarTheme(
      color: AppColors.themeColor,
      centerTitle: true,
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      color: AppColors.themeAccent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.themeColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.themeAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.themeAccent,
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
