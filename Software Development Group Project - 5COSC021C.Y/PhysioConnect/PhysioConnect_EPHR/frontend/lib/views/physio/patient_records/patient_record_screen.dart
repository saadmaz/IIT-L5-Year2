import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/chart_widgets.dart';

class PatientRecordScreen extends StatefulWidget {
  final String patientId;
  
  const PatientRecordScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  State<PatientRecordScreen> createState() => _PatientRecordScreenState();
}

class _PatientRecordScreenState extends State<PatientRecordScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic>? _patientData;
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPatientData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
    });
    
    // In a real app, we would fetch data from API
    // For now, use mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock patient data
    _patientData = {
      'id': widget.patientId,
      'name': 'John Smith',
      'age': 42,
      'gender': 'Male',
      'email': 'john.smith@example.com',
      'phone': '(555) 123-4567',
      'condition': 'Lower Back Pain',
      'startDate': DateTime.now().subtract(const Duration(days: 90)),
      'bloodType': 'O+',
      'allergies': ['Penicillin', 'Peanuts'],
      'medications': ['Ibuprofen (as needed)'],
      'status': 'Active',
      'sessions': [
        {
          'id': '1',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'type': 'Regular Session',
          'notes': 'Patient reports less pain. Range of motion improving.',
          'painLevel': 5,
        },
        {
          'id': '2',
          'date': DateTime.now().subtract(const Duration(days: 9)),
          'type': 'Regular Session',
          'notes': 'Continuing exercises. Patient consistent with home program.',
          'painLevel': 6,
        },
        {
          'id': '3',
          'date': DateTime.now().subtract(const Duration(days: 16)),
          'type': 'Regular Session',
          'notes': 'Adjusted exercise routine to focus more on core strengthening.',
          'painLevel': 7,
        },
        {
          'id': '4',
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'type': 'Initial Assessment',
          'notes': 'Patient presents with lower back pain. Initial assessment completed.',
          'painLevel': 8,
        },
      ],
      'exercises': [
        {
          'id': '1',
          'name': 'Pelvic Tilts',
          'prescribed': DateTime.now().subtract(const Duration(days: 30)),
          'frequency': 'Daily',
          'adherence': 0.9,
        },
        {
          'id': '2',
          'name': 'Cat-Cow Stretch',
          'prescribed': DateTime.now().subtract(const Duration(days: 30)),
          'frequency': 'Daily',
          'adherence': 0.85,
        },
        {
          'id': '3',
          'name': 'Glute Bridges',
          'prescribed': DateTime.now().subtract(const Duration(days: 16)),
          'frequency': 'Daily',
          'adherence': 0.7,
        },
      ],
      'painEntries': [
        {'date': DateTime.now().subtract(const Duration(days: 2)), 'level': 5},
        {'date': DateTime.now().subtract(const Duration(days: 5)), 'level': 6},
        {'date': DateTime.now().subtract(const Duration(days: 10)), 'level': 6},
        {'date': DateTime.now().subtract(const Duration(days: 15)), 'level': 7},
        {'date': DateTime.now().subtract(const Duration(days: 20)), 'level': 7},
        {'date': DateTime.now().subtract(const Duration(days: 25)), 'level': 8},
        {'date': DateTime.now().subtract(const Duration(days: 30)), 'level': 8},
      ],
    };
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EPHRAppBar(
        title: _patientData != null ? _patientData!['name'] : 'Patient Record',
      ),
      floatingActionButton: _patientData != null ? FloatingActionButton(
        onPressed: () {
          _showAddSessionDialog();
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
      ) : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patientData == null
              ? const Center(child: Text('Patient not found'))
              : Column(
                  children: [
                    // Patient info card
                    _buildPatientInfoCard(),
                    
                    // Tabs
                    TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.midnightTeal,
                      indicatorColor: AppTheme.midnightTeal,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Sessions'),
                        Tab(text: 'Exercises'),
                        Tab(text: 'Documents'),
                      ],
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Overview tab
                          _buildOverviewTab(),
                          
                          // Sessions tab
                          _buildSessionsTab(),
                          
                          // Exercises tab
                          _buildExercisesTab(),
                          
                          // Documents tab
                          _buildDocumentsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
  
  /// Build patient info card
  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.aliceBlue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient avatar
          CircleAvatar(
            backgroundColor: AppTheme.midnightTeal,
            radius: 30,
            child: Text(
              _patientData!['name'].substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Patient details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patientData!['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${_patientData!['age']} years old • ${_patientData!['gender']}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.medical_information, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      _patientData!['condition'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Started: ${_formatDate(_patientData!['startDate'])}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contact buttons
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.phone),
                color: AppTheme.midnightTeal,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call feature not implemented')),
                  );
                },
                tooltip: 'Call',
              ),
              IconButton(
                icon: const Icon(Icons.message),
                color: AppTheme.midnightTeal,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message feature not implemented')),
                  );
                },
                tooltip: 'Message',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build overview tab
  Widget _buildOverviewTab() {
    // Convert pain entries to chart data
    final painSpots = _patientData!['painEntries'].asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['level'].toDouble());
    }).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pain trend chart
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pain Level Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LineChartWidget(
                    spots: painSpots,
                    title: '',
                    xAxisTitle: 'Time',
                    yAxisTitle: 'Pain Level',
                    minY: 0,
                    maxY: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Medical info
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoItem('Blood Type', _patientData!['bloodType']),
                  const Divider(),
                  
                  _buildInfoList('Allergies', _patientData!['allergies']),
                  const Divider(),
                  
                  _buildInfoList('Medications', _patientData!['medications']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Recent session
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Recent Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '${_patientData!['sessions'][0]['type']} - ${_formatDate(_patientData!['sessions'][0]['date'])}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_patientData!['sessions'][0]['notes']),
                  const SizedBox(height: 16),
                  
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        _tabController.animateTo(1); // Switch to Sessions tab
                      },
                      child: const Text('View All Sessions'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build sessions tab
  Widget _buildSessionsTab() {
    final sessions = _patientData!['sessions'];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session['type'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _formatDate(session['date']),
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pain: ${session['painLevel']}/10',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Session notes
                const Text(
                  'Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(session['notes']),
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit feature not implemented')),
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.description, size: 16),
                      label: const Text('Add Note'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add note feature not implemented')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build exercises tab
  Widget _buildExercisesTab() {
    final exercises = _patientData!['exercises'];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length + 1, // +1 for the add button
      itemBuilder: (context, index) {
        if (index == exercises.length) {
          // Add exercise button at the end
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Prescribe New Exercise'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prescribe exercise feature not implemented')),
                );
              },
            ),
          );
        }
        
        final exercise = exercises[index];
        final adherence = exercise['adherence'] as double;
        
        // Determine adherence color
        Color adherenceColor;
        if (adherence >= 0.9) {
          adherenceColor = Colors.green;
        } else if (adherence >= 0.7) {
          adherenceColor = Colors.orange;
        } else {
          adherenceColor = Colors.red;
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise name and adherence
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: adherenceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Adherence: ${(adherence * 100).toInt()}%',
                        style: TextStyle(
                          color: adherenceColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Exercise details
                Text(
                  'Prescribed: ${_formatDate(exercise['prescribed'])}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Frequency: ${exercise['frequency']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View details feature not implemented')),
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Modify'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Modify feature not implemented')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build documents tab
  Widget _buildDocumentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Documents Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Document'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload document feature not implemented')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  /// Build info item with label and value
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
  
  /// Build info list with label and list of values
  Widget _buildInfoList(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: values.isEmpty
                  ? [const Text('None')]
                  : values.map((value) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(value)),
                          ],
                        ),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Show add session dialog
  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Session'),
          content: const Text('This feature is not implemented in the demo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}