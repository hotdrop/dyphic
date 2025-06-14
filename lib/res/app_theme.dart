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
      selectedColor: themeColor,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return themeColor; // ON時のトラックの色
        }
        return Colors.grey.shade100; // OFF時のトラックの色
      }),
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // ON時のサムの色
          }
          return Colors.grey; // OFF時のサムの色
        },
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return themeColor; // チェックが入ってる時の色
          }
          return Colors.white; // チェックがない時の色
        },
      ),
      // チェックマークの色
      checkColor: WidgetStateProperty.all<Color>(Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: themeColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.disabled) ? Colors.grey : themeColor;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          return states.contains(WidgetState.disabled) ? const BorderSide(color: Colors.grey) : const BorderSide(color: themeColor);
        }),
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
        foregroundColor: themeAccent,
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
