// TODO Implement this library.
class Achievement {
  final int id;
  final String title;
  final String description;
  final String iconUrl;
  final DateTime awardedDate;
  final AchievementType type;
  final int progress;
  final int goal;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.awardedDate,
    required this.type,
    required this.progress,
    required this.goal,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconUrl: json['icon_url'],
      awardedDate: DateTime.parse(json['awarded_date']),
      type: AchievementType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => AchievementType.other),
      progress: json['progress'] ?? 0,
      goal: json['goal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_url': iconUrl,
      'awarded_date': awardedDate.toIso8601String(),
      'type': type.toString().split('.').last,
      'progress': progress,
      'goal': goal,
    };
  }

  bool get isCompleted => progress >= goal;

  double get completionPercentage => (progress / goal) * 100;
}

enum AchievementType {
  appointment,
  certification,
  connection,
  learningHours,
  patientMilestone,
  specialization,
  activity,
  other
}