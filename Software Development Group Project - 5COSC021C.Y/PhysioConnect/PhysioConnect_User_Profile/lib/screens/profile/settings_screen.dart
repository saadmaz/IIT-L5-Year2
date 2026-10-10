import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../../models/user_preferences.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final SharedPreferences prefs;
  
  const SettingsScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';
  bool _notificationsEnabled = true;
  
  bool _isLoading = false;
  String? _errorMessage;
  
  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'pt': 'Portuguese',
    'zh': 'Chinese',
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isDarkMode = widget.prefs.getBool('isDarkMode') ?? false;
      _selectedLanguage = widget.prefs.getString('language') ?? 'en';
      _notificationsEnabled = widget.prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _updatePreferences() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, dynamic> preferences = {
        'isDarkMode': _isDarkMode,
        'language': _selectedLanguage,
        'notificationsEnabled': _notificationsEnabled,
      };
      
      await _userService.updateUserPreferences(preferences);
      
      // Update local preferences as well
      await widget.prefs.setBool('isDarkMode', _isDarkMode);
      await widget.prefs.setString('language', _selectedLanguage);
      await widget.prefs.setBool('notificationsEnabled', _notificationsEnabled);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings updated successfully'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();
      
      if (!mounted) return;
      
      // Navigate to login screen and clear navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen(prefs: widget.prefs)),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _showConfirmationDialog(BuildContext context, String title, String content, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // App Theme
                _buildSectionHeader('App Theme'),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    _updatePreferences();
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                
                const Divider(),
                
                // Language
                _buildSectionHeader('Language'),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: const InputDecoration(
                        labelText: 'Select Language',
                        border: OutlineInputBorder(),
                      ),
                      items: _languages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                          _updatePreferences();
                        }
                      },
                    ),
                  ),
                ),
                
                const Divider(),
                
                // Notifications
                _buildSectionHeader('Notifications'),
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive important updates'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _updatePreferences();
                  },
                  activeColor: AppTheme.primaryColor,
                ),
                ListTile(
                  title: const Text('Notification Preferences'),
                  subtitle: const Text('Customize which notifications you receive'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to notification preferences screen
                  },
                ),
                
                const Divider(),
                
                // Security
                _buildSectionHeader('Security'),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  onTap: () {
                    // TODO: Navigate to change password screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Two-Factor Authentication'),
                  onTap: () {
                    // TODO: Navigate to 2FA setup screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Manage Connected Devices'),
                  onTap: () {
                    // TODO: Navigate to devices screen
                  },
                ),
                
                const Divider(),
                
                // Privacy
                _buildSectionHeader('Privacy'),
                ListTile(
                  leading: const Icon(Icons.visibility_outlined),
                  title: const Text('Privacy Settings'),
                  onTap: () {
                    // TODO: Navigate to privacy settings screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.data_usage),
                  title: const Text('Data Usage'),
                  onTap: () {
                    // TODO: Navigate to data usage screen
                  },
                ),
                
                const Divider(),
                
                // Account
                _buildSectionHeader('Account'),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download My Data'),
                  onTap: () {
                    // TODO: Implement data download
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    _showConfirmationDialog(
                      context,
                      'Delete Account',
                      'Are you sure you want to delete your account? This action cannot be undone.',
                      () {
                        // TODO: Implement account deletion
                      },
                    );
                  },
                ),
                
                const Divider(),
                
                // About
                _buildSectionHeader('About'),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About PhysioConnect'),
                  onTap: () {
                    // TODO: Navigate to about screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  onTap: () {
                    // TODO: Navigate to help screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  onTap: () {
                    // TODO: Navigate to terms screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    // TODO: Navigate to privacy policy screen
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Logout button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.darkGreen,
        ),
      ),
    );
  }
}