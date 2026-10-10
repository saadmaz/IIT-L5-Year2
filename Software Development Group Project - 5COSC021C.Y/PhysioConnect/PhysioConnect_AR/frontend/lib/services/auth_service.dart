// File: lib/services/auth_service.dart
// Description: Service for user authentication
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../config/api_endpoints.dart';
import 'api_service.dart';

/// AuthService handles user authentication and token management
class AuthService {
  // API service for server communication
  final ApiService _apiService;
  
  // Token storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  
  // User stream for auth state changes
  final StreamController<User?> _userStreamController = 
      StreamController<User?>.broadcast();
  
  // Current authenticated user
  User? _currentUser;
  
  // Constructor
  AuthService({required ApiService apiService}) : _apiService = apiService {
    // Initialize by loading user from storage
    _loadSavedUser();
  }
  
  // Getters
  Stream<User?> get userStream => _userStreamController.stream;
  User? get currentUser => _currentUser;
  
  /// Load saved user from local storage
  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check for access token
      final accessToken = prefs.getString(_accessTokenKey);
      if (accessToken == null) {
        _emitAuthState(null);
        return;
      }
      
      // Set token on API service
      _apiService.setAuthToken(accessToken);
      
      // Load user data
      final userData = prefs.getString(_userKey);
      if (userData != null) {
        _currentUser = User.fromJson(json.decode(userData));
        _emitAuthState(_currentUser);
      }
      
      // Validate token by fetching fresh user data
      refreshUserProfile();
    } catch (e) {
      print('Error loading saved user: $e');
      _emitAuthState(null);
    }
  }
  
  /// Emit auth state change
  void _emitAuthState(User? user) {
    _currentUser = user;
    _userStreamController.add(user);
  }
  
  /// Save auth tokens and user data to local storage
  Future<void> _saveAuthData(String accessToken, String refreshToken, User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);
      await prefs.setString(_userKey, json.encode(user.toJson()));
      
      // Update API service with new token
      _apiService.setAuthToken(accessToken);
      
      // Update current user and notify listeners
      _emitAuthState(user);
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }
  
  /// Clear auth data from local storage
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userKey);
      
      // Clear token from API service
      _apiService.clearAuthToken();
      
      // Clear current user and notify listeners
      _emitAuthState(null);
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }
  
  /// Login with email and password
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
        fromJson: (json) {
          final accessToken = json['accessToken'];
          final refreshToken = json['refreshToken'];
          final user = User.fromJson(json['user']);
          
          // Save auth data
          _saveAuthData(accessToken, refreshToken, user);
          
          return user;
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Register new user
  Future<ApiResponse<User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
        fromJson: (json) {
          final accessToken = json['accessToken'];
          final refreshToken = json['refreshToken'];
          final user = User.fromJson(json['user']);
          
          // Save auth data
          _saveAuthData(accessToken, refreshToken, user);
          
          return user;
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Logout current user
  Future<void> logout() async {
    await _clearAuthData();
  }
  
  /// Refresh user profile data
  Future<ApiResponse<User>> refreshUserProfile() async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.userProfile,
        fromJson: (json) {
          final user = User.fromJson(json);
          
          // Update user data
          _currentUser = user;
          _emitAuthState(user);
          
          // Save updated user
          _saveUserData(user);
          
          return user;
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Save only user data (without changing tokens)
  Future<void> _saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
  
  /// Update user profile
  Future<ApiResponse<User>> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.updateProfile,
        body: profileData,
        fromJson: (json) {
          final user = User.fromJson(json);
          
          // Update user data
          _currentUser = user;
          _emitAuthState(user);
          
          // Save updated user
          _saveUserData(user);
          
          return user;
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Request password reset
  Future<ApiResponse<void>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.forgotPassword,
        body: {
          'email': email,
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Reset password with token
  Future<ApiResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.resetPassword,
        body: {
          'token': token,
          'newPassword': newPassword,
        },
      );
      
      return response;
    } catch (e) {
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Refresh the access token using refresh token
  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);
      
      if (refreshToken == null) {
        return false;
      }
      
      final response = await _apiService.post(
        ApiEndpoints.refreshToken,
        body: {
          'refreshToken': refreshToken,
        },
        fromJson: (json) {
          return {
            'accessToken': json['accessToken'],
            'refreshToken': json['refreshToken'],
          };
        },
      );
      
      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        
        // Update tokens
        prefs.setString(_accessTokenKey, newAccessToken);
        prefs.setString(_refreshTokenKey, newRefreshToken);
        
        // Update API service with new token
        _apiService.setAuthToken(newAccessToken);
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }
  
  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }
  
  /// Dispose resources
  void dispose() {
    _userStreamController.close();
  }
}