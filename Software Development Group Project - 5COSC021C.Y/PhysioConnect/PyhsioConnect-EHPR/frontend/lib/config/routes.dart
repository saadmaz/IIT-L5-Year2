// // frontend/lib/config/routes.dart

// import 'package:flutter/material.dart';
// import '../features/auth/screens/login_screen.dart';
// import '../features/auth/screens/signup_screen.dart';
// import '../features/ehpr/screens/dashboard_screen.dart';
// import '../features/ehpr/screens/record_list_screen.dart';
// import '../features/ehpr/screens/record_detail_screen.dart';
// import '../features/ehpr/screens/assessment/assessment_form_screen.dart';
// import '../features/ehpr/screens/treatment_plans/treatment_plan_screen.dart';

// class AppRoutes {
//   // Route names
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String dashboard = '/dashboard';
//   static const String recordList = '/records';
//   static const String recordDetail = '/records/detail';
//   static const String createRecord = '/records/create';
//   static const String assessment = '/assessment';
//   static const String treatmentPlan = '/treatment-plan';

//   // Route map
//   static Map<String, WidgetBuilder> get routes => {
//     login: (context) => const LoginScreen(),
//     signup: (context) => const SignupScreen(),
//     dashboard: (context) => const DashboardScreen(),
//     recordList: (context) => const RecordListScreen(),
//     recordDetail: (context) => const RecordDetailScreen(),
//     assessment: (context) => const AssessmentFormScreen(),
//     treatmentPlan: (context) => const TreatmentPlanScreen(),
//   };
// }

// File: frontend/lib/config/routes.dart
// Purpose: Define app routes
// Description: Contains route names and mappings to screens

import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/ehpr/screens/dashboard_screen.dart';
import '../features/ehpr/screens/record_list_screen.dart';
import '../features/ehpr/screens/record_detail_screen.dart';
import '../features/ehpr/screens/assessment/assessment_form_screen.dart';
import '../features/ehpr/screens/treatment_plans/treatment_plan_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/ehpr/screens/record_list_screen.dart'; //Updated route

class AppRoutes {
  // Route names
  static const String initial = login; // Initial route
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String recordList = '/records';
  static const String recordDetail = '/records/detail';
  static const String createRecord = '/records/create';
  static const String assessment = '/assessment';
  static const String treatmentPlan = '/treatment-plan';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        dashboard: (context) => const DashboardScreen(),
        recordList: (context) => const RecordListScreen(),
        recordDetail: (context) => const RecordDetailScreen(),
        assessment: (context) => const AssessmentFormScreen(),
        treatmentPlan: (context) => const TreatmentPlanScreen(),
      };
}
