import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userState.currentUser;
    
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Profile',
        showProfileIcon: false,
      ),
      drawer: NavigationDrawer(currentRoute: AppRoutes.profile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header with avatar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile avatar
                    CircleAvatar(
                      backgroundColor: AppTheme.aliceBlue,
                      radius: 50,
                      child: user?.profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user!.profileImageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.person,
                                    color: AppTheme.midnightTeal,
                                    size: 50,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppTheme.midnightTeal,
                              size: 50,
                            ),
                    ),
                    const SizedBox(height: 16),
                    
                    // User name
                    Text(
                      user?.fullName ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // User email
                    Text(
                      user?.email ?? 'email@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Edit profile button
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit profile not implemented')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Personal information section
            _buildSection(
              title: 'Personal Information',
              icon: Icons.person,
              children: [
                _buildInfoRow('Date of Birth', user?.dateOfBirth ?? 'Not provided'),
                _buildInfoRow('Gender', user?.gender ?? 'Not provided'),
                _buildInfoRow('Phone', user?.phoneNumber ?? 'Not provided'),
                _buildInfoRow('Blood Group', user?.bloodGroup ?? 'Not provided'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Settings section
            _buildSection(
              title: 'Settings',
              icon: Icons.settings,
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('App Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Privacy & Security'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy settings not implemented')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notification Preferences'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification settings not implemented')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.handshake_outlined),
                  title: const Text('Consent & Permissions'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.consent);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Account section
            _buildSection(
              title: 'Account',
              icon: Icons.account_circle,
              children: [
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password change not implemented')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help not implemented')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await authService.logout();
                      // Navigate to login screen in a real app
                    }
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
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}