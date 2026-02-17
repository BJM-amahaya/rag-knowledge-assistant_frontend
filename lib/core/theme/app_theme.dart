import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color successColor = Color(0xFF4CAF50);

  static ShadThemeData get lightShadTheme {
    return ShadThemeData(
      colorScheme: const ShadVioletColorScheme.light(),
      brightness: Brightness.light,
    );
  }

  static ShadThemeData get darkShadTheme {
    return ShadThemeData(
      colorScheme: const ShadVioletColorScheme.dark(),
      brightness: Brightness.dark,
    );
  }
}
