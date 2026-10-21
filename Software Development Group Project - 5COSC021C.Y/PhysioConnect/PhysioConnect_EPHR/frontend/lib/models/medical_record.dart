/// Medical Record model for tracking medical history entries
/// Used for displaying and managing patient medical history

class MedicalRecord {
  final String id;
  final String patientId;
  final String condition;
  final String description;
  final DateTime diagnosisDate;
  final String? diagnosisBy;
  final String? treatmentPlan;
  final String? notes;
  final List<String>? documentIds;
  final bool isResolved;
  final DateTime? resolvedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.condition,
    required this.description,
    required this.diagnosisDate,
    this.diagnosisBy,
    this.treatmentPlan,
    this.notes,
    this.documentIds,
    required this.isResolved,
    this.resolvedDate,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Factory constructor to create MedicalRecord from JSON
  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      patientId: json['patientId'],
      condition: json['condition'],
      description: json['description'],
      diagnosisDate: DateTime.parse(json['diagnosisDate']),
      diagnosisBy: json['diagnosisBy'],
      treatmentPlan: json['treatmentPlan'],
      notes: json['notes'],
      documentIds: json['documentIds'] != null 
          ? List<String>.from(json['documentIds'])
          : null,
      isResolved: json['isResolved'],
      resolvedDate: json['resolvedDate'] != null 
          ? DateTime.parse(json['resolvedDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Convert MedicalRecord to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'condition': condition,
      'description': description,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'diagnosisBy': diagnosisBy,
      'treatmentPlan': treatmentPlan,
      'notes': notes,
      'documentIds': documentIds,
      'isResolved': isResolved,
      'resolvedDate': resolvedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create a copy of MedicalRecord with modified properties
  MedicalRecord copyWith({
    String? id,
    String? patientId,
    String? condition,
    String? description,
    DateTime? diagnosisDate,
    String? diagnosisBy,
    String? treatmentPlan,
    String? notes,
    List<String>? documentIds,
    bool? isResolved,
    DateTime? resolvedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      diagnosisBy: diagnosisBy ?? this.diagnosisBy,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      notes: notes ?? this.notes,
      documentIds: documentIds ?? this.documentIds,
      isResolved: isResolved ?? this.isResolved,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}