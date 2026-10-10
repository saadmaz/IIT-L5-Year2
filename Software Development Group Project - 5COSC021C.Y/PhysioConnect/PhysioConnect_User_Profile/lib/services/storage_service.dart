import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class StorageService {
  final String baseUrl = 'https://your-api-url.com/api';

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/storage/upload/profile'),
      );
      
      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      
      // Get file extension
      final fileExtension = extension(imageFile.path).toLowerCase();
      final mimeType = _getMimeType(fileExtension);
      
      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
      
      // Send request
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = responseString;
        return result;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      // For development, return a mock URL
      await Future.delayed(const Duration(seconds: 1));
      return 'https://randomuser.me/api/portraits/women/44.jpg';
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Upload certificate or document
  Future<String> uploadDocument(File documentFile, String documentType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/storage/upload/document'),
      );
      
      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      
      // Add document type parameter
      request.fields['document_type'] = documentType;
      
      // Get file extension
      final fileExtension = extension(documentFile.path).toLowerCase();
      final mimeType = _getMimeType(fileExtension);
      
      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'document',
          documentFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
      
      // Send request
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = responseString;
        return result;
      } else {
        throw Exception('Failed to upload document: ${response.statusCode}');
      }
    } catch (e) {
      // For development, return a mock URL
      await Future.delayed(const Duration(seconds: 1));
      return 'https://example.com/documents/cert123.pdf';
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Delete file
  Future<void> deleteFile(String fileUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/storage/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: '{"file_url": "$fileUrl"}',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete file: ${response.statusCode}');
      }
    } catch (e) {
      // For development, just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Helper method to get MIME type from file extension
  String _getMimeType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }
}