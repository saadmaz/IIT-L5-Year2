import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://your-api-url.com/api';
  
  // Regular email/password login
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to login');
      }
    } catch (e) {
      // For development purposes, return a mock token
      // Remove this in production
      await Future.delayed(const Duration(seconds: 1));
      return 'mock_token_for_development';
      
      // Uncomment this in production
      // rethrow;
    }
  }

  // Register with email/password
  Future<String> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to register');
      }
    } catch (e) {
      // For development purposes, return a mock token
      // Remove this in production
      await Future.delayed(const Duration(seconds: 1));
      return 'mock_token_for_development';
      
      // Uncomment this in production
      // rethrow;
    }
  }

  // Google OAuth login/signup
  Future<String> loginWithGoogle({bool isSignup = false}) async {
    try {
      // Implement Google Sign-In
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 1));
      return 'mock_google_token_for_development';
    } catch (e) {
      rethrow;
    }
  }

  // Apple OAuth login/signup
  Future<String> loginWithApple({bool isSignup = false}) async {
    try {
      // Implement Apple Sign-In
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 1));
      return 'mock_apple_token_for_development';
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        // Call logout API endpoint
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      
      // Clear local token
      await prefs.remove('auth_token');
    } catch (e) {
      // Just clear local token if API call fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null) {
      return false;
    }
    
    try {
      // Validate token with API
      final response = await http.get(
        Uri.parse('$baseUrl/auth/validate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      // For development, assume token is valid
      // Remove in production
      return true;
      
      // In production, return false on error
      // return false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      // For development, just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      // For development, just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment:
      // rethrow;
    }
  }
}