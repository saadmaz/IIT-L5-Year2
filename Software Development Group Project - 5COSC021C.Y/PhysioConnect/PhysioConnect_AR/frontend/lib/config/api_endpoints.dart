// Description: Contains all API endpoints used by the app

import 'app_config.dart';

/// ApiEndpoints class provides centralized access to all API endpoints
class ApiEndpoints {
  static final String baseUrl = AppConfig.apiBaseUrl;
  
  // Authentication endpoints
  static final String login = "$baseUrl/auth/login";
  static final String register = "$baseUrl/auth/register";
  static final String refreshToken = "$baseUrl/auth/refresh";
  static final String forgotPassword = "$baseUrl/auth/forgot-password";
  static final String resetPassword = "$baseUrl/auth/reset-password";
  
  // User endpoints
  static final String userProfile = "$baseUrl/user/profile";
  static final String updateProfile = "$baseUrl/user/profile";
  static final String userSettings = "$baseUrl/user/settings";
  
  // Exercise endpoints
  static final String exercises = "$baseUrl/exercises";
  static final String exerciseById = "$baseUrl/exercises/"; // Append ID
  static final String recommendedExercises = "$baseUrl/exercises/recommended";
  static final String exerciseCategories = "$baseUrl/exercises/categories";
  
  // Posture endpoints
  static final String postureAnalysis = "$baseUrl/posture/analyze";
  static final String postureHistory = "$baseUrl/posture/history";
  static final String postureRecommendations = "$baseUrl/posture/recommendations";
  
  // Progress tracking endpoints
  static final String trackProgress = "$baseUrl/progress/track";
  static final String progressHistory = "$baseUrl/progress/history";
  static final String progressStats = "$baseUrl/progress/stats";
  
  // Feedback endpoints
  static final String submitFeedback = "$baseUrl/feedback";
  static final String feedbackHistory = "$baseUrl/feedback/history";
}
