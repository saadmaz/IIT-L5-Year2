import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/constants.dart';
import '../models/user.dart';

/// Authentication service for handling user login, registration, and session management
/// Manages user state and authentication tokens

class AuthService {
  // User state management
  final UserState userState = UserState();
  
  // Token storage
  String? _authToken;
  String? get authToken => _authToken;
  
  /// Initialize the auth service, check for existing token
  Future<void> init() async {
    // TODO: Load token from secure storage
    // For now, just placeholder implementation
    userState.setLoading(true);
    try {
      // Check if we have a stored token and fetch user if we do
      // This would be implemented to fetch from secure storage
      userState.setLoading(false);
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
    }
  }
  
  /// Login with email and password
  Future<bool> login(String email, String password) async {
    userState.setLoading(true);
    
    try {
      // API call to login
      final response = await http.post(
        Uri.parse('${AppConstants.authEndpoint}/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        
        // Fetch user details
        final userResponse = await http.get(
          Uri.parse('${AppConstants.userEndpoint}/me'),
          headers: {
            'Authorization': 'Bearer $_authToken',
          },
        ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
        
        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          final user = User.fromJson(userData);
          userState.setUser(user);
          
          // TODO: Store token in secure storage
          
          userState.setLoading(false);
          return true;
        } else {
          userState.setError('Failed to get user details');
          userState.setLoading(false);
          return false;
        }
      } else {
        userState.setError('Invalid credentials');
        userState.setLoading(false);
        return false;
      }
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
      return false;
    }
  }
  
  /// Register a new user
  Future<bool> register(Map<String, dynamic> userData) async {
    userState.setLoading(true);
    
    try {
      // API call to register
      final response = await http.post(
        Uri.parse('${AppConstants.authEndpoint}/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 201) {
        userState.setLoading(false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        userState.setError(data['message'] ?? 'Registration failed');
        userState.setLoading(false);
        return false;
      }
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
      return false;
    }
  }
  
  /// Logout the current user
  Future<void> logout() async {
    userState.setLoading(true);
    
    try {
      // API call to logout (if needed)
      _authToken = null;
      userState.clearUser();
      
      // TODO: Remove token from secure storage
      
      userState.setLoading(false);
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
    }
  }
  
  /// Check if the current user is authenticated
  bool isAuthenticated() {
    return _authToken != null && userState.isLoggedIn;
  }
  
  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    if (!isAuthenticated()) return false;
    
    userState.setLoading(true);
    
    try {
      // API call to update profile
      final response = await http.put(
        Uri.parse('${AppConstants.userEndpoint}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedUser = User.fromJson(data);
        userState.updateUser(updatedUser);
        userState.setLoading(false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        userState.setError(data['message'] ?? 'Profile update failed');
        userState.setLoading(false);
        return false;
      }
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
      return false;
    }
  }
  
  /// Reset password
  Future<bool> resetPassword(String email) async {
    userState.setLoading(true);
    
    try {
      // API call to reset password
      final response = await http.post(
        Uri.parse('${AppConstants.authEndpoint}/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        userState.setLoading(false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        userState.setError(data['message'] ?? 'Password reset failed');
        userState.setLoading(false);
        return false;
      }
    } catch (e) {
      userState.setError(e.toString());
      userState.setLoading(false);
      return false;
    }
  }
}