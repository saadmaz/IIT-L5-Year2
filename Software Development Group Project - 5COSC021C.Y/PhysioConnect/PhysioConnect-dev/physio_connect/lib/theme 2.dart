import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static final Color primaryColor = Colors.green.shade700;
  static final Color primaryLightColor = Colors.green.shade100;
  static final Color primaryDarkColor = Colors.green.shade900;

  // Accent colors
  static final Color accentColor = Colors.red.shade600;

  // Text colors
  static final Color primaryTextColor = Colors.black87;
  static final Color secondaryTextColor = Colors.grey.shade700;

  // Background colors
  static final Color backgroundColor = Colors.white;
  static final Color surfaceColor = Colors.grey.shade50;

  // Button themes
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
  );

  static ButtonStyle emergencyButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
  );

  // Card themes
  static CardTheme cardTheme = CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Theme data
  static ThemeData themeData = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    cardTheme: cardTheme,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
  );
}
