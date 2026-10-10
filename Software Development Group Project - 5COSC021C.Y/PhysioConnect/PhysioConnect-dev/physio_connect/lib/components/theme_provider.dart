import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = _lightTheme;

  // Brand Colors
  static const Color primaryTeal = Color(0xFF33724B);
  static const Color lightBackground = Color(0xFFEAF7FF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color selectedCategoryColor = Color(0xFF1F6662);

  // Shared Extensions
  static const Color cardBackgroundLight = Colors.white;
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
  static const Color shadowLight = Colors.black12;
  static const Color shadowDark = Colors.black54;

  static final ThemeData _lightTheme = ThemeData(
    primaryColor: primaryTeal,
    scaffoldBackgroundColor: lightBackground,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryTeal,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: primaryTeal),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal.shade300,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.tealAccent),
  );

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == _lightTheme ? _darkTheme : _lightTheme;
    notifyListeners();
  }

  // ✅ Extension Colors
  Color get categoryHighlight => selectedCategoryColor;
  Color get cardBackground => _currentTheme.brightness == Brightness.dark
      ? cardBackgroundDark
      : cardBackgroundLight;
  Color get shadowColor =>
      _currentTheme.brightness == Brightness.dark ? shadowDark : shadowLight;
}
