import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'theme/app_theme.dart';

class PhysioConnectApp extends StatefulWidget {
  final SharedPreferences prefs;
  final bool isAuthenticated;
  
  const PhysioConnectApp({
    Key? key, 
    required this.prefs,
    this.isAuthenticated = false,
  }) : super(key: key);

  @override
  _PhysioConnectAppState createState() => _PhysioConnectAppState();
}

class _PhysioConnectAppState extends State<PhysioConnectApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() {
    setState(() {
      _isDarkMode = widget.prefs.getBool('isDarkMode') ?? false;
    });
  }

  // This allows us to update theme from anywhere in the app
  void updateTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    widget.prefs.setBool('isDarkMode', isDarkMode);
  }

  // This allows us to update language from anywhere in the app
  void updateLanguage(String language) {
    setState(() {
    });
    widget.prefs.setString('language', language);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: widget.isAuthenticated
          ? ProfileScreen(prefs: widget.prefs)
          : LoginScreen(prefs: widget.prefs),
      // Define routes for navigation
      routes: {
        '/login': (context) => LoginScreen(prefs: widget.prefs),
        '/profile': (context) => ProfileScreen(prefs: widget.prefs),
      },
    );
  }
}