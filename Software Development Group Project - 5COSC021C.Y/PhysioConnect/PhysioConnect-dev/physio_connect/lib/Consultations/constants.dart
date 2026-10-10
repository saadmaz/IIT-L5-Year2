class AppConstants {
  static const String appName = 'Physio Connect';

  // API endpoints
  static const String baseUrl = 'https://api.physioconnect.com';
  static const String apiVersion = 'v1';

  // Session durations
  static const int defaultSessionDuration = 45; // in minutes

  // Prices
  static const double standardSessionPrice = 2500.00;
  static const double emergencySessionPrice = 3500.00;

  // Timeout durations
  static const int connectionTimeout = 30; // in seconds
}
