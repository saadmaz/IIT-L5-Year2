// Description: Data models related to user information

/// User represents a user of the PhysioConnect app
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final DateTime dateJoined;
  final UserProfile profile;
  final UserSettings settings;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    required this.dateJoined,
    required this.profile,
    required this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],
      dateJoined: DateTime.parse(json['dateJoined']),
      profile: UserProfile.fromJson(json['profile']),
      settings: UserSettings.fromJson(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'dateJoined': dateJoined.toIso8601String(),
      'profile': profile.toJson(),
      'settings': settings.toJson(),
    };
  }

  // Get full name
  String get fullName => '$firstName $lastName';

  // Create a copy of this user with modified properties
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    DateTime? dateJoined,
    UserProfile? profile,
    UserSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateJoined: dateJoined ?? this.dateJoined,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
    );
  }
}

/// UserProfile contains extended user profile information
class UserProfile {
  final String? bio;
  final int? ageYears;
  final double? heightCm;
  final double? weightKg;
  final String? gender;
  final List<String> fitnessGoals;
  final List<String> postureIssues;
  final List<String> medicalConditions;
  final int experienceLevel; // 1-5
  final DateTime? lastPostureCheck;

  UserProfile({
    this.bio,
    this.ageYears,
    this.heightCm,
    this.weightKg,
    this.gender,
    required this.fitnessGoals,
    required this.postureIssues,
    required this.medicalConditions,
    required this.experienceLevel,
    this.lastPostureCheck,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      ageYears: json['ageYears'],
      heightCm: json['heightCm']?.toDouble(),
      weightKg: json['weightKg']?.toDouble(),
      gender: json['gender'],
      fitnessGoals: List<String>.from(json['fitnessGoals'] ?? []),
      postureIssues: List<String>.from(json['postureIssues'] ?? []),
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      experienceLevel: json['experienceLevel'] ?? 1,
      lastPostureCheck: json['lastPostureCheck'] != null
          ? DateTime.parse(json['lastPostureCheck'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'ageYears': ageYears,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'gender': gender,
      'fitnessGoals': fitnessGoals,
      'postureIssues': postureIssues,
      'medicalConditions': medicalConditions,
      'experienceLevel': experienceLevel,
      'lastPostureCheck': lastPostureCheck?.toIso8601String(),
    };
  }

  // Create a copy of this profile with modified properties
  UserProfile copyWith({
    String? bio,
    int? ageYears,
    double? heightCm,
    double? weightKg,
    String? gender,
    List<String>? fitnessGoals,
    List<String>? postureIssues,
    List<String>? medicalConditions,
    int? experienceLevel,
    DateTime? lastPostureCheck,
  }) {
    return UserProfile(
      bio: bio ?? this.bio,
      ageYears: ageYears ?? this.ageYears,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      postureIssues: postureIssues ?? this.postureIssues,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      lastPostureCheck: lastPostureCheck ?? this.lastPostureCheck,
    );
  }
}

/// UserSettings contains user preferences and settings
class UserSettings {
  final bool notificationsEnabled;
  final List<String> notificationTypes;
  final bool darkModeEnabled;
  final String preferredLanguage;
  final int reminderIntervalMinutes;
  final bool hapticFeedbackEnabled;
  final bool soundFeedbackEnabled;
  final bool autoPostureCheckEnabled;
  final bool shareActivityData;
  final Map<String, bool> featureToggles;

  UserSettings({
    required this.notificationsEnabled,
    required this.notificationTypes,
    required this.darkModeEnabled,
    required this.preferredLanguage,
    required this.reminderIntervalMinutes,
    required this.hapticFeedbackEnabled,
    required this.soundFeedbackEnabled,
    required this.autoPostureCheckEnabled,
    required this.shareActivityData,
    required this.featureToggles,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      notificationTypes: List<String>.from(json['notificationTypes'] ?? []),
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      reminderIntervalMinutes: json['reminderIntervalMinutes'] ?? 60,
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] ?? true,
      soundFeedbackEnabled: json['soundFeedbackEnabled'] ?? true,
      autoPostureCheckEnabled: json['autoPostureCheckEnabled'] ?? true,
      shareActivityData: json['shareActivityData'] ?? false,
      featureToggles: Map<String, bool>.from(json['featureToggles'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'notificationTypes': notificationTypes,
      'darkModeEnabled': darkModeEnabled,
      'preferredLanguage': preferredLanguage,
      'reminderIntervalMinutes': reminderIntervalMinutes,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'soundFeedbackEnabled': soundFeedbackEnabled,
      'autoPostureCheckEnabled': autoPostureCheckEnabled,
      'shareActivityData': shareActivityData,
      'featureToggles': featureToggles,
    };
  }

  // Create a copy of these settings with modified properties
  UserSettings copyWith({
    bool? notificationsEnabled,
    List<String>? notificationTypes,
    bool? darkModeEnabled,
    String? preferredLanguage,
    int? reminderIntervalMinutes,
    bool? hapticFeedbackEnabled,
    bool? soundFeedbackEnabled,
    bool? autoPostureCheckEnabled,
    bool? shareActivityData,
    Map<String, bool>? featureToggles,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTypes: notificationTypes ?? this.notificationTypes,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      reminderIntervalMinutes: reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundFeedbackEnabled: soundFeedbackEnabled ?? this.soundFeedbackEnabled,
      autoPostureCheckEnabled: autoPostureCheckEnabled ?? this.autoPostureCheckEnabled,
      shareActivityData: shareActivityData ?? this.shareActivityData,
      featureToggles: featureToggles ?? this.featureToggles,
    );
  }
}