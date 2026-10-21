/// Medication model for tracking prescribed medications
/// Used for displaying and managing patient medications

class Medication {
  final String id;
  final String patientId;
  final String name;
  final String dosage;
  final String frequency;
  final String? instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final String prescribedBy;
  final String? prescriberId;
  final bool isActive;
  final List<String>? sideEffects;
  final List<String>? interactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
    required this.id,
    required this.patientId,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.instructions,
    required this.startDate,
    this.endDate,
    required this.prescribedBy,
    this.prescriberId,
    required this.isActive,
    this.sideEffects,
    this.interactions,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Check if medication is currently active
  bool get isCurrent {
    final now = DateTime.now();
    return isActive && (endDate == null || endDate!.isAfter(now));
  }
  
  /// Factory constructor to create Medication from JSON
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      patientId: json['patientId'],
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      instructions: json['instructions'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'])
          : null,
      prescribedBy: json['prescribedBy'],
      prescriberId: json['prescriberId'],
      isActive: json['isActive'],
      sideEffects: json['sideEffects'] != null 
          ? List<String>.from(json['sideEffects'])
          : null,
      interactions: json['interactions'] != null 
          ? List<String>.from(json['interactions'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Convert Medication to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'instructions': instructions,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'prescribedBy': prescribedBy,
      'prescriberId': prescriberId,
      'isActive': isActive,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create a copy of Medication with modified properties
  Medication copyWith({
    String? id,
    String? patientId,
    String? name,
    String? dosage,
    String? frequency,
    String? instructions,
    DateTime? startDate,
    DateTime? endDate,
    String? prescribedBy,
    String? prescriberId,
    bool? isActive,
    List<String>? sideEffects,
    List<String>? interactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      prescriberId: prescriberId ?? this.prescriberId,
      isActive: isActive ?? this.isActive,
      sideEffects: sideEffects ?? this.sideEffects,
      interactions: interactions ?? this.interactions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}