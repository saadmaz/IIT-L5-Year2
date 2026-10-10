// File: lib/screens/settings_screen.dart
// Description: App settings screen
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/user_model.dart';

/// SettingsScreen allows users to configure app preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock settings data
  late UserSettings _settings;
  
  // App info
  final String _appVersion = '1.0.0';
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  /// Load mock settings data
  void _loadSettings() {
    _settings = UserSettings(
      notificationsEnabled: true,
      notificationTypes: ['Reminders', 'Progress updates', 'Tips'],
      darkModeEnabled: false,
      preferredLanguage: 'English',
      reminderIntervalMinutes: 60,
      hapticFeedbackEnabled: true,
      soundFeedbackEnabled: true,
      autoPostureCheckEnabled: true,
      shareActivityData: false,
      featureToggles: {
        'experimental_features': false,
        'data_sync': true,
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.midnightTeal,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingSection(
              'Notifications',
              [
                _buildSwitchTile(
                  title: 'Enable Notifications',
                  subtitle: 'Receive reminders and updates',
                  value: _settings.notificationsEnabled,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: value,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: _settings.darkModeEnabled,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                        soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                        autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                        shareActivityData: _settings.shareActivityData,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                if (_settings.notificationsEnabled) ...[
                  _buildSettingTile(
                    title: 'Reminder Frequency',
                    subtitle: _getReminderIntervalText(),
                    onTap: _showReminderIntervalDialog,
                  ),
                  ..._settings.notificationTypes.map((type) {
                    return _buildSwitchTile(
                      title: '$type Notifications',
                      subtitle: 'Receive notifications for $type',
                      value: true, // In a real app, this would be dynamic
                      onChanged: (value) {
                        // In a real app, you would update the specific notification type
                      },
                    );
                  }).toList(),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingSection(
              'Appearance',
              [
                _buildSwitchTile(
                  title: 'Dark Mode',
                  subtitle: 'Use dark color scheme',
                  value: _settings.darkModeEnabled,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: _settings.notificationsEnabled,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: value,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                        soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                        autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                        shareActivityData: _settings.shareActivityData,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSettingTile(
                  title: 'Language',
                  subtitle: _settings.preferredLanguage,
                  onTap: _showLanguageDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingSection(
              'Posture Detection',
              [
                _buildSwitchTile(
                  title: 'Auto Posture Check',
                  subtitle: 'Automatically check posture in background',
                  value: _settings.autoPostureCheckEnabled,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: _settings.notificationsEnabled,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: _settings.darkModeEnabled,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                        soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                        autoPostureCheckEnabled: value,
                        shareActivityData: _settings.shareActivityData,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSwitchTile(
                  title: 'Sound Feedback',
                  subtitle: 'Play sound alerts for posture issues',
                  value: _settings.soundFeedbackEnabled,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: _settings.notificationsEnabled,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: _settings.darkModeEnabled,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                        soundFeedbackEnabled: value,
                        autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                        shareActivityData: _settings.shareActivityData,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSwitchTile(
                  title: 'Haptic Feedback',
                  subtitle: 'Vibrate phone for posture issues',
                  value: _settings.hapticFeedbackEnabled,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: _settings.notificationsEnabled,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: _settings.darkModeEnabled,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: value,
                        soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                        autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                        shareActivityData: _settings.shareActivityData,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingSection(
              'Privacy',
              [
                _buildSwitchTile(
                  title: 'Share Activity Data',
                  subtitle: 'Anonymously share data to improve the app',
                  value: _settings.shareActivityData,
                  onChanged: (value) {
                    // Create a new settings object with the updated value
                    setState(() {
                      _settings = UserSettings(
                        notificationsEnabled: _settings.notificationsEnabled,
                        notificationTypes: _settings.notificationTypes,
                        darkModeEnabled: _settings.darkModeEnabled,
                        preferredLanguage: _settings.preferredLanguage,
                        reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                        hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                        soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                        autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                        shareActivityData: value,
                        featureToggles: _settings.featureToggles,
                      );
                    });
                    
                    // Show snackbar feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings updated'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSettingTile(
                  title: 'Clear App Data',
                  subtitle: 'Delete all local data and reset settings',
                  onTap: _showClearDataConfirmDialog,
                ),
                _buildSettingTile(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingSection(
              'About',
              [
                _buildSettingTile(
                  title: 'App Version',
                  subtitle: _appVersion,
                  onTap: null,
                ),
                _buildSettingTile(
                  title: 'Terms of Service',
                  subtitle: 'View our terms of service',
                  onTap: () {
                    // Navigate to terms of service
                  },
                ),
                _buildSettingTile(
                  title: 'Contact Support',
                  subtitle: 'Get help with the app',
                  onTap: () {
                    // Show contact dialog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a settings section with title and items
  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.midnightTeal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
  
  /// Build a switch setting tile
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.midnightTeal,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }
  
  /// Build a tappable setting tile
  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Function()? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: onTap != null ? const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ) : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }
  
  /// Show dialog to select reminder interval
  void _showReminderIntervalDialog() {
    final intervalOptions = [30, 60, 120, 240, 480];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reminder Frequency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: intervalOptions.length,
              itemBuilder: (context, index) {
                final interval = intervalOptions[index];
                return RadioListTile<int>(
                  title: Text(_getIntervalText(interval)),
                  value: interval,
                  groupValue: _settings.reminderIntervalMinutes,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    if (value != null) {
                      // Create a new settings object with the updated reminder interval
                      setState(() {
                        _settings = UserSettings(
                          notificationsEnabled: _settings.notificationsEnabled,
                          notificationTypes: _settings.notificationTypes,
                          darkModeEnabled: _settings.darkModeEnabled,
                          preferredLanguage: _settings.preferredLanguage,
                          reminderIntervalMinutes: value,
                          hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                          soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                          autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                          shareActivityData: _settings.shareActivityData,
                          featureToggles: _settings.featureToggles,
                        );
                      });
                      
                      // Show snackbar feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings updated'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  activeColor: AppColors.midnightTeal,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  /// Show dialog to select language
  void _showLanguageDialog() {
    final languageOptions = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageOptions.length,
              itemBuilder: (context, index) {
                final language = languageOptions[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _settings.preferredLanguage,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    if (value != null) {
                      // Create a new settings object with the updated language
                      setState(() {
                        _settings = UserSettings(
                          notificationsEnabled: _settings.notificationsEnabled,
                          notificationTypes: _settings.notificationTypes,
                          darkModeEnabled: _settings.darkModeEnabled,
                          preferredLanguage: value,
                          reminderIntervalMinutes: _settings.reminderIntervalMinutes,
                          hapticFeedbackEnabled: _settings.hapticFeedbackEnabled,
                          soundFeedbackEnabled: _settings.soundFeedbackEnabled,
                          autoPostureCheckEnabled: _settings.autoPostureCheckEnabled,
                          shareActivityData: _settings.shareActivityData,
                          featureToggles: _settings.featureToggles,
                        );
                      });
                      
                      // Show snackbar feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings updated'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  activeColor: AppColors.midnightTeal,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  /// Show confirmation dialog for clearing data
  void _showClearDataConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear App Data?'),
          content: const Text(
            'This will delete all your user data, reset your settings, '
            'and remove your progress history. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                // In a real app, clear data here
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data has been cleared'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Clear All Data'),
            ),
          ],
        );
      },
    );
  }
  
  /// Get formatted text for reminder interval
  String _getReminderIntervalText() {
    return _getIntervalText(_settings.reminderIntervalMinutes);
  }
  
  /// Format minutes into readable interval text
  String _getIntervalText(int minutes) {
    if (minutes < 60) {
      return 'Every $minutes minutes';
    } else if (minutes == 60) {
      return 'Every hour';
    } else {
      final hours = minutes ~/ 60;
      return 'Every $hours hours';
    }
  }
}