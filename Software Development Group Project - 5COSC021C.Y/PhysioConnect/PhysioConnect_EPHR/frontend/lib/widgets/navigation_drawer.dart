// lib/widgets/navigation_drawer.dart
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class AppNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  
  const AppNavigationDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userState.currentUser;
    final isPatient = user?.isPatient ?? true;
    
    return Drawer(
      child: Column(
        children: [
          // Drawer header with user info
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.midnightTeal,
            ),
            accountName: Text(
              user?.fullName ?? 'User',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (user?.firstName?.isNotEmpty ?? false) 
                    ? user!.firstName[0].toUpperCase() 
                    : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.midnightTeal,
                ),
              ),
            ),
          ),
          
          // Navigation items for patients
          if (isPatient) ...[
            _buildNavItem(
              context,
              'Dashboard',
              Icons.dashboard,
              AppRoutes.patientDashboard,
            ),
            _buildNavItem(
              context,
              'Medical History',
              Icons.history,
              AppRoutes.medicalHistory,
            ),
            _buildNavItem(
              context,
              'Medications',
              Icons.medication,
              AppRoutes.medications,
            ),
            _buildNavItem(
              context,
              'Physiotherapy Records',
              Icons.fitness_center,
              AppRoutes.physioRecords,
            ),
            _buildNavItem(
              context,
              'Pain Tracker',
              Icons.healing,
              AppRoutes.painTracker,
            ),
            _buildNavItem(
              context,
              'Test Results',
              Icons.assessment,
              AppRoutes.testResults,
            ),
            _buildNavItem(
              context,
              'Appointments',
              Icons.calendar_today,
              AppRoutes.appointments,
            ),
            _buildNavItem(
              context,
              'Documents',
              Icons.description,
              AppRoutes.documents,
            ),
            _buildNavItem(
              context,
              'Emergency Information',
              Icons.emergency,
              AppRoutes.emergencyInfo,
            ),
          ]
          // Navigation items for physiotherapists
          else ...[
            _buildNavItem(
              context,
              'Patient List',
              Icons.people,
              AppRoutes.physioPatientList,
            ),
            _buildNavItem(
              context,
              'Document Upload',
              Icons.upload_file,
              AppRoutes.physioDocumentUpload,
            ),
            _buildNavItem(
              context,
              'Communication',
              Icons.message,
              AppRoutes.physioCommunication,
            ),
          ],
          
          const Divider(),
          
          // Common navigation items
          _buildNavItem(
            context,
            'Profile',
            Icons.person,
            AppRoutes.profile,
          ),
          _buildNavItem(
            context,
            'Settings',
            Icons.settings,
            AppRoutes.settings,
          ),
          
          const Spacer(),
          
          // Logout button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              // Close drawer
              Navigator.pop(context);
              
              // Show confirmation dialog
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
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
              
              // Logout if confirmed
              if (confirm == true) {
                await authService.logout();
                // Navigate to login
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    final isSelected = currentRoute == route;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.midnightTeal : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.midnightTeal : Colors.grey[900],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.aliceBlue.withOpacity(0.3),
      onTap: () {
        Navigator.pop(context); // Close drawer
        
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}