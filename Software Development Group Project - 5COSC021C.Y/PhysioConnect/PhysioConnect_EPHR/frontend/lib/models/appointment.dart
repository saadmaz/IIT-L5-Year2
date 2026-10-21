/// Appointment model for tracking scheduled appointments
/// Used for displaying and managing patient appointments with physiotherapists

class Appointment {
  final String id;
  final String patientId;
  final String therapistId;
  final String therapistName;
  final DateTime appointmentDate;
  final int durationMinutes;
  final String? location;
  final String? virtualMeetingLink;
  final String status; // 'scheduled', 'completed', 'cancelled', 'missed'
  final String? notes;
  final String? reasonForVisit;
  final bool isFollowUp;
  final String? previousAppointmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.therapistName,
    required this.appointmentDate,
    required this.durationMinutes,
    this.location,
    this.virtualMeetingLink,
    required this.status,
    this.notes,
    this.reasonForVisit,
    required this.isFollowUp,
    this.previousAppointmentId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Check if appointment is virtual
  bool get isVirtual => virtualMeetingLink != null && virtualMeetingLink!.isNotEmpty;
  
  /// Check if appointment is in the past
  bool get isPast => appointmentDate.isBefore(DateTime.now());
  
  /// Calculate end time based on start time and duration
  DateTime get endTime => appointmentDate.add(Duration(minutes: durationMinutes));
  
  /// Factory constructor to create Appointment from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      therapistId: json['therapistId'],
      therapistName: json['therapistName'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      durationMinutes: json['durationMinutes'],
      location: json['location'],
      virtualMeetingLink: json['virtualMeetingLink'],
      status: json['status'],
      notes: json['notes'],
      reasonForVisit: json['reasonForVisit'],
      isFollowUp: json['isFollowUp'],
      previousAppointmentId: json['previousAppointmentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
  /// Convert Appointment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'therapistId': therapistId,
      'therapistName': therapistName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'durationMinutes': durationMinutes,
      'location': location,
      'virtualMeetingLink': virtualMeetingLink,
      'status': status,
      'notes': notes,
      'reasonForVisit': reasonForVisit,
      'isFollowUp': isFollowUp,
      'previousAppointmentId': previousAppointmentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  /// Create a copy of Appointment with modified properties
  Appointment copyWith({
    String? id,
    String? patientId,
    String? therapistId,
    String? therapistName,
    DateTime? appointmentDate,
    int? durationMinutes,
    String? location,
    String? virtualMeetingLink,
    String? status,
    String? notes,
    String? reasonForVisit,
    bool? isFollowUp,
    String? previousAppointmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      therapistId: therapistId ?? this.therapistId,
      therapistName: therapistName ?? this.therapistName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      virtualMeetingLink: virtualMeetingLink ?? this.virtualMeetingLink,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      isFollowUp: isFollowUp ?? this.isFollowUp,
      previousAppointmentId: previousAppointmentId ?? this.previousAppointmentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}