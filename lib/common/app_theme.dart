import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.pink[200],
    accentColor: Colors.pinkAccent,
    primaryColorDark: Colors.pink[700],
    backgroundColor: Colors.white,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.pink[300],
      textTheme: ButtonTextTheme.accent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink[200],
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.pink[200],
    accentColor: Colors.pink[300],
    scaffoldBackgroundColor: Color(0xFF232323),
    applyElevationOverlayColor: true,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.pink[300],
      textTheme: ButtonTextTheme.accent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink[200],
    ),
  );
}
