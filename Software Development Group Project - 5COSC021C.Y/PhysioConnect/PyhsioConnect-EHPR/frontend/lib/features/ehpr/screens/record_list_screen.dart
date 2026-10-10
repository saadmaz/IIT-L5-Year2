// File: frontend/lib/features/ehpr/screens/record_list_screen.dart

import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/models/medical_record_model.dart';
import '../widgets/record_card.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({Key? key}) : super(key: key);

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  bool isLoading = true;
  List<MedicalRecord> records = [];
  String _searchQuery = '';
  String _filterType = 'all';

  final List<Map<String, dynamic>> filterOptions = [
    {'label': 'All Records', 'value': 'all'},
    {'label': 'Assessments', 'value': 'assessment'},
    {'label': 'Treatment Plans', 'value': 'treatment'},
    {'label': 'Progress Notes', 'value': 'progress'},
    {'label': 'Documents', 'value': 'document'},
  ];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    // In a real app, you would fetch records from an API
    // For now, we'll use dummy data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        records = [
          MedicalRecord(
            id: '1',
            patientId: '101',
            therapistId: '201',
            dateCreated: DateTime.now().subtract(const Duration(days: 2)),
            dateModified: DateTime.now().subtract(const Duration(days: 2)),
            recordType: 'assessment',
            title: 'Initial Assessment',
            description: 'Lower back pain evaluation',
            data: {'painLevel': 7},
            therapistName: 'Dr. John Smith',
          ),
          MedicalRecord(
            id: '2',
            patientId: '102',
            therapistId: '201',
            dateCreated: DateTime.now().subtract(const Duration(days: 3)),
            dateModified: DateTime.now().subtract(const Duration(days: 3)),
            recordType: 'treatment',
            title: 'Treatment Plan',
            description: 'Neck pain rehabilitation program',
            data: {},
            therapistName: 'Dr. John Smith',
          ),
          MedicalRecord(
            id: '3',
            patientId: '103',
            therapistId: '201',
            dateCreated: DateTime.now().subtract(const Duration(days: 5)),
            dateModified: DateTime.now().subtract(const Duration(days: 4)),
            recordType: 'progress',
            title: 'Progress Note',
            description: 'Follow-up on knee rehabilitation',
            data: {},
            therapistName: 'Dr. John Smith',
          ),
        ];
        isLoading = false;
      });
    }
  }

  List<MedicalRecord> get filteredRecords {
    return records.where((record) {
      // Apply type filter
      if (_filterType != 'all' && record.recordType != _filterType) {
        return false;
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return record.title.toLowerCase().contains(query) ||
            record.description.toLowerCase().contains(query) ||
            record.patientId.toLowerCase().contains(query) ||
            (record.therapistName?.toLowerCase().contains(query) ?? false);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search records...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Active filters
          if (_filterType != 'all')
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium),
              child: Wrap(
                spacing: AppDimensions.paddingSmall,
                children: [
                  Chip(
                    label: Text(
                      filterOptions.firstWhere(
                          (opt) => opt['value'] == _filterType)['label'],
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _filterType = 'all';
                      });
                    },
                    backgroundColor: AppColors.aliceBlue,
                  ),
                ],
              ),
            ),

          // Records list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRecords.isEmpty
                    ? const Center(child: Text('No records found'))
                    : ListView.builder(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        itemCount: filteredRecords.length,
                        itemBuilder: (context, index) {
                          final record = filteredRecords[index];
                          return Card(
                            margin: const EdgeInsets.only(
                                bottom: AppDimensions.paddingMedium),
                            child: ListTile(
                              title: Text(
                                record.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(record.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Patient ID: ${record.patientId} | ${_formatDate(record.dateCreated)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              leading: _getLeadingIcon(record.recordType),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Navigate to record detail
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.recordDetail,
                                  arguments: record.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.midnightTeal,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createRecord);
        },
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Filter Records By',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                tileColor: AppColors.aliceBlue,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: filterOptions.map((option) {
                    final isSelected = _filterType == option['value'];
                    return ListTile(
                      title: Text(option['label']),
                      trailing: isSelected
                          ? const Icon(Icons.check,
                              color: AppColors.midnightTeal)
                          : null,
                      onTap: () {
                        setState(() {
                          _filterType = option['value'];
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getLeadingIcon(String recordType) {
    IconData iconData;
    Color iconColor;

    // Set icon based on record type
    switch (recordType) {
      case 'assessment':
        iconData = Icons.assignment;
        iconColor = Colors.blue;
        break;
      case 'treatment':
        iconData = Icons.healing;
        iconColor = Colors.green;
        break;
      case 'progress':
        iconData = Icons.trending_up;
        iconColor = Colors.orange;
        break;
      case 'document':
        iconData = Icons.description;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.folder;
        iconColor = AppColors.midnightTeal;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
