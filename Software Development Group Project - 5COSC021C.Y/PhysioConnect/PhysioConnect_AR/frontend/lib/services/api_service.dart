// File: lib/services/api_service.dart
// Description: Service for handling API requests
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../config/api_endpoints.dart';

/// ApiResponse is a wrapper for API responses
class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.error,
    required this.statusCode,
    required this.isSuccess,
  });
}

/// ApiService provides methods for interacting with the backend API
class ApiService {
  final http.Client _client;
  // Removed unused _baseUrl field - we'll use ApiEndpoints directly instead
  final Map<String, String> _defaultHeaders;
  String? _authToken;

  ApiService({http.Client? client})
      : _client = client ?? http.Client(),
        _defaultHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  /// Set the authentication token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear the authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// Get request headers with authentication if available
  Map<String, String> _getHeaders() {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  /// Process HTTP response
  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic json)? fromJson,
  ) {
    try {
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
      
      final jsonData = json.decode(response.body);
      
      if (isSuccess) {
        final data = fromJson != null ? fromJson(jsonData) : jsonData as T;
        return ApiResponse(
          data: data,
          error: null,
          statusCode: response.statusCode,
          isSuccess: true,
        );
      } else {
        final errorMsg = jsonData['message'] ?? 'Unknown error occurred';
        return ApiResponse(
          data: null,
          error: errorMsg,
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return ApiResponse(
        data: null,
        error: 'Failed to process response: ${e.toString()}',
        statusCode: response.statusCode,
        isSuccess: false,
      );
    }
  }

  /// Perform a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      // Ensure endpoint is a full URL by using the base URL if endpoint is a relative path
      final fullEndpoint = _getFullEndpoint(endpoint);
      final uri = Uri.parse(fullEndpoint).replace(
        queryParameters: queryParams,
      );

      final response = await _client
          .get(uri, headers: _getHeaders())
          .timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      // Network error (no internet)
      return ApiResponse(
        data: null,
        error: 'No Internet connection',
        statusCode: 0,
        isSuccess: false,
      );
    } on TimeoutException {
      // Timeout error
      return ApiResponse(
        data: null,
        error: 'Request timed out',
        statusCode: 0,
        isSuccess: false,
      );
    } catch (e) {
      // Any other error
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Perform a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      // Ensure endpoint is a full URL
      final fullEndpoint = _getFullEndpoint(endpoint);
      final uri = Uri.parse(fullEndpoint);
      final jsonBody = body != null ? json.encode(body) : null;

      final response = await _client
          .post(uri, headers: _getHeaders(), body: jsonBody)
          .timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      // Network error (no internet)
      return ApiResponse(
        data: null,
        error: 'No Internet connection',
        statusCode: 0,  // Fixed: using number 0 instead of letter o
        isSuccess: false,
      );
    } on TimeoutException {
      // Timeout error
      return ApiResponse(
        data: null,
        error: 'Request timed out',
        statusCode: 0,
        isSuccess: false,
      );
    } catch (e) {
      // Any other error
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }

  /// Perform a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      // Ensure endpoint is a full URL
      final fullEndpoint = _getFullEndpoint(endpoint);
      final uri = Uri.parse(fullEndpoint);
      final jsonBody = body != null ? json.encode(body) : null;

      final response = await _client
          .put(uri, headers: _getHeaders(), body: jsonBody)
          .timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      // Network error (no internet)
      return ApiResponse(
        data: null,
        error: 'No Internet connection',
        statusCode: 0,
        isSuccess: false,
      );
    } on TimeoutException {
      // Timeout error
      return ApiResponse(
        data: null,
        error: 'Request timed out',
        statusCode: 0,
        isSuccess: false,
      );
    } catch (e) {
      // Any other error
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }

  /// Perform a DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      // Ensure endpoint is a full URL
      final fullEndpoint = _getFullEndpoint(endpoint);
      final uri = Uri.parse(fullEndpoint);

      final response = await _client
          .delete(uri, headers: _getHeaders())
          .timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

      return _processResponse<T>(response, fromJson);
    } on SocketException {
      // Network error (no internet)
      return ApiResponse(
        data: null,
        error: 'No Internet connection',
        statusCode: 0,
        isSuccess: false,
      );
    } on TimeoutException {
      // Timeout error
      return ApiResponse(
        data: null,
        error: 'Request timed out',
        statusCode: 0,
        isSuccess: false,
      );
    } catch (e) {
      // Any other error
      return ApiResponse(
        data: null,
        error: e.toString(),
        statusCode: 0,
        isSuccess: false,
      );
    }
  }
  
  /// Helper to ensure endpoints are absolute URLs
  String _getFullEndpoint(String endpoint) {
    // If the endpoint already starts with http:// or https://, use it as is
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    
    // Otherwise, prepend the API base URL
    // Remove leading slash if present to avoid double slashes
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '${ApiEndpoints.baseUrl}/$cleanEndpoint';
  }
}