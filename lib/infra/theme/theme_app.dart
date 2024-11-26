import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xFF89A8B2),
        onPrimary: const Color(0xFFBCD9D9),
        secondary: const Color(0xFFFFE2A8),
        onSecondary: const Color(0xFFFFF4DD),
        error: const Color(0xFFCF5656),
        onError: const Color(0xFFCF5656),
        surface: const Color(0xFFF9FFFF),
        onSurface: Colors.black.withOpacity(0.6),
        tertiary: Colors.white,
      ),
      fontFamily: 'Roboto');
}
