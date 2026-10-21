import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';  // Added import for FlSpot

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/appointment.dart';
import '../../../models/pain_entry.dart';
import '../../../widgets/app_bar.dart';
// import '../../../widgets/navigation_drawer.dart';
import '../../../widgets/chart_widgets.dart';
import 'widgets/metrics_card.dart';
import 'widgets/alerts_panel.dart';

/// Patient dashboard screen - main entry point for patient users
/// Displays overview of medical history, upcoming appointments, alerts, etc.

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  List<Appointment> _upcomingAppointments = [];
  List<PainEntry> _recentPainEntries = [];
  Map<String, dynamic> _metrics = {};
  List<Map<String, dynamic>> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  /// Load dashboard data from API
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      final userId = authService.userState.currentUser?.id ?? '';
      
      // Load appointments
      _upcomingAppointments = await ephrService.getAppointments(userId);
      // Filter to only upcoming appointments
      _upcomingAppointments = _upcomingAppointments
          .where((appointment) => !appointment.isPast)
          .toList();
      
      // Load pain entries
      _recentPainEntries = await ephrService.getPainEntries(userId);
      // Sort by date descending and take most recent
      _recentPainEntries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      if (_recentPainEntries.length > 10) {
        _recentPainEntries = _recentPainEntries.sublist(0, 10);
      }
      
      // For demo purposes, populate with mock data
      _metrics = {
        'lastBloodPressure': '120/80',
        'lastHeartRate': '72',
        'painAverage': _calculatePainAverage(),
        'medicationAdherence': '92%',
        'lastAppointment': _upcomingAppointments.isNotEmpty
            ? _upcomingAppointments.first.appointmentDate
            : null,
      };
      
      // Populate alerts
      _alerts = [
        {
          'type': 'appointment',
          'message': 'Upcoming appointment tomorrow at 2:00 PM',
          'severity': 'info',
          'date': DateTime.now().add(const Duration(days: 1)),
        },
        {
          'type': 'medication',
          'message': 'Remember to take your evening medication',
          'severity': 'warning',
          'date': DateTime.now(),
        },
        {
          'type': 'report',
          'message': 'New lab results available',
          'severity': 'info',
          'date': DateTime.now().subtract(const Duration(days: 1)),
        },
      ];
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  /// Calculate average pain from recent entries
  double _calculatePainAverage() {
    if (_recentPainEntries.isEmpty) return 0;
    
    final sum = _recentPainEntries.fold(
        0, (previous, entry) => previous + entry.painLevel);
    return sum / _recentPainEntries.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Dashboard',
        showBackButton: false,
      ),
      drawer: NavigationDrawer(
        children: [
          const NavigationDrawerDestination(
            icon: Icon(Icons.home),
            label: Text('Dashboard'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: AppTheme.midnightTeal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting section
                    _buildGreeting(),
                    const SizedBox(height: 24),
                    
                    // Alerts section
                    if (_alerts.isNotEmpty) ...[
                      const Text(
                        'Alerts & Reminders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AlertsPanel(alerts: _alerts),
                      const SizedBox(height: 24),
                    ],
                    
                    // Metrics section
                    const Text(
                      'Your Health at a Glance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMetricsGrid(),
                    const SizedBox(height: 24),
                    
                    // Pain trend chart
                    if (_recentPainEntries.isNotEmpty) ...[
                      const Text(
                        'Pain Trend',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPainTrendChart(),
                      const SizedBox(height: 24),
                    ],
                    
                    // Upcoming appointments
                    const Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAppointmentsList(),
                    const SizedBox(height: 24),
                    
                    // Quick access buttons
                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildQuickAccessButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
  
  /// Build greeting section with user name
  Widget _buildGreeting() {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userState.currentUser;
    final now = DateTime.now();
    String greeting;
    
    // Determine greeting based on time of day
    if (now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${user?.firstName ?? 'Patient'}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s your health summary for today',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  /// Build metrics grid
  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        MetricsCard(
          title: 'Blood Pressure',
          value: _metrics['lastBloodPressure'] ?? 'N/A',
          icon: Icons.favorite,
          color: Colors.redAccent,
          onTap: () {
            // Navigate to detailed view
          },
        ),
        MetricsCard(
          title: 'Heart Rate',
          value: '${_metrics['lastHeartRate'] ?? 'N/A'} bpm',
          icon: Icons.monitor_heart,
          color: Colors.orangeAccent,
          onTap: () {
            // Navigate to detailed view
          },
        ),
        MetricsCard(
          title: 'Avg. Pain Level',
          value: '${(_metrics['painAverage'] as double).toStringAsFixed(1)}/10',
          icon: Icons.healing,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.painTracker);
          },
        ),
        MetricsCard(
          title: 'Medication',
          value: _metrics['medicationAdherence'] ?? 'N/A',
          icon: Icons.medication,
          color: Colors.greenAccent,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.medications);
          },
        ),
      ],
    );
  }
  
  /// Build pain trend chart
  Widget _buildPainTrendChart() {
    // Convert pain entries to chart data points
    final spots = _recentPainEntries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.painLevel.toDouble());
    }).toList();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChartWidget(
          spots: spots,
          title: 'Pain Level Over Time',
          xAxisTitle: 'Days',
          yAxisTitle: 'Pain Level',
          minY: 0,
          maxY: 10,
          divisions: 5,
        ),
      ),
    );
  }
  
  /// Build upcoming appointments list
  Widget _buildAppointmentsList() {
    if (_upcomingAppointments.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.event_available,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No upcoming appointments',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.bookAppointment);
                  },
                  child: const Text('Book an Appointment'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _upcomingAppointments.length > 3 
            ? 3 
            : _upcomingAppointments.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final appointment = _upcomingAppointments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.aliceBlue,
              child: const Icon(
                Icons.event,
                color: AppTheme.midnightTeal,
              ),
            ),
            title: Text(
              'Appointment with ${appointment.therapistName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${_formatDate(appointment.appointmentDate)} at ${_formatTime(appointment.appointmentDate)}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context, 
                AppRoutes.appointmentDetail,
                arguments: appointment.toJson(),
              );
            },
          );
        },
      ),
    );
  }
  
  /// Build quick access buttons
  Widget _buildQuickAccessButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickAccessButton(
          icon: Icons.add_circle,
          label: 'Track Pain',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.addPainEntry);
          },
        ),
        _buildQuickAccessButton(
          icon: Icons.calendar_month,
          label: 'Book Appointment',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.bookAppointment);
          },
        ),
        _buildQuickAccessButton(
          icon: Icons.upload_file,
          label: 'Upload Document',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.uploadDocument);
          },
        ),
        _buildQuickAccessButton(
          icon: Icons.message,
          label: 'Message',
          onTap: () {
            // Navigate to messaging screen if implemented
          },
        ),
      ],
    );
  }
  
  /// Build a single quick access button
  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.aliceBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.midnightTeal,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Format time to display
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}