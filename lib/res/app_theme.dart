import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // アプリで使用するカラーはここに定義する
  static const Color themeColor = Color(0xFFF48FB1);
  static const Color themeAccent = Colors.pinkAccent;

  static const Color morningTemperature = Color(0xFFF892B2);

  static const Color condition = Color(0xFF28A305);
  static const Color medicine = Color(0xFFC68407);
  static const Color walking = Color(0xFF365FEF);

  static const Color mealBreakFast = Color(0xFFFA6B72);
  static const Color mealLunch = Color(0xFFFCA41F);
  static const Color mealDinner = Color(0xFF3D2EAD);

  // テーマ
  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: themeColor,
    primaryColorDark: themeAccent,
    dividerColor: themeAccent,
    appBarTheme: const AppBarTheme(
      color: themeColor,
      centerTitle: true,
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      color: themeAccent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: themeColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: themeAccent,
        side: const BorderSide(color: themeAccent),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: themeAccent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: themeColor,
      foregroundColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: themeColor,
    ),
  );
}
