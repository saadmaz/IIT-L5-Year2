// TODO Implement this library.
enum ThemeMode {
  light,
  dark,
  system
}

enum NotificationFrequency {
  all,
  important,
  none
}

class UserPreferences {
  final String userId;
  ThemeMode themeMode;
  bool emailNotifications;
  bool pushNotifications;
  bool smsNotifications;
  NotificationFrequency notificationFrequency;
  String language;
  String timezone;
  bool showOnlineStatus;
  bool showActivityStatus;
  bool twoFactorAuthEnabled;
  
  UserPreferences({
    required this.userId,
    this.themeMode = ThemeMode.light,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.notificationFrequency = NotificationFrequency.important,
    this.language = 'English',
    this.timezone = 'UTC',
    this.showOnlineStatus = true,
    this.showActivityStatus = true,
    this.twoFactorAuthEnabled = false,
  });
  
  // Create preferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'],
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${json['themeMode']}',
        orElse: () => ThemeMode.light,
      ),
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      notificationFrequency: NotificationFrequency.values.firstWhere(
        (e) => e.toString() == 'NotificationFrequency.${json['notificationFrequency']}',
        orElse: () => NotificationFrequency.important,
      ),
      language: json['language'] ?? 'English',
      timezone: json['timezone'] ?? 'UTC',
      showOnlineStatus: json['showOnlineStatus'] ?? true,
      showActivityStatus: json['showActivityStatus'] ?? true,
      twoFactorAuthEnabled: json['twoFactorAuthEnabled'] ?? false,
    );
  }
  
  // Convert preferences to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'themeMode': themeMode.toString().split('.').last,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'notificationFrequency': notificationFrequency.toString().split('.').last,
      'language': language,
      'timezone': timezone,
      'showOnlineStatus': showOnlineStatus,
      'showActivityStatus': showActivityStatus,
      'twoFactorAuthEnabled': twoFactorAuthEnabled,
    };
  }
}