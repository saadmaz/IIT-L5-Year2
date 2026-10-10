import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_coordinator.dart';
import 'splash_screen.dart';
import 'signup_page.dart';
import 'login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PhysioConnectApp());
}

class PhysioConnectApp extends StatelessWidget {
  const PhysioConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhysioConnect',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF33724B),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF33724B),
          secondary: const Color(0xFF1E4D33),
          background: Colors.white,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: Color(0xFF33724B), fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF333333)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF33724B),
            foregroundColor: Colors.white,
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF33724B),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const AppCoordinator(),
      },
    );
  }
}
