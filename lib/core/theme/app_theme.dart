import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6750A4);
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.light,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: Brightness.dark,
    );
  }
}
