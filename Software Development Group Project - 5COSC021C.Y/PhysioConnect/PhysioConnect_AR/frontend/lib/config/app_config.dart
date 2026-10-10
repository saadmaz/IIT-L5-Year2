// Description: Contains app-wide configuration settings

/// AppConfig class holds application-wide configuration settings
class AppConfig {
  // API configuration
  static const String apiBaseUrl = "https://api.physioconnect.com/v1";
  static const int apiTimeoutSeconds = 30;
  
  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // App information
  static const String appName = "PhysioConnect";
  static const String appVersion = "1.0.0";
  
  // Camera settings
  static const double cameraResolutionPreset = 720.0; // 720p resolution
  static const int cameraFrameRate = 30; // frames per second
  
  // Posture detection settings
  static const int postureDetectionIntervalMs = 500; // milliseconds between detection cycles
  static const double postureConfidenceThreshold = 0.75; // minimum confidence score to accept detection
  
  // Feedback settings
  static const int minFeedbackIntervalMs = 2000; // minimum time between audio feedback
  static const bool enableHapticFeedback = true;
  
  // UI settings
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultAnimationDuration = 300.0; // milliseconds
}