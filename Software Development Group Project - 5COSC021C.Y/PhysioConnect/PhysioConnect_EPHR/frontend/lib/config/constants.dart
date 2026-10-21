/// App-wide constants for PhysioConnect EPHR application
/// Contains fixed values, regulatory text, and configuration values

class AppConstants {
  // App information
  static const String appName = 'PhysioConnect EPHR';
  static const String appVersion = '1.0.0';
  static const String appCompany = 'PhysioConnect';
  
  // API endpoints (to be replaced with actual endpoints)
  static const String apiBaseUrl = 'https://api.physioconnect.com/v1';
  static const String authEndpoint = '$apiBaseUrl/auth';
  static const String userEndpoint = '$apiBaseUrl/users';
  static const String ephrEndpoint = '$apiBaseUrl/ephr';
  static const String documentsEndpoint = '$apiBaseUrl/documents';
  
  // Storage keys for shared preferences
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String onboardingCompleteKey = 'onboarding_complete';
  
  // User roles
  static const String rolePatient = 'patient';
  static const String rolePhysio = 'physiotherapist';
  static const String roleAdmin = 'admin';
  
  // Timeout values
  static const int apiTimeoutSeconds = 30;
  static const int sessionTimeoutMinutes = 30;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Document types
  static const List<String> supportedDocumentTypes = [
    'image/jpeg',
    'image/png',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ];
  static const int maxDocumentSizeMB = 10;
  
  // Privacy and compliance
  static const String privacyPolicyUrl = 'https://www.physioconnect.com/privacy';
  static const String termsOfServiceUrl = 'https://www.physioconnect.com/terms';
  static const String dataProtectionStatement = 'Your health data is protected under applicable data protection laws including HIPAA and GDPR where applicable.';
  
  // Form validation
  static const int minPasswordLength = 8;
  static const String passwordRequirements = 'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.';
  
  // App-specific constants
  static const int painScaleMin = 0;
  static const int painScaleMax = 10;
  static const List<String> painCategories = [
    'Acute',
    'Chronic',
    'Shooting',
    'Throbbing',
    'Burning',
    'Stabbing',
    'Aching',
  ];
  
  // Notification channels
  static const String appointmentNotificationChannel = 'appointment_notifications';
  static const String medicationNotificationChannel = 'medication_notifications';
  static const String generalNotificationChannel = 'general_notifications';
}