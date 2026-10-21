import 'package:flutter/material.dart';

/// Theme configuration for PhysioConnect EPHR application
/// Contains color scheme and text themes using the brand colors:
/// - White: #FFFFFF
/// - Midnight Teal: #33724B
/// - Alice Blue: #EAF7FF

class AppTheme {
  // App color constants
  static const Color white = Color(0xFFFFFFFF);
  static const Color midnightTeal = Color(0xFF33724B);
  static const Color aliceBlue = Color(0xFFEAF7FF);
  
  // Secondary/supporting colors
  static const Color darkGrey = Color(0xFF404040);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color errorRed = Color(0xFFE53935);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color successGreen = Color(0xFF4CAF50);
  
  // Light theme configuration
  static ThemeData lightTheme() {
    return ThemeData(
      // Base colors
      primaryColor: midnightTeal,
      scaffoldBackgroundColor: white,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: midnightTeal,
        secondary: aliceBlue,
        surface: white,
        background: white,
        error: errorRed,
        onPrimary: white,
        onSecondary: darkGrey,
        onSurface: darkGrey,
        onBackground: darkGrey,
        onError: white,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: midnightTeal,
        foregroundColor: white,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: const CardTheme(
        color: white,
        shadowColor: Colors.black12,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: midnightTeal,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: midnightTeal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: midnightTeal,
          side: const BorderSide(color: midnightTeal),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: aliceBlue,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: midnightTeal),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: lightGrey,
        thickness: 1,
        space: 24,
      ),
      
      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkGrey,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkGrey,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: darkGrey,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: darkGrey,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: midnightTeal,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}