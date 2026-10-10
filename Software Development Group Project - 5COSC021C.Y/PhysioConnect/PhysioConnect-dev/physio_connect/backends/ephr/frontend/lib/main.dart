// frontend/lib/main.dart

import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize any required services here
  // Example: await Firebase.initializeApp();

  // Run the app
  runApp(const PhysioConnectApp());
}
