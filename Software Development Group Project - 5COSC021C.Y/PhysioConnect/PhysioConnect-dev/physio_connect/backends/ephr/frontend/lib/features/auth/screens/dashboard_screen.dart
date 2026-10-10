// File: frontend/lib/features/ehpr/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
//import '../widgets/dashboard_stats.dart';
//import '../widgets/recent_records_list.dart';
import '../../../core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:physioconnect/features/ehpr/widgets/dashboard_stats.dart';
import 'package:physioconnect/features/ehpr/widgets/recent_records_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // In a real app, you would load actual data here
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EHPR Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, user?.name ?? 'User'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboardContent(context, user?.name ?? 'User'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.midnightTeal,
        child: const Icon(Icons.add),
        onPressed: () {
          // Show actions for adding new content
          _showAddOptions(context);
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, String userName) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome, $userName',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'Your health records dashboard',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Quick actions
            const Text(
              'Quick Actions',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            _buildQuickActions(),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Statistics
            const Text(
              'Overview',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const DashboardStats(),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Recent records
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Records',
                  style: AppTextStyles.heading2,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.recordList);
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const RecentRecordsList(),
            const SizedBox(height: AppDimensions.paddingMedium),

            // Upcoming appointments (placeholder for integration)
            const Text(
              'Upcoming Appointments',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: AppColors.midnightTeal),
                        SizedBox(width: 8),
                        Text(
                          'Integration Point',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will show appointments from the appointments module',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // This would navigate to the appointments module
                        },
                        child: const Text('View Appointments'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: AppDimensions.paddingMedium,
      runSpacing: AppDimensions.paddingMedium,
      children: [
        _actionButton(
          context,
          icon: Icons.person_add,
          label: 'New Patient',
          onTap: () {
            // Navigate to new patient form
          },
        ),
        _actionButton(
          context,
          icon: Icons.description,
          label: 'New Record',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.createRecord);
          },
        ),
        _actionButton(
          context,
          icon: Icons.assessment,
          label: 'Assessment',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.assessment);
          },
        ),
        _actionButton(
          context,
          icon: Icons.healing,
          label: 'Treatment Plan',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.treatmentPlan);
          },
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        decoration: BoxDecoration(
          color: AppColors.aliceBlue,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(color: AppColors.midnightTeal.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.midnightTeal, size: 32),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.midnightTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String userName) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.midnightTeal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    color: AppColors.midnightTeal,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  userName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Physiotherapist',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Patients'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to patients list
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Medical Records'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.recordList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Assessments'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to assessments list
            },
          ),
          ListTile(
            leading: const Icon(Icons.healing),
            title: const Text('Treatment Plans'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to treatment plans list
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Logout
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              authService.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.person_add, color: AppColors.midnightTeal),
                title: const Text('Add New Patient'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to new patient form
                },
              ),
              ListTile(
                leading: const Icon(Icons.description,
                    color: AppColors.midnightTeal),
                title: const Text('Create Medical Record'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.createRecord);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.assessment, color: AppColors.midnightTeal),
                title: const Text('New Assessment'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.assessment);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.healing, color: AppColors.midnightTeal),
                title: const Text('Create Treatment Plan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.treatmentPlan);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
