/// Pain Entry model for tracking patient pain levels and symptoms
/// Used for pain tracking and visualization

class PainEntry {
  final String id;
  final String patientId;
  final DateTime recordedAt;
  final int painLevel; // 0-10 scale
  final String bodyPart;
  final String? painType; // e.g., 'Acute', 'Chronic', 'Shooting', etc.
  final String? description;
  final List<String>? triggers;
  final String? medicationTaken;
  final String? treatmentApplied;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PainEntry({
    required this.id,
    required this.patientId,
    required this.recordedAt,
    required this.painLevel,
    required this.bodyPart,
    this.painType,
    this.description,
    this.triggers,
    this.medicationTaken,
    this.treatmentApplied,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Get severity category based on pain level
  String get severityCategory {
    if (painLevel <= 3) return 'Mild';
    if (painLevel <= 6) return 'Moderate';
    return 'Severe';
  }
  
  /// Factory constructor to create PainEntry from JSON
  factory PainEntry.fromJson(Map<String, dynamic> json) {
    return PainEntry(
      id: json['id'],
      patientId: json['patientId'],
      recordedAt: DateTime.parse(json['recordedAt']),
      painLevel: json['painLevel'],
      bodyPart: json['bodyPart'],
      painType: json['painType'],
      description: json['description'],
      triggers: json['triggers'] != null 
          ? List<String>.from(json['triggers'])
          : null,
      medicationTaken: json['medicationTaken'],
      treatmentApplied: json['treatmentApplied'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Convert PainEntry to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'recordedAt': recordedAt.toIso8601String(),
      'painLevel': painLevel,
      'bodyPart': bodyPart,
      'painType': painType,
      'description': description,
      'triggers': triggers,
      'medicationTaken': medicationTaken,
      'treatmentApplied': treatmentApplied,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create a copy of PainEntry with modified properties
  PainEntry copyWith({
    String? id,
    String? patientId,
    DateTime? recordedAt,
    int? painLevel,
    String? bodyPart,
    String? painType,
    String? description,
    List<String>? triggers,
    String? medicationTaken,
    String? treatmentApplied,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PainEntry(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      recordedAt: recordedAt ?? this.recordedAt,
      painLevel: painLevel ?? this.painLevel,
      bodyPart: bodyPart ?? this.bodyPart,
      painType: painType ?? this.painType,
      description: description ?? this.description,
      triggers: triggers ?? this.triggers,
      medicationTaken: medicationTaken ?? this.medicationTaken,
      treatmentApplied: treatmentApplied ?? this.treatmentApplied,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}