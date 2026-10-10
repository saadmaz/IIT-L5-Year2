// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';

/// Treatment Plans screen for creating and managing patient treatments
class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Filtering state
  String _searchQuery = '';

  // Tab controller
  int _currentTabIndex = 0;

  // Dummy treatment data
  final List<Map<String, dynamic>> _treatmentPlans = [
    {
      'id': 'TP001',
      'patientId': '001',
      'patientName': 'John Smith',
      'diagnosis': 'Hypertension',
      'createdDate': '2023-10-15',
      'status': 'Active',
      'creator': 'Dr. Sarah Johnson',
      'duration': '3 months',
      'medications': [
        {
          'name': 'Lisinopril',
          'dosage': '10mg',
          'frequency': 'Once daily',
          'duration': '3 months',
        },
        {
          'name': 'Hydrochlorothiazide',
          'dosage': '12.5mg',
          'frequency': 'Once daily',
          'duration': '3 months',
        },
      ],
      'procedures': [],
      'lifestyle': [
        'Low sodium diet',
        'Regular exercise (30 minutes, 5 days a week)',
        'Regular blood pressure monitoring',
      ],
      'goals': [
        'Maintain blood pressure below 130/80 mmHg',
        'Reduce sodium intake to less than 2300mg per day',
        'Achieve 5% weight loss in 3 months',
      ],
      'followUp': '4 weeks',
    },
    {
      'id': 'TP002',
      'patientId': '002',
      'patientName': 'Emily Wilson',
      'diagnosis': 'Diabetes Type 2',
      'createdDate': '2023-10-14',
      'status': 'Active',
      'creator': 'Dr. Sarah Johnson',
      'duration': '6 months',
      'medications': [
        {
          'name': 'Metformin',
          'dosage': '500mg',
          'frequency': 'Twice daily',
          'duration': '6 months',
        },
        {
          'name': 'Glipizide',
          'dosage': '5mg',
          'frequency': 'Once daily',
          'duration': '6 months',
        },
      ],
      'procedures': [],
      'lifestyle': [
        'Low carbohydrate diet',
        'Regular exercise (30 minutes daily)',
        'Daily blood sugar monitoring',
        'Foot care routine',
      ],
      'goals': [
        'Maintain HbA1c below 7.0%',
        'Fasting blood glucose below 130 mg/dL',
        'Weight loss of 10% over 6 months',
      ],
      'followUp': '3 months',
    },
    {
      'id': 'TP003',
      'patientId': '003',
      'patientName': 'Michael Brown',
      'diagnosis': 'Asthma',
      'createdDate': '2023-10-10',
      'status': 'Active',
      'creator': 'Dr. Sarah Johnson',
      'duration': 'Ongoing',
      'medications': [
        {
          'name': 'Albuterol',
          'dosage': '90mcg',
          'frequency': 'As needed',
          'duration': 'Ongoing',
        },
        {
          'name': 'Fluticasone',
          'dosage': '110mcg',
          'frequency': 'Twice daily',
          'duration': 'Ongoing',
        },
      ],
      'procedures': [],
      'lifestyle': [
        'Avoid known triggers',
        'Use air purifier at home',
        'Regular peak flow monitoring',
      ],
      'goals': [
        'Reduce rescue inhaler use to less than twice weekly',
        'Maintain normal activity levels without symptoms',
        'Zero emergency room visits for asthma',
      ],
      'followUp': '6 months',
    },
    {
      'id': 'TP004',
      'patientId': '005',
      'patientName': 'David Lee',
      'diagnosis': 'Heart Disease',
      'createdDate': '2023-10-05',
      'status': 'Active',
      'creator': 'Dr. Sarah Johnson',
      'duration': 'Ongoing',
      'medications': [
        {
          'name': 'Aspirin',
          'dosage': '81mg',
          'frequency': 'Once daily',
          'duration': 'Ongoing',
        },
        {
          'name': 'Atorvastatin',
          'dosage': '20mg',
          'frequency': 'Once daily',
          'duration': 'Ongoing',
        },
        {
          'name': 'Metoprolol',
          'dosage': '25mg',
          'frequency': 'Twice daily',
          'duration': 'Ongoing',
        },
      ],
      'procedures': [
        'Scheduled for cardiac stress test in 2 weeks',
        'Echocardiogram every 6 months',
      ],
      'lifestyle': [
        'Cardiac rehabilitation program',
        'Low fat, low salt diet',
        'Supervised exercise program',
        'Smoking cessation',
      ],
      'goals': [
        'Improve exercise tolerance',
        'Maintain blood pressure below 130/80 mmHg',
        'LDL cholesterol below 70 mg/dL',
      ],
      'followUp': '2 months',
    },
  ];

  // Completed treatments
  final List<Map<String, dynamic>> _completedTreatments = [
    {
      'id': 'TP005',
      'patientId': '004',
      'patientName': 'Jessica Martinez',
      'diagnosis': 'Acute Bronchitis',
      'createdDate': '2023-09-15',
      'completedDate': '2023-09-30',
      'status': 'Completed',
      'creator': 'Dr. Sarah Johnson',
      'duration': '14 days',
      'medications': [
        {
          'name': 'Amoxicillin',
          'dosage': '500mg',
          'frequency': 'Three times daily',
          'duration': '7 days',
        },
        {
          'name': 'Benzonatate',
          'dosage': '100mg',
          'frequency': 'Three times daily',
          'duration': '10 days',
        },
      ],
      'procedures': [],
      'lifestyle': [
        'Rest and hydration',
        'Humidifier at night',
        'Avoid irritants',
      ],
      'goals': ['Resolution of cough and fever', 'Return to normal activities'],
      'outcome': 'Successfully completed. Patient recovered completely.',
      'followUp': 'As needed',
    },
    {
      'id': 'TP006',
      'patientId': '001',
      'patientName': 'John Smith',
      'diagnosis': 'Sprained Ankle',
      'createdDate': '2023-08-20',
      'completedDate': '2023-09-20',
      'status': 'Completed',
      'creator': 'Dr. Sarah Johnson',
      'duration': '4 weeks',
      'medications': [
        {
          'name': 'Ibuprofen',
          'dosage': '600mg',
          'frequency': 'Three times daily',
          'duration': '10 days',
        },
      ],
      'procedures': ['Physical therapy 2x weekly for 4 weeks'],
      'lifestyle': [
        'RICE protocol (Rest, Ice, Compression, Elevation)',
        'Avoid weight bearing activities',
        'Use crutches as needed',
      ],
      'goals': [
        'Pain-free walking',
        'Return to normal activities',
        'Prevent re-injury',
      ],
      'outcome':
          'Full recovery achieved. Patient returned to normal activities.',
      'followUp': 'None required',
    },
  ];

  // Dummy patient data
  final List<Map<String, dynamic>> _patients = [
    {'id': '001', 'name': 'John Smith', 'age': 45, 'gender': 'Male'},
    {'id': '002', 'name': 'Emily Wilson', 'age': 42, 'gender': 'Female'},
    {'id': '003', 'name': 'Michael Brown', 'age': 35, 'gender': 'Male'},
    {'id': '004', 'name': 'Jessica Martinez', 'age': 28, 'gender': 'Female'},
    {'id': '005', 'name': 'David Lee', 'age': 67, 'gender': 'Male'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter active treatment plans
  List<Map<String, dynamic>> _getFilteredActiveTreatments() {
    if (_searchQuery.isEmpty) {
      return _treatmentPlans;
    }

    return _treatmentPlans.where((plan) {
      return plan['patientName'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          plan['diagnosis'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          plan['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  // Filter completed treatment plans
  List<Map<String, dynamic>> _getFilteredCompletedTreatments() {
    if (_searchQuery.isEmpty) {
      return _completedTreatments;
    }

    return _completedTreatments.where((plan) {
      return plan['patientName'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          plan['diagnosis'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          plan['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get filtered treatment plans
    final activeTreatments = _getFilteredActiveTreatments();
    final completedTreatments = _getFilteredCompletedTreatments();

    return Scaffold(
      appBar: AppBar(title: const Text('Treatment Plans')),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search treatment plans...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Active/Completed tabs
          Container(
            color: AppTheme.white,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentTabIndex = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                _currentTabIndex == 0
                                    ? AppTheme.midnightTeal
                                    : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Active (${activeTreatments.length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                              _currentTabIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              _currentTabIndex == 0
                                  ? AppTheme.midnightTeal
                                  : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentTabIndex = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                _currentTabIndex == 1
                                    ? AppTheme.midnightTeal
                                    : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Completed (${completedTreatments.length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                              _currentTabIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              _currentTabIndex == 1
                                  ? AppTheme.midnightTeal
                                  : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child:
                _currentTabIndex == 0
                    ? _buildActiveTreatmentsTab(activeTreatments)
                    : _buildCompletedTreatmentsTab(completedTreatments),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
        onPressed: () {
          // Would navigate to create treatment plan screen
          _showCreateTreatmentDialog(context);
        },
      ),
    );
  }

  // Active treatments tab content
  Widget _buildActiveTreatmentsTab(List<Map<String, dynamic>> treatments) {
    return treatments.isEmpty
        ? _buildEmptyState('No active treatment plans found')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: treatments.length,
          itemBuilder: (context, index) {
            final treatment = treatments[index];
            return _buildTreatmentCard(context, treatment);
          },
        );
  }

  // Completed treatments tab content
  Widget _buildCompletedTreatmentsTab(List<Map<String, dynamic>> treatments) {
    return treatments.isEmpty
        ? _buildEmptyState('No completed treatment plans found')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: treatments.length,
          itemBuilder: (context, index) {
            final treatment = treatments[index];
            return _buildTreatmentCard(context, treatment, isCompleted: true);
          },
        );
  }

  // Empty state widget
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.healing_outlined, size: 80, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search'
                : 'Create a new treatment plan to get started',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // Treatment plan card UI
  Widget _buildTreatmentCard(
    BuildContext context,
    Map<String, dynamic> treatment, {
    bool isCompleted = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Show treatment details
          _showTreatmentDetailsDialog(
            context,
            treatment,
            isCompleted: isCompleted,
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with plan ID and status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.midnightTeal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      treatment['id'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isCompleted
                              ? Colors.green.withOpacity(0.2)
                              : AppTheme.aliceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      treatment['status'].toString(),
                      style: TextStyle(
                        color:
                            isCompleted ? Colors.green : AppTheme.midnightTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Patient info
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    treatment['patientName'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Diagnosis
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.medical_information_outlined,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Diagnosis: ${treatment['diagnosis']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Created date and duration
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Created: ${treatment['createdDate']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.timelapse_outlined,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Duration: ${treatment['duration']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Medications preview
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.medication_outlined,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Medications: ${(treatment['medications'] as List).map((m) => m['name']).join(', ')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Follow-up info
              Row(
                children: [
                  const Icon(
                    Icons.event_outlined,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Follow-up: ${treatment['followUp']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              // Outcome for completed treatments
              if (isCompleted && treatment['outcome'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Outcome: ${treatment['outcome']}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to show treatment plan details
  void _showTreatmentDetailsDialog(
    BuildContext context,
    Map<String, dynamic> treatment, {
    bool isCompleted = false,
  }) {
    final medications = treatment['medications'] as List;
    final lifestyle = treatment['lifestyle'] as List;
    final goals = treatment['goals'] as List;
    final procedures = treatment['procedures'] as List;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.midnightTeal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.healing_outlined,
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Treatment Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    treatment['id'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient info section
                _buildDetailSection('Patient Information', [
                  _buildDetailItem('Name', treatment['patientName'].toString()),
                  _buildDetailItem('ID', treatment['patientId'].toString()),
                  _buildDetailItem(
                    'Diagnosis',
                    treatment['diagnosis'].toString(),
                  ),
                ]),
                const Divider(),

                // Plan details section
                _buildDetailSection('Plan Details', [
                  _buildDetailItem(
                    'Created on',
                    treatment['createdDate'].toString(),
                  ),
                  if (isCompleted && treatment['completedDate'] != null)
                    _buildDetailItem(
                      'Completed on',
                      treatment['completedDate'].toString(),
                    ),
                  _buildDetailItem('Status', treatment['status'].toString()),
                  _buildDetailItem(
                    'Duration',
                    treatment['duration'].toString(),
                  ),
                  _buildDetailItem('Creator', treatment['creator'].toString()),
                  _buildDetailItem(
                    'Follow-up',
                    treatment['followUp'].toString(),
                  ),
                ]),
                const Divider(),

                // Medications section
                if (medications.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Medications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var medication in medications) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.aliceBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medication['name'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDetailItem(
                                'Dosage',
                                medication['dosage'].toString(),
                              ),
                              _buildDetailItem(
                                'Frequency',
                                medication['frequency'].toString(),
                              ),
                              _buildDetailItem(
                                'Duration',
                                medication['duration'].toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(),
                ],

                // Procedures section
                if (procedures.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Procedures',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var procedure in procedures) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.medical_services_outlined,
                                size: 16,
                                color: AppTheme.midnightTeal,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(procedure.toString())),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(),
                ],

                // Lifestyle section
                if (lifestyle.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lifestyle Recommendations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var item in lifestyle) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: AppTheme.midnightTeal,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item.toString())),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(),
                ],

                // Goals section
                if (goals.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Treatment Goals',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var goal in goals) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.flag_outlined,
                                size: 16,
                                color: AppTheme.midnightTeal,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(goal.toString())),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Outcome for completed treatments
                if (isCompleted && treatment['outcome'] != null) ...[
                  const Divider(),
                  _buildDetailSection('Outcome', [
                    _buildDetailItem('', treatment['outcome'].toString()),
                  ]),
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
            if (!isCompleted) ...[
              CustomButton(
                text: 'Complete',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  // Would mark treatment as complete
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treatment marked as completed'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                isFullWidth: false,
              ),
            ] else ...[
              CustomButton(
                text: 'Print',
                icon: Icons.print_outlined,
                onPressed: () {
                  // Would handle printing
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Printing treatment plan...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                isFullWidth: false,
              ),
            ],
          ],
        );
      },
    );
  }

  // Dialog to create a new treatment plan
  void _showCreateTreatmentDialog(BuildContext context) {
    // For simplicity, just show a basic dialog
    // In a real app, this would be a more comprehensive form

    String? selectedPatientId;
    final diagnosisController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Treatment Plan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient selection
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Patient',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      value: selectedPatientId,
                      hint: const Text('Select patient'),
                      items:
                          _patients.map((patient) {
                            return DropdownMenuItem<String>(
                              value: patient['id'].toString(),
                              child: Text(
                                '${patient['name']} (${patient['age']} yrs, ${patient['gender']})',
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPatientId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Diagnosis
                    TextFormField(
                      controller: diagnosisController,
                      decoration: InputDecoration(
                        labelText: 'Diagnosis',
                        hintText: 'Enter primary diagnosis',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Duration
                    TextFormField(
                      controller: durationController,
                      decoration: InputDecoration(
                        labelText: 'Duration',
                        hintText: 'e.g., 3 months, Ongoing',
                      ),
                    ),
                  
                    // Note about complete form
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.aliceBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.midnightTeal,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You\'ll be able to add medications, procedures, and other details in the next step.',
                              style: TextStyle(color: AppTheme.midnightTeal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate and create plan
                    if (selectedPatientId != null &&
                        diagnosisController.text.isNotEmpty &&
                        durationController.text.isNotEmpty) {
                      // Would normally navigate to a detailed form
                      // For demo, just show success message

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Treatment plan created successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Show validation error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Create Plan'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Clean up controllers
      diagnosisController.dispose();
      durationController.dispose();
    });
  }

  // Helper for detail sections in dialogs
  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }

  // Helper for detail items in dialogs
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child:
          label.isEmpty
              ? Text(value)
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      label,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  Expanded(child: Text(value)),
                ],
              ),
    );
  }
}

class CustomTextField {
}
