import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _notificationsEnabled = true;
  bool _appointmentReminders = true;
  bool _medicationReminders = true;
  bool _exerciseReminders = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';
  bool _useBiometrics = false;
  bool _highContrastMode = false;
  
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  final List<String> _themes = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications section
            _buildSection(
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                if (_notificationsEnabled) ...[
                  SwitchListTile(
                    title: const Text('Appointment Reminders'),
                    subtitle: const Text('Notifications about upcoming appointments'),
                    value: _appointmentReminders,
                    onChanged: (value) {
                      setState(() {
                        _appointmentReminders = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Medication Reminders'),
                    subtitle: const Text('Reminders to take medications'),
                    value: _medicationReminders,
                    onChanged: (value) {
                      setState(() {
                        _medicationReminders = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Exercise Reminders'),
                    subtitle: const Text('Reminders to complete prescribed exercises'),
                    value: _exerciseReminders,
                    onChanged: (value) {
                      setState(() {
                        _exerciseReminders = value;
                      });
                    },
                  ),
                ]
              ],
            ),
            const SizedBox(height: 16),
            
            // Display section
            _buildSection(
              title: 'Display',
              icon: Icons.color_lens_outlined,
              children: [
                ListTile(
                  title: const Text('Language'),
                  subtitle: Text(_selectedLanguage),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showLanguageSelector();
                  },
                ),
                ListTile(
                  title: const Text('Theme'),
                  subtitle: Text(_selectedTheme),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showThemeSelector();
                  },
                ),
                SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  subtitle: const Text('Improve visibility with increased contrast'),
                  value: _highContrastMode,
                  onChanged: (value) {
                    setState(() {
                      _highContrastMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Security section
            _buildSection(
              title: 'Security & Privacy',
              icon: Icons.security_outlined,
              children: [
                SwitchListTile(
                  title: const Text('Use Biometric Authentication'),
                  subtitle: const Text('Unlock app with fingerprint or face ID'),
                  value: _useBiometrics,
                  onChanged: (value) {
                    setState(() {
                      _useBiometrics = value;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change password not implemented')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Privacy Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings not implemented')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Data Sharing Preferences'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data sharing preferences not implemented')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // About section
            _buildSection(
              title: 'About',
              icon: Icons.info_outline,
              children: [
                ListTile(
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of service not implemented')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy policy not implemented')),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & support not implemented')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required String title, 
    required IconData icon, 
    required List<Widget> children
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.midnightTeal),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Section content
          ...children,
        ],
      ),
    );
  }
  
  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _languages.map((language) {
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _themes.map((theme) {
                return RadioListTile<String>(
                  title: Text(theme),
                  value: theme,
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}