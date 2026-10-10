import 'achievement_model.dart';

class UserStats {
  final int totalAppointments;
  final int completedAppointments;
  final int totalPatients;
  final int connectionCount;
  final List<Achievement> achievements;
  final List<ProfessionalDevelopment> professionalDevelopments;
  final int totalCertifications;

  UserStats({
    this.totalAppointments = 0,
    this.completedAppointments = 0,
    this.totalPatients = 0,
    this.connectionCount = 0,
    this.achievements = const [],
    this.professionalDevelopments = const [],
    this.totalCertifications = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    List<Achievement> achievements = [];
    if (json['achievements'] != null) {
      achievements = List<Achievement>.from(
        json['achievements'].map((x) => Achievement.fromJson(x)),
      );
    }

    List<ProfessionalDevelopment> professionalDevelopments = [];
    if (json['professional_developments'] != null) {
      professionalDevelopments = List<ProfessionalDevelopment>.from(
        json['professional_developments'].map((x) => ProfessionalDevelopment.fromJson(x)),
      );
    }

    return UserStats(
      totalAppointments: json['total_appointments'] ?? 0,
      completedAppointments: json['completed_appointments'] ?? 0,
      totalPatients: json['total_patients'] ?? 0,
      connectionCount: json['connection_count'] ?? 0,
      achievements: achievements,
      professionalDevelopments: professionalDevelopments,
      totalCertifications: json['total_certifications'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_appointments': totalAppointments,
      'completed_appointments': completedAppointments,
      'total_patients': totalPatients,
      'connection_count': connectionCount,
      'achievements': achievements.map((x) => x.toJson()).toList(),
      'professional_developments': professionalDevelopments.map((x) => x.toJson()).toList(),
      'total_certifications': totalCertifications,
    };
  }
}

class ProfessionalDevelopment {
  final int id;
  final String title;
  final String type; // 'course', 'workshop', 'conference', 'certification'
  final DateTime completionDate;
  final String? certificateUrl;
  final String? provider;
  final int? creditHours;
  final String? description;

  const ProfessionalDevelopment({
    required this.id,
    required this.title,
    required this.type,
    required this.completionDate,
    this.certificateUrl,
    this.provider,
    this.creditHours,
    this.description,
  });

  factory ProfessionalDevelopment.fromJson(Map<String, dynamic> json) {
    return ProfessionalDevelopment(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      completionDate: DateTime.parse(json['completion_date']),
      certificateUrl: json['certificate_url'],
      provider: json['provider'],
      creditHours: json['credit_hours'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'type': type,
      'completion_date': completionDate.toIso8601String(),
    };
    
    if (certificateUrl != null) data['certificate_url'] = certificateUrl;
    if (provider != null) data['provider'] = provider;
    if (creditHours != null) data['credit_hours'] = creditHours;
    if (description != null) data['description'] = description;
    
    return data;
  }
}