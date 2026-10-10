import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF06130D),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color(0xFFEAF7FF),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  );
}
