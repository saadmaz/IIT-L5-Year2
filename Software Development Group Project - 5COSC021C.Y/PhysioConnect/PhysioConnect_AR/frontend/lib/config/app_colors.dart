// Description: Contains the color palette used throughout the app

import 'package:flutter/material.dart';

/// AppColors class provides consistent color references throughout the app
class AppColors {
  // Primary brand colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color midnightTeal = Color(0xFF33724B);
  static const Color aliceBlue = Color(0xFFEAF7FF);
  
  // Derived colors
  static const Color lightTeal = Color(0xFF5A9476); // Lighter version of midnightTeal
  static const Color darkTeal = Color(0xFF285C3B); // Darker version of midnightTeal
  
  // Functional colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  // Background colors
  static const Color backgroundPrimary = white;
  static const Color backgroundSecondary = aliceBlue;
  static const Color backgroundAccent = midnightTeal;
  
  // Button colors
  static const Color buttonPrimary = midnightTeal;
  static const Color buttonSecondary = aliceBlue;
  
  // Border colors
  static const Color borderColor = Color(0xFFEEEEEE);
}