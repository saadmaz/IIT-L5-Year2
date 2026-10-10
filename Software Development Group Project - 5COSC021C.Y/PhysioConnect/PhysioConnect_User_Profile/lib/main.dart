// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'app.dart';
// import 'services/auth_service.dart';
// import 'services/user_service.dart';

// void main() async {
//   // Ensure Flutter is initialized
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Force portrait orientation
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
  
//   // Initialize SharedPreferences for local storage
//   final prefs = await SharedPreferences.getInstance();
  
//   // Initialize services
//   final authService = AuthService();
//   final userService = UserService();
  
//   // Check if user is authenticated
//   bool isAuthenticated = false;
//   try {
//     isAuthenticated = await authService.isAuthenticated();
//   } catch (e) {
//     print('Error checking authentication: $e');
//   }
  
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<AuthService>.value(value: authService),
//         Provider<UserService>.value(value: userService),
//         Provider<SharedPreferences>.value(value: prefs),
//       ],
//       child: PhysioConnectApp(
//         prefs: prefs,
//         isAuthenticated: isAuthenticated,
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize SharedPreferences for local storage
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize services
  final authService = AuthService();
  final userService = UserService();
  
  // Check if user is authenticated
  bool isAuthenticated = false;
  try {
    isAuthenticated = await authService.isAuthenticated();
  } catch (e) {
    print('Error checking authentication: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<UserService>.value(value: userService),
        Provider<SharedPreferences>.value(value: prefs),
      ],
      child: PhysioConnectApp(
        prefs: prefs,
        isAuthenticated: isAuthenticated,
      ),
    ),
  );
}