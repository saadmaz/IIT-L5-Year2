import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/constants.dart';
import '../models/medical_record.dart';
import '../models/medication.dart';
import '../models/appointment.dart';
import '../models/pain_entry.dart';

/// Electronic Patient Health Record (EPHR) service
/// Handles data access for medical records, medications, appointments, etc.

class EPHRService {
  final String _baseUrl = AppConstants.ephrEndpoint;
  String? _authToken;
  
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
  
  // ------------ Medical Records ------------
  
  /// Get all medical records for a patient
  Future<List<MedicalRecord>> getMedicalRecords(String patientId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/medical-records'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => MedicalRecord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medical records');
      }
    } catch (e) {
      throw Exception('Error getting medical records: $e');
    }
  }
  
  /// Get a specific medical record
  Future<MedicalRecord> getMedicalRecord(String recordId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/medical-records/$recordId'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicalRecord.fromJson(data);
      } else {
        throw Exception('Failed to load medical record');
      }
    } catch (e) {
      throw Exception('Error getting medical record: $e');
    }
  }
  
  /// Create a new medical record
  Future<MedicalRecord> createMedicalRecord(Map<String, dynamic> recordData) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/medical-records'),
        headers: _buildHeaders(),
        body: jsonEncode(recordData),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return MedicalRecord.fromJson(data);
      } else {
        throw Exception('Failed to create medical record');
      }
    } catch (e) {
      throw Exception('Error creating medical record: $e');
    }
  }
  
  /// Update an existing medical record
  Future<MedicalRecord> updateMedicalRecord(String recordId, Map<String, dynamic> recordData) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/medical-records/$recordId'),
        headers: _buildHeaders(),
        body: jsonEncode(recordData),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicalRecord.fromJson(data);
      } else {
        throw Exception('Failed to update medical record');
      }
    } catch (e) {
      throw Exception('Error updating medical record: $e');
    }
  }
  
  // ------------ Medications ------------
  
  /// Get all medications for a patient
  Future<List<Medication>> getMedications(String patientId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/medications'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => Medication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medications');
      }
    } catch (e) {
      throw Exception('Error getting medications: $e');
    }
  }
  
  // Additional medication methods would be similar to medical records...
  
  // ------------ Appointments ------------
  
  /// Get all appointments for a patient
  Future<List<Appointment>> getAppointments(String patientId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/appointments'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Error getting appointments: $e');
    }
  }
  
  // Additional appointment methods would be similar...
  
  // ------------ Pain Entries ------------
  
  /// Get all pain entries for a patient
  Future<List<PainEntry>> getPainEntries(String patientId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/pain-entries'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => PainEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pain entries');
      }
    } catch (e) {
      throw Exception('Error getting pain entries: $e');
    }
  }
  
  // Additional pain entry methods would be similar...
  
  // ------------ For Physiotherapists ------------
  
  /// Get all patients assigned to a physiotherapist
  Future<List<dynamic>> getAssignedPatients(String therapistId) async {
    if (!_isAuthenticated()) throw Exception('Not authenticated');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/therapists/$therapistId/patients'),
        headers: _buildHeaders(),
      ).timeout(Duration(seconds: AppConstants.apiTimeoutSeconds));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        throw Exception('Failed to load assigned patients');
      }
    } catch (e) {
      throw Exception('Error getting assigned patients: $e');
    }
  }
}