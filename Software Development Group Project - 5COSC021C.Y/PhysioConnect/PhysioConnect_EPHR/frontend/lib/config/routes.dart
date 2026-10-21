// Corrected AppRoutes class with fixed route generation function

import 'package:flutter/material.dart';

// Import patient screens
import '../views/patient/dashboard/dashboard_screen.dart';
import '../views/patient/medical_history/medical_history_screen.dart';
import '../views/patient/medical_history/medical_entry_detail.dart';
import '../views/patient/medications/medications_screen.dart';
import '../views/patient/medications/medication_detail.dart';
import '../views/patient/medications/add_medication_screen.dart';
import '../views/patient/physio_records/physio_records_screen.dart';
import '../views/patient/physio_records/session_detail_screen.dart';
import '../views/patient/physio_records/exercises_screen.dart';
import '../views/patient/pain_tracker/pain_tracker_screen.dart';
import '../views/patient/pain_tracker/add_pain_entry.dart';
import '../views/patient/pain_tracker/pain_history_screen.dart';
import '../views/patient/test_results/test_results_screen.dart';
import '../views/patient/test_results/test_detail_screen.dart';
import '../views/patient/appointments/appointments_screen.dart';
import '../views/patient/appointments/book_appointment_screen.dart';
import '../views/patient/appointments/appointment_detail.dart';
import '../views/patient/emergency_info/emergency_info_screen.dart';
import '../views/patient/documents/documents_screen.dart';
import '../views/patient/documents/upload_document_screen.dart';
import '../views/patient/profile/profile_screen.dart';
import '../views/patient/profile/settings_screen.dart';
import '../views/patient/consent/consent_screen.dart';

// Import physio screens
import '../views/physio/patient_list/patient_list_screen.dart';
import '../views/physio/patient_records/patient_record_screen.dart';
import '../views/physio/document_upload/document_upload_screen.dart';
import '../views/physio/communication/communication_screen.dart';

/// Routes configuration for PhysioConnect EPHR application
/// Manages navigation paths and route generation for both 
/// patient and physiotherapist sides of the app

class AppRoutes {
  // Patient-side routes
  static const String patientDashboard = '/patient/dashboard';
  static const String medicalHistory = '/patient/medical-history';
  static const String medicalEntryDetail = '/patient/medical-history/detail';
  static const String medications = '/patient/medications';
  static const String medicationDetail = '/patient/medications/detail';
  static const String addMedication = '/patient/medications/add';
  static const String physioRecords = '/patient/physio-records';
  static const String sessionDetail = '/patient/physio-records/session';
  static const String exercises = '/patient/physio-records/exercises';
  static const String painTracker = '/patient/pain-tracker';
  static const String addPainEntry = '/patient/pain-tracker/add';
  static const String painHistory = '/patient/pain-tracker/history';
  static const String testResults = '/patient/test-results';
  static const String testDetail = '/patient/test-results/detail';
  static const String appointments = '/patient/appointments';
  static const String bookAppointment = '/patient/appointments/book';
  static const String appointmentDetail = '/patient/appointments/detail';
  static const String emergencyInfo = '/patient/emergency-info';
  static const String documents = '/patient/documents';
  static const String uploadDocument = '/patient/documents/upload';
  static const String profile = '/patient/profile';
  static const String settings = '/patient/profile/settings';
  static const String consent = '/patient/consent';
  
  // Physio-side routes
  static const String physioPatientList = '/physio/patient-list';
  static const String physioPatientRecord = '/physio/patient-record';
  static const String physioDocumentUpload = '/physio/document-upload';
  static const String physioCommunication = '/physio/communication';
  
  // Initial route
  static const String initialRoute = patientDashboard;
  
  /// Route generator function to be used with Navigator 2.0 or onGenerateRoute
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if available
    final args = settings.arguments;
    
    // Use if-else statements instead of switch-case with non-constant expressions
    if (settings.name == patientDashboard) {
      return MaterialPageRoute(builder: (_) => const DashboardScreen());
    } else if (settings.name == medicalHistory) {
      return MaterialPageRoute(builder: (_) => const MedicalHistoryScreen());
    } else if (settings.name == medicalEntryDetail) {
      return MaterialPageRoute(
        builder: (_) => MedicalEntryDetail(record: args as Map<String, dynamic>)
      );
    } else if (settings.name == medications) {
      return MaterialPageRoute(builder: (_) => const MedicationsScreen());
    } else if (settings.name == medicationDetail) {
      return MaterialPageRoute(
        builder: (_) => MedicationDetail(medication: args as Map<String, dynamic>)
      );
    } else if (settings.name == addMedication) {
      return MaterialPageRoute(builder: (_) => const AddMedicationScreen());
    } else if (settings.name == physioRecords) {
      return MaterialPageRoute(builder: (_) => const PhysioRecordsScreen());
    } else if (settings.name == sessionDetail) {
      return MaterialPageRoute(
        builder: (_) => SessionDetailScreen(session: args as Map<String, dynamic>)
      );
    } else if (settings.name == exercises) {
      return MaterialPageRoute(builder: (_) => const ExercisesScreen());
    } else if (settings.name == painTracker) {
      return MaterialPageRoute(builder: (_) => const PainTrackerScreen());
    } else if (settings.name == addPainEntry) {
      return MaterialPageRoute(builder: (_) => const AddPainEntryScreen());
    } else if (settings.name == painHistory) {
      return MaterialPageRoute(builder: (_) => const PainHistoryScreen());
    } else if (settings.name == testResults) {
      return MaterialPageRoute(builder: (_) => const TestResultsScreen());
    } else if (settings.name == testDetail) {
      return MaterialPageRoute(
        builder: (_) => TestDetailScreen(test: args as Map<String, dynamic>)
      );
    } else if (settings.name == appointments) {
      return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
    } else if (settings.name == bookAppointment) {
      return MaterialPageRoute(builder: (_) => const BookAppointmentScreen());
    } else if (settings.name == appointmentDetail) {
      return MaterialPageRoute(
        builder: (_) => AppointmentDetail(appointment: args as Map<String, dynamic>)
      );
    } else if (settings.name == emergencyInfo) {
      return MaterialPageRoute(builder: (_) => const EmergencyInfoScreen());
    } else if (settings.name == documents) {
      return MaterialPageRoute(builder: (_) => const DocumentsScreen());
    } else if (settings.name == uploadDocument) {
      return MaterialPageRoute(builder: (_) => const UploadDocumentScreen());
    } else if (settings.name == profile) {
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    } else if (settings.name == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else if (settings.name == consent) {
      return MaterialPageRoute(builder: (_) => const ConsentScreen());
    } 
    // Physio-side route handlers
    else if (settings.name == physioPatientList) {
      return MaterialPageRoute(builder: (_) => const PatientListScreen());
    } else if (settings.name == physioPatientRecord) {
      return MaterialPageRoute(
        builder: (_) => PatientRecordScreen(patientId: args as String)
      );
    } else if (settings.name == physioDocumentUpload) {
      return MaterialPageRoute(builder: (_) => const DocumentUploadScreen());
    } else if (settings.name == physioCommunication) {
      return MaterialPageRoute(builder: (_) => const CommunicationScreen());
    } 
    // Default case for unknown routes
    else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
    }
  }
}