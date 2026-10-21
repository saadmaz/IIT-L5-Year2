import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/constants.dart';

/// Storage service for handling document and file operations
/// Manages uploading, downloading, and storing of medical documents and images

class StorageService {
  final String _baseUrl = AppConstants.documentsEndpoint;
  String? _authToken;
  late Directory _appDocumentsDirectory;
  late Directory _appCacheDirectory;
  
  /// Initialize the storage service
  Future<void> init() async {
    // Get app document and cache directories
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
    _appCacheDirectory = await getTemporaryDirectory();
  }
  
  /// Set the authentication token for API calls
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  /// Build headers with authentication token
  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_authToken',
    };
  }
  
  /// Check if service is authenticated
  bool _isAuthenticated() {
    return _authToken != null && _authToken!.isNotEmpty;
  }
  
  /// Upload a document to the server
  Future<String> uploadDocument(File file, String documentType, String ownerId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload'),
      );
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $_authToken';
      
      // Add file to request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split('/').last,
      ));
      
      // Add additional fields
      request.fields['documentType'] = documentType;
      request.fields['ownerId'] = ownerId;
      
      // Send the request
      final response = await request.send();
      
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return data['documentId'];
      } else {
        throw Exception('Failed to upload document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading document: $e');
    }
  }
  
  /// Download a document from the server
  Future<File> downloadDocument(String documentId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/download/$documentId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds * 2));
      
      if (response.statusCode == 200) {
        // Get file information from headers
        final disposition = response.headers['content-disposition'] ?? '';
        final filenameRegExp = RegExp(r'filename="(.*?)"');
        final match = filenameRegExp.firstMatch(disposition);
        final filename = match != null ? match.group(1) : 'document_$documentId';
        
        // Save the file to application documents directory
        final file = File('${_appDocumentsDirectory.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download document');
      }
    } catch (e) {
      throw Exception('Error downloading document: $e');
    }
  }
  
  /// Get document metadata
  Future<Map<String, dynamic>> getDocumentMetadata(String documentId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/metadata/$documentId'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get document metadata');
      }
    } catch (e) {
      throw Exception('Error getting document metadata: $e');
    }
  }
  
  /// Delete a document
  Future<bool> deleteDocument(String documentId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$documentId'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }
  
  /// Get list of documents for a patient
  Future<List<Map<String, dynamic>>> getDocumentsForPatient(String patientId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patient/$patientId'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to get patient documents');
      }
    } catch (e) {
      throw Exception('Error getting patient documents: $e');
    }
  }
  
  /// Clear cached files
  Future<void> clearCache() async {
    try {
      final cacheDir = _appCacheDirectory;
      if (await cacheDir.exists()) {
        final files = await cacheDir.list().toList();
        for (FileSystemEntity file in files) {
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      throw Exception('Error clearing cache: $e');
    }
  }
  
  /// Get temp file path for saving downloads
  String getTempFilePath(String filename) {
    return '${_appCacheDirectory.path}/$filename';
  }
  
  /// Get persistent file path for saving important files
  String getPersistentFilePath(String filename) {
    return '${_appDocumentsDirectory.path}/$filename';
  }
}