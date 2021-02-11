import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.lightBlue,
    accentColor: Colors.lightBlue,
    primaryColorDark: Colors.indigoAccent,
    backgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFF232323),
    applyElevationOverlayColor: true,
  );
}
