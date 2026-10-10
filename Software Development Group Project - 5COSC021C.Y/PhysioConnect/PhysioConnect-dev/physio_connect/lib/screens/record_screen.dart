// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';

/// Medical Records screen for viewing and managing patient records
class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  // Tab controller
  late TabController _tabController;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Filtering state
  String _searchQuery = '';

  // Dummy record data
  final List<Map<String, dynamic>> _records = [
    {
      'id': 'MR001',
      'patientId': '001',
      'patientName': 'John Smith',
      'date': '2023-10-15',
      'type': 'Consultation',
      'doctor': 'Dr. Sarah Johnson',
      'diagnosis': 'Hypertension',
      'notes':
          'Patient presented with elevated blood pressure. Prescribed medication and lifestyle changes.',
      'vitals': {
        'bp': '140/90 mmHg',
        'pulse': '78 bpm',
        'temp': '98.6°F',
        'weight': '185 lbs',
      },
    },
    {
      'id': 'MR002',
      'patientId': '002',
      'patientName': 'Emily Wilson',
      'date': '2023-10-14',
      'type': 'Lab Test',
      'doctor': 'Dr. Sarah Johnson',
      'diagnosis': 'Diabetes Type 2',
      'notes':
          'Blood test results show elevated glucose levels. Adjusting medication dosage.',
      'vitals': {
        'bp': '125/85 mmHg',
        'pulse': '72 bpm',
        'temp': '98.2°F',
        'weight': '142 lbs',
      },
    },
    {
      'id': 'MR003',
      'patientId': '003',
      'patientName': 'Michael Brown',
      'date': '2023-10-10',
      'type': 'Follow-up',
      'doctor': 'Dr. Sarah Johnson',
      'diagnosis': 'Asthma',
      'notes':
          'Patient reports improved breathing with current medication regimen.',
      'vitals': {
        'bp': '120/80 mmHg',
        'pulse': '68 bpm',
        'temp': '98.4°F',
        'weight': '175 lbs',
      },
    },
    {
      'id': 'MR004',
      'patientId': '004',
      'patientName': 'Jessica Martinez',
      'date': '2023-10-08',
      'type': 'Prenatal Checkup',
      'doctor': 'Dr. Sarah Johnson',
      'diagnosis': 'Pregnancy (2nd trimester)',
      'notes':
          'Routine prenatal checkup. Fetal heartbeat normal. Discussed nutrition guidelines.',
      'vitals': {
        'bp': '118/75 mmHg',
        'pulse': '75 bpm',
        'temp': '98.7°F',
        'weight': '145 lbs',
      },
    },
    {
      'id': 'MR005',
      'patientId': '005',
      'patientName': 'David Lee',
      'date': '2023-10-05',
      'type': 'Emergency',
      'doctor': 'Dr. Sarah Johnson',
      'diagnosis': 'Acute Chest Pain',
      'notes':
          'Patient admitted with severe chest pain. ECG performed. Monitoring for cardiac events.',
      'vitals': {
        'bp': '145/95 mmHg',
        'pulse': '92 bpm',
        'temp': '99.1°F',
        'weight': '190 lbs',
      },
    },
  ];

  // Prescription data
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'id': 'P001',
      'patientId': '001',
      'patientName': 'John Smith',
      'date': '2023-10-15',
      'doctor': 'Dr. Sarah Johnson',
      'medications': [
        {
          'name': 'Lisinopril',
          'dosage': '10mg',
          'frequency': 'Once daily',
          'duration': '30 days',
        },
        {
          'name': 'Aspirin',
          'dosage': '81mg',
          'frequency': 'Once daily',
          'duration': '30 days',
        },
      ],
      'notes': 'Take with food. Avoid alcohol.',
    },
    {
      'id': 'P002',
      'patientId': '002',
      'patientName': 'Emily Wilson',
      'date': '2023-10-14',
      'doctor': 'Dr. Sarah Johnson',
      'medications': [
        {
          'name': 'Metformin',
          'dosage': '500mg',
          'frequency': 'Twice daily',
          'duration': '90 days',
        },
        {
          'name': 'Glipizide',
          'dosage': '5mg',
          'frequency': 'Once daily',
          'duration': '90 days',
        },
      ],
      'notes': 'Take with meals. Monitor blood sugar regularly.',
    },
    {
      'id': 'P003',
      'patientId': '003',
      'patientName': 'Michael Brown',
      'date': '2023-10-10',
      'doctor': 'Dr. Sarah Johnson',
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
          'duration': '30 days',
        },
      ],
      'notes': 'Use inhaler before exercise if needed.',
    },
  ];

  // Labs data
  final List<Map<String, dynamic>> _labs = [
    {
      'id': 'L001',
      'patientId': '001',
      'patientName': 'John Smith',
      'date': '2023-10-14',
      'type': 'Blood Panel',
      'orderedBy': 'Dr. Sarah Johnson',
      'results': [
        {
          'test': 'Cholesterol (Total)',
          'value': '210',
          'unit': 'mg/dL',
          'range': '< 200',
          'flag': 'H',
        },
        {
          'test': 'HDL',
          'value': '45',
          'unit': 'mg/dL',
          'range': '> 40',
          'flag': null,
        },
        {
          'test': 'LDL',
          'value': '130',
          'unit': 'mg/dL',
          'range': '< 100',
          'flag': 'H',
        },
        {
          'test': 'Triglycerides',
          'value': '175',
          'unit': 'mg/dL',
          'range': '< 150',
          'flag': 'H',
        },
      ],
      'notes': 'Patient fasted for 12 hours before the test.',
    },
    {
      'id': 'L002',
      'patientId': '002',
      'patientName': 'Emily Wilson',
      'date': '2023-10-13',
      'type': 'Glucose Panel',
      'orderedBy': 'Dr. Sarah Johnson',
      'results': [
        {
          'test': 'Fasting Glucose',
          'value': '142',
          'unit': 'mg/dL',
          'range': '70-99',
          'flag': 'H',
        },
        {
          'test': 'HbA1c',
          'value': '7.2',
          'unit': '%',
          'range': '< 5.7',
          'flag': 'H',
        },
      ],
      'notes': 'Consistent with Type 2 Diabetes diagnosis.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter records based on search query
  List<Map<String, dynamic>> _getFilteredRecords() {
    if (_searchQuery.isEmpty) {
      return _records;
    }

    return _records.where((record) {
      return record['patientName'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          record['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          record['diagnosis'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  // Filter prescriptions based on search query
  List<Map<String, dynamic>> _getFilteredPrescriptions() {
    if (_searchQuery.isEmpty) {
      return _prescriptions;
    }

    return _prescriptions.where((prescription) {
      bool medicationMatches = false;

      for (var med in prescription['medications']) {
        if (med['name'].toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        )) {
          medicationMatches = true;
          break;
        }
      }

      return prescription['patientName'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          prescription['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          medicationMatches;
    }).toList();
  }

  // Filter labs based on search query
  List<Map<String, dynamic>> _getFilteredLabs() {
    if (_searchQuery.isEmpty) {
      return _labs;
    }

    return _labs.where((lab) {
      bool resultMatches = false;

      for (var result in lab['results']) {
        if (result['test'].toString().toLowerCase().contains(
          _searchQuery.toLowerCase(),
        )) {
          resultMatches = true;
          break;
        }
      }

      return lab['patientName'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          lab['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          lab['type'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          resultMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get filtered data
    final filteredRecords = _getFilteredRecords();
    final filteredPrescriptions = _getFilteredPrescriptions();
    final filteredLabs = _getFilteredLabs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.white,
          tabs: const [
            Tab(text: 'Records'),
            Tab(text: 'Prescriptions'),
            Tab(text: 'Lab Results'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search records, patients, or diagnoses...',
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

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Records tab
                _buildRecordsTab(filteredRecords),

                // Prescriptions tab
                _buildPrescriptionsTab(filteredPrescriptions),

                // Lab results tab
                _buildLabsTab(filteredLabs),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
        onPressed: () {
          // Show action menu based on current tab
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.note_add_outlined),
                    title: const Text('New Medical Record'),
                    onTap: () {
                      Navigator.pop(context);
                      // Would navigate to add record screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services_outlined),
                    title: const Text('New Prescription'),
                    onTap: () {
                      Navigator.pop(context);
                      // Would navigate to add prescription screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.science_outlined),
                    title: const Text('New Lab Order'),
                    onTap: () {
                      Navigator.pop(context);
                      // Would navigate to add lab order screen
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Records tab content
  Widget _buildRecordsTab(List<Map<String, dynamic>> records) {
    return records.isEmpty
        ? _buildEmptyState('No medical records found')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return _buildRecordCard(context, record);
          },
        );
  }

  // Prescriptions tab content
  Widget _buildPrescriptionsTab(List<Map<String, dynamic>> prescriptions) {
    return prescriptions.isEmpty
        ? _buildEmptyState('No prescriptions found')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return _buildPrescriptionCard(context, prescription);
          },
        );
  }

  // Labs tab content
  Widget _buildLabsTab(List<Map<String, dynamic>> labs) {
    return labs.isEmpty
        ? _buildEmptyState('No lab results found')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: labs.length,
          itemBuilder: (context, index) {
            final lab = labs[index];
            return _buildLabCard(context, lab);
          },
        );
  }

  // Empty state widget
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 80, color: AppTheme.textLight),
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
                : 'Add a new record to get started',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // Medical record card UI
  Widget _buildRecordCard(BuildContext context, Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Show record details
          _showRecordDetailsDialog(context, record);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with record ID and date
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
                      record['id'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    record['date'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    record['patientName'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.aliceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      record['type'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.midnightTeal,
                      ),
                    ),
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
                      'Diagnosis: ${record['diagnosis']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Doctor
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    record['doctor'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Preview of notes
              Text(
                'Notes: ${record['notes'].toString().substring(0, record['notes'].toString().length > 100 ? 100 : record['notes'].toString().length)}${record['notes'].toString().length > 100 ? '...' : ''}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Prescription card UI
  Widget _buildPrescriptionCard(
    BuildContext context,
    Map<String, dynamic> prescription,
  ) {
    final medications = prescription['medications'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Show prescription details
          _showPrescriptionDetailsDialog(context, prescription);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with prescription ID and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      prescription['id'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    prescription['date'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    prescription['patientName'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Medications
              for (var i = 0; i < medications.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.medication_outlined,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${medications[i]['name']} ${medications[i]['dosage']} - ${medications[i]['frequency']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),

              // Doctor
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    prescription['doctor'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              // Show notes if available
              if (prescription['notes'] != null &&
                  prescription['notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notes: ${prescription['notes']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Lab result card UI
  Widget _buildLabCard(BuildContext context, Map<String, dynamic> lab) {
    final results = lab['results'] as List;

    // Check if any results are flagged
    bool hasFlagged = results.any((result) => result['flag'] != null);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Show lab details
          _showLabDetailsDialog(context, lab);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with lab ID, type and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lab['id'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.aliceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lab['type'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.midnightTeal,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    lab['date'].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    lab['patientName'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (hasFlagged) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 12,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Abnormal Results',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Preview of results
              const Text(
                'Test Results:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),

              // Show first 2 results with indicators
              for (
                var i = 0;
                i < (results.length > 2 ? 2 : results.length);
                i++
              ) ...[
                if (i > 0) const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        results[i]['test'].toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${results[i]['value']} ${results[i]['unit']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              results[i]['flag'] != null
                                  ? Colors.red
                                  : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (results[i]['flag'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          results[i]['flag'],
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              // Show more indicator if needed
              if (results.length > 2) ...[
                const SizedBox(height: 8),
                const Text(
                  '... and more results',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Ordered by
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.midnightTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ordered by: ${lab['orderedBy']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to show medical record details
  void _showRecordDetailsDialog(
    BuildContext context,
    Map<String, dynamic> record,
  ) {
    final vitals = record['vitals'] as Map<String, dynamic>;

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
                child: const Icon(Icons.folder_outlined, color: AppTheme.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Medical Record',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    record['id'].toString(),
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
                  _buildDetailItem('Name', record['patientName'].toString()),
                  _buildDetailItem('ID', record['patientId'].toString()),
                ]),
                const Divider(),

                // Visit details section
                _buildDetailSection('Visit Details', [
                  _buildDetailItem('Date', record['date'].toString()),
                  _buildDetailItem('Type', record['type'].toString()),
                  _buildDetailItem('Doctor', record['doctor'].toString()),
                ]),
                const Divider(),

                // Diagnosis section
                _buildDetailSection('Diagnosis', [
                  _buildDetailItem('Diagnosis', record['diagnosis'].toString()),
                ]),
                const Divider(),

                // Vitals section
                _buildDetailSection('Vitals', [
                  _buildDetailItem('Blood Pressure', vitals['bp'].toString()),
                  _buildDetailItem('Pulse', vitals['pulse'].toString()),
                  _buildDetailItem('Temperature', vitals['temp'].toString()),
                  _buildDetailItem('Weight', vitals['weight'].toString()),
                ]),
                const Divider(),

                // Notes section
                _buildDetailSection('Notes', [
                  _buildDetailItem('', record['notes'].toString()),
                ]),
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
            CustomButton(
              text: 'Print',
              icon: Icons.print_outlined,
              onPressed: () {
                // Would handle printing
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Printing record...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
  }

  // Dialog to show prescription details
  void _showPrescriptionDetailsDialog(
    BuildContext context,
    Map<String, dynamic> prescription,
  ) {
    final medications = prescription['medications'] as List;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Prescription',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    prescription['id'].toString(),
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
                  _buildDetailItem(
                    'Name',
                    prescription['patientName'].toString(),
                  ),
                  _buildDetailItem('ID', prescription['patientId'].toString()),
                ]),
                const Divider(),

                // Prescription details section
                _buildDetailSection('Prescription Details', [
                  _buildDetailItem('Date', prescription['date'].toString()),
                  _buildDetailItem(
                    'Prescriber',
                    prescription['doctor'].toString(),
                  ),
                ]),
                const Divider(),

                // Medications section
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

                // Notes section if available
                if (prescription['notes'] != null &&
                    prescription['notes'].toString().isNotEmpty) ...[
                  const Divider(),
                  _buildDetailSection('Instructions', [
                    _buildDetailItem('', prescription['notes'].toString()),
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
            CustomButton(
              text: 'Print',
              icon: Icons.print_outlined,
              onPressed: () {
                // Would handle printing
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Printing prescription...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
  }

  // Dialog to show lab results details
  void _showLabDetailsDialog(BuildContext context, Map<String, dynamic> lab) {
    final results = lab['results'] as List;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.science_outlined,
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lab Results',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    lab['id'].toString(),
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
                  _buildDetailItem('Name', lab['patientName'].toString()),
                  _buildDetailItem('ID', lab['patientId'].toString()),
                ]),
                const Divider(),

                // Lab details section
                _buildDetailSection('Lab Details', [
                  _buildDetailItem('Date', lab['date'].toString()),
                  _buildDetailItem('Type', lab['type'].toString()),
                  _buildDetailItem('Ordered By', lab['orderedBy'].toString()),
                ]),
                const Divider(),

                // Results section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Results table header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.aliceBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Test',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Result',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Range',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),

                    // Results rows
                    for (var result in results) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.lightGrey,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(result['test'].toString()),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${result['value']} ${result['unit']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        result['flag'] != null
                                            ? Colors.red
                                            : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(result['range'].toString()),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child:
                                  result['flag'] != null
                                      ? Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            result['flag'],
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Notes section if available
                if (lab['notes'] != null &&
                    lab['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Notes', [
                    _buildDetailItem('', lab['notes'].toString()),
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
            CustomButton(
              text: 'Print',
              icon: Icons.print_outlined,
              onPressed: () {
                // Would handle printing
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Printing lab results...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
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
