import 'package:flutter/material.dart';

/// AppTheme handles all the theming and color constants
/// for the entire application
class AppTheme {
  // Primary colors
  static const Color midnightTeal = Color(0xFF33724B);
  static const Color aliceBlue = Color(0xFFEAF7FF);
  static const Color white = Color(0xFFFFFFFF);

  // Secondary colors for contrast and highlights
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF4A4A4A);
  static const Color errorRed = Color(0xFFD32F2F);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  /// Light theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: midnightTeal,
    scaffoldBackgroundColor: aliceBlue,
    colorScheme: ColorScheme.light(
      primary: midnightTeal,
      secondary: aliceBlue,
      surface: white,
      error: errorRed,
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      labelLarge: TextStyle(
        color: midnightTeal,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: midnightTeal,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
    ),

    // ElevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: midnightTeal,
        foregroundColor: white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: midnightTeal),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorRed),
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
