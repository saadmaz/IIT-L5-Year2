import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';
import '../../../widgets/ephr_card.dart';

/// Physiotherapy Records Screen
/// Displays history of physio sessions and prescribed exercises
/// Shows sessions by date, duration, and therapist

class PhysioRecordsScreen extends StatefulWidget {
  const PhysioRecordsScreen({Key? key}) : super(key: key);

  @override
  State<PhysioRecordsScreen> createState() => _PhysioRecordsScreenState();
}

class _PhysioRecordsScreenState extends State<PhysioRecordsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<Map<String, dynamic>> _physioSessions = [];
  List<Map<String, dynamic>> _prescribedExercises = [];
  String? _error;
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPhysioRecords();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  /// Load physiotherapy records from API
  Future<void> _loadPhysioRecords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      // In a real app, these would come from API calls
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock physio sessions
      _physioSessions = [
        {
          'id': '1',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'duration': 45,
          'therapistName': 'Dr. Sarah Johnson',
          'therapistId': 'th-001',
          'type': 'Initial Assessment',
          'notes': 'Patient presents with lower back pain. Conducted initial assessment and provided home exercises.',
          'progress': 'Baseline established. Pain level reported as 7/10.',
          'recommendations': 'Continue with prescribed exercises. Apply heat for 20 minutes twice daily.',
          'nextAppointment': DateTime.now().add(const Duration(days: 5)),
        },
        {
          'id': '2',
          'date': DateTime.now().subtract(const Duration(days: 9)),
          'duration': 30,
          'therapistName': 'Dr. Sarah Johnson',
          'therapistId': 'th-001',
          'type': 'Follow-up Session',
          'notes': 'Patient reports slight improvement. Pain reduced to 5/10. Range of motion slightly improved.',
          'progress': 'Improvement noted in flexibility and pain reduction.',
          'recommendations': 'Continue with exercises. Gradually increase repetitions as tolerated.',
          'nextAppointment': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': '3',
          'date': DateTime.now().subtract(const Duration(days: 16)),
          'duration': 60,
          'therapistName': 'Dr. Michael Chen',
          'therapistId': 'th-002',
          'type': 'Comprehensive Evaluation',
          'notes': 'Detailed evaluation of lower back pain. MRI results reviewed. Identified disc herniation at L4-L5.',
          'progress': 'Established baseline and treatment plan.',
          'recommendations': 'Start conservative treatment with physical therapy and exercises.',
          'nextAppointment': DateTime.now().subtract(const Duration(days: 9)),
        },
      ];
      
      // Mock prescribed exercises
      _prescribedExercises = [
        {
          'id': '1',
          'name': 'Pelvic Tilts',
          'description': 'Lie on your back with knees bent. Tighten your stomach muscles and flatten your back against the floor.',
          'repetitions': '10 reps, 3 sets',
          'frequency': 'Daily',
          'targetArea': 'Lower Back',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 2)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/pelvic-tilts',
          'isActive': true,
        },
        {
          'id': '2',
          'name': 'Cat-Cow Stretch',
          'description': 'Start on hands and knees. Alternate between arching and rounding your back.',
          'repetitions': '10 reps, 2 sets',
          'frequency': 'Daily',
          'targetArea': 'Lower Back, Core',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 2)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/cat-cow',
          'isActive': true,
        },
        {
          'id': '3',
          'name': 'Piriformis Stretch',
          'description': 'Lie on your back. Cross one leg over the other and pull the knee toward your chest.',
          'repetitions': 'Hold for 30 seconds, 3 reps each side',
          'frequency': 'Daily',
          'targetArea': 'Hip, Lower Back',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 9)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/piriformis-stretch',
          'isActive': true,
        },
        {
          'id': '4',
          'name': 'Standing Hamstring Stretch',
          'description': 'Place heel on a low stool. Keep leg straight and lean forward from the hips.',
          'repetitions': 'Hold for 30 seconds, 3 reps each side',
          'frequency': '3 times per week',
          'targetArea': 'Hamstrings',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 16)),
          'assignedBy': 'Dr. Michael Chen',
          'videoUrl': 'https://example.com/exercises/hamstring-stretch',
          'isActive': false,
        },
      ];
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading physio records: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Physiotherapy Records',
      ),
      drawer: NavigationDrawer(currentRoute: AppRoutes.physioRecords),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : _error != null
              ? _buildErrorView()
              : Column(
                  children: [
                    // Tab bar
                    TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.midnightTeal,
                      indicatorColor: AppTheme.midnightTeal,
                      tabs: const [
                        Tab(text: 'Sessions'),
                        Tab(text: 'Exercises'),
                      ],
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Sessions tab
                          _physioSessions.isEmpty
                              ? _buildEmptySessionsView()
                              : _buildSessionsList(),
                          
                          // Exercises tab
                          _prescribedExercises.isEmpty
                              ? _buildEmptyExercisesView()
                              : _buildExercisesList(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
  
  /// Build the error view
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $_error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPhysioRecords,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build empty sessions view
  Widget _buildEmptySessionsView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_gymnastics,
              color: Colors.grey[400],
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'No Physiotherapy Sessions Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your physiotherapy sessions will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.appointments);
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book a Session'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build empty exercises view
  Widget _buildEmptyExercisesView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              color: Colors.grey[400],
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'No Prescribed Exercises Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your prescribed exercises will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.appointments);
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book a Session'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build sessions list
  Widget _buildSessionsList() {
    return RefreshIndicator(
      onRefresh: _loadPhysioRecords,
      color: AppTheme.midnightTeal,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _physioSessions.length,
        itemBuilder: (context, index) {
          return _buildSessionCard(_physioSessions[index]);
        },
      ),
    );
  }
  
  /// Build a session card
  Widget _buildSessionCard(Map<String, dynamic> session) {
    final date = session['date'] as DateTime;
    final duration = session['duration'] as int;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: session['type'],
        subtitle: 'With ${session['therapistName']}',
        leading: CircleAvatar(
          backgroundColor: AppTheme.aliceBlue,
          child: const Icon(
            Icons.sports_gymnastics,
            color: AppTheme.midnightTeal,
            size: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session date and duration
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$duration minutes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Session notes preview
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notes,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    session['notes'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            // Next appointment if available
            if (session['nextAppointment'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.event,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Next appointment: ${_formatDate(session['nextAppointment'] as DateTime)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.midnightTeal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          // View details button
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.sessionDetail,
                arguments: session,
              );
            },
            child: const Text('View Details'),
          ),
        ],
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.sessionDetail,
            arguments: session,
          );
        },
      ),
    );
  }
  
  /// Build exercises list
  Widget _buildExercisesList() {
    // Split into active and inactive exercises
    final activeExercises = _prescribedExercises
        .where((exercise) => exercise['isActive'] == true)
        .toList();
    final inactiveExercises = _prescribedExercises
        .where((exercise) => exercise['isActive'] == false)
        .toList();
    
    return RefreshIndicator(
      onRefresh: _loadPhysioRecords,
      color: AppTheme.midnightTeal,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // View all exercises button
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.exercises);
                },
                icon: const Icon(Icons.fitness_center),
                label: const Text('View Exercise Library'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Active exercises
            if (activeExercises.isNotEmpty) ...[
              const Text(
                'Current Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...activeExercises.map((exercise) => _buildExerciseCard(exercise)),
              const SizedBox(height: 24),
            ],
            
            // Inactive exercises
            if (inactiveExercises.isNotEmpty) ...[
              const Text(
                'Previous Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...inactiveExercises.map((exercise) => _buildExerciseCard(exercise)),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build an exercise card
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to exercise detail
            // or show exercise detail dialog
            _showExerciseDetailDialog(exercise);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise name and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (exercise['isActive'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Target area
                Row(
                  children: [
                    const Icon(
                      Icons.accessibility_new,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Target: ${exercise['targetArea']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Repetitions
                Row(
                  children: [
                    const Icon(
                      Icons.repeat,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      exercise['repetitions'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Frequency
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      exercise['frequency'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description preview
                Text(
                  exercise['description'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Assigned info
                Row(
                  children: [
                    Text(
                      'Assigned by ${exercise['assignedBy']} on ${_formatDate(exercise['dateAssigned'] as DateTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // View button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _showExerciseDetailDialog(exercise);
                      },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Show exercise detail dialog
  void _showExerciseDetailDialog(Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(exercise['name']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: exercise['isActive']
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exercise['isActive'] ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: exercise['isActive'] ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Target area
                _buildDetailRow('Target Area:', exercise['targetArea']),
                const SizedBox(height: 8),
                
                // Repetitions
                _buildDetailRow('Repetitions:', exercise['repetitions']),
                const SizedBox(height: 8),
                
                // Frequency
                _buildDetailRow('Frequency:', exercise['frequency']),
                const SizedBox(height: 16),
                
                // Description
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(exercise['description']),
                const SizedBox(height: 16),
                
                // Assigned info
                _buildDetailRow(
                  'Assigned By:', 
                  exercise['assignedBy'],
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Date Assigned:', 
                  _formatDate(exercise['dateAssigned'] as DateTime),
                ),
                const SizedBox(height: 16),
                
                // Video link (would be a video player in a real app)
                if (exercise['videoUrl'] != null) ...[
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Launch video in a real app
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Video player not implemented'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Demo Video'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  /// Build a detail row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}