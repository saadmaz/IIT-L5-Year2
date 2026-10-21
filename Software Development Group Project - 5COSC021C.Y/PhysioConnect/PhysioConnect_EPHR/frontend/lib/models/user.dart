import 'package:flutter/foundation.dart'; // Add this import for ChangeNotifier

/// User model representing either a patient or physiotherapist
/// Used for authentication and profile management

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'patient' or 'physiotherapist'
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  // Patient-specific fields
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final List<String>? emergencyContacts;
  final String? primaryPhysioId;
  
  // Physiotherapist-specific fields
  final String? specialization;
  final String? licenseNumber;
  final String? clinic;
  final List<String>? assignedPatientIds;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.emergencyContacts,
    this.primaryPhysioId,
    this.specialization,
    this.licenseNumber,
    this.clinic,
    this.assignedPatientIds,
  });
  
  /// Full name getter for convenience
  String get fullName => '$firstName $lastName';
  
  /// Check if user is a patient
  bool get isPatient => role == 'patient';
  
  /// Check if user is a physiotherapist
  bool get isPhysiotherapist => role == 'physiotherapist';
  
  /// Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      emergencyContacts: json['emergencyContacts'] != null 
          ? List<String>.from(json['emergencyContacts'])
          : null,
      primaryPhysioId: json['primaryPhysioId'],
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      clinic: json['clinic'],
      assignedPatientIds: json['assignedPatientIds'] != null 
          ? List<String>.from(json['assignedPatientIds'])
          : null,
    );
  }
  
  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'emergencyContacts': emergencyContacts,
      'primaryPhysioId': primaryPhysioId,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'clinic': clinic,
      'assignedPatientIds': assignedPatientIds,
    };
  }
  
  /// Create a copy of User with modified properties
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    List<String>? emergencyContacts,
    String? primaryPhysioId,
    String? specialization,
    String? licenseNumber,
    String? clinic,
    List<String>? assignedPatientIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      primaryPhysioId: primaryPhysioId ?? this.primaryPhysioId,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      clinic: clinic ?? this.clinic,
      assignedPatientIds: assignedPatientIds ?? this.assignedPatientIds,
    );
  }
}

/// User state management class to be used with ChangeNotifier
class UserState extends ChangeNotifier {  // Changed from 'with' to 'extends'
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  
  void setUser(User user) {
    _currentUser = user;
    _error = null;
    notifyListeners();
  }
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void clearUser() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
  
  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}