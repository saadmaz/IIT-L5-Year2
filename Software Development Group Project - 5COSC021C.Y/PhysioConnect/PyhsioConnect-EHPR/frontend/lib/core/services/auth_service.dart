// File: frontend/lib/core/services/auth_service.dart

import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Check authentication status
  Future<bool> checkAuthStatus() async {
    // In a real app, this would check if the user is logged in
    // For now, always return false
    _currentUser = null; // Ensure user is null when not authenticated
    return false;
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock a successful login
      _currentUser = User(
        id: 'user-123',
        name: 'Test User',
        email: email,
        role: 'therapist',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock a successful registration
      _currentUser = User(
        id: 'user-new',
        name: userData['name'] ?? 'New User',
        email: userData['email'] ?? 'user@example.com',
        role: userData['role'] ?? 'patient',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
