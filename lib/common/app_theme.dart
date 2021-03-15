import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.pink[200],
    accentColor: Colors.pinkAccent,
    primaryColorDark: Colors.pink[700],
    backgroundColor: Colors.white,
    dividerColor: Colors.pinkAccent,
    toggleableActiveColor: Colors.pinkAccent,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.pinkAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.pink[200],
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Colors.pinkAccent,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink[200],
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.pink[200],
    accentColor: Colors.pink[300],
    scaffoldBackgroundColor: Color(0xFF232323),
    applyElevationOverlayColor: true,
    dividerColor: Colors.pinkAccent,
    toggleableActiveColor: Colors.pinkAccent,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.pinkAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.pink[200],
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Colors.pinkAccent,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink[200],
    ),
  );
}
