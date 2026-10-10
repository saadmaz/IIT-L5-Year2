// File: frontend/lib/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'core/services/auth_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/ehpr/screens/dashboard_screen.dart';

class PhysioConnectApp extends StatelessWidget {
  const PhysioConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioConnect EHPR',
      theme:
          AppTheme
              .lightTheme, // Custom theme using Midnight Teal, White, Alice Blue
      debugShowCheckedModeBanner: false,
      // Use FutureBuilder to check auth status and decide initial route
      home: FutureBuilder<bool>(
        future:
            Provider.of<AuthService>(context, listen: false).checkAuthStatus(),
        builder: (context, snapshot) {
          // Show loading indicator while checking auth status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Navigate based on auth status
          final isAuthenticated = snapshot.data ?? false;
          if (isAuthenticated) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: AppRoutes.routes,
    );
  }
}
