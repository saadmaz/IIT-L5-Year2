// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme.dart';
//import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';


/// Patient screen showing list of patients and patient details
class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Filtering state
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Recent', 'Critical', 'Stable'];

  // Dummy patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'id': '001',
      'name': 'John Smith',
      'age': 45,
      'gender': 'Male',
      'phone': '+1 555-123-4567',
      'condition': 'Hypertension',
      'status': 'Stable',
      'lastVisit': '3 days ago',
    },
    {
      'id': '002',
      'name': 'Emily Wilson',
      'age': 42,
      'gender': 'Female',
      'phone': '+1 555-987-6543',
      'condition': 'Diabetes Type 2',
      'status': 'Critical',
      'lastVisit': '1 day ago',
    },
    {
      'id': '003',
      'name': 'Michael Brown',
      'age': 35,
      'gender': 'Male',
      'phone': '+1 555-789-0123',
      'condition': 'Asthma',
      'status': 'Stable',
      'lastVisit': '2 weeks ago',
    },
    {
      'id': '004',
      'name': 'Jessica Martinez',
      'age': 28,
      'gender': 'Female',
      'phone': '+1 555-456-7890',
      'condition': 'Pregnancy',
      'status': 'Stable',
      'lastVisit': '1 week ago',
    },
    {
      'id': '005',
      'name': 'David Lee',
      'age': 67,
      'gender': 'Male',
      'phone': '+1 555-234-5678',
      'condition': 'Heart Disease',
      'status': 'Critical',
      'lastVisit': '5 days ago',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter patients based on search query and selected filter
  List<Map<String, dynamic>> _getFilteredPatients() {
    return _patients.where((patient) {
      // Apply search filter
      final nameMatches = patient['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Apply status filter
      final statusMatches =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'Critical' && patient['status'] == 'Critical') ||
          (_selectedFilter == 'Stable' && patient['status'] == 'Stable') ||
          (_selectedFilter == 'Recent' &&
              (patient['lastVisit'].contains('day') ||
                  patient['lastVisit'].contains('1 week')));

      return nameMatches && statusMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get filtered patients
    final filteredPatients = _getFilteredPatients();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Would show advanced filters dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.white,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search patients...',
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
                const SizedBox(height: 16),

                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: AppTheme.white,
                          // ignore: duplicate_ignore
                          // ignore: deprecated_member_use
                          selectedColor: AppTheme.midnightTeal.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color:
                                isSelected
                                    ? AppTheme.midnightTeal
                                    : AppTheme.textPrimary,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  isSelected
                                      ? AppTheme.midnightTeal
                                      : AppTheme.lightGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              '${filteredPatients.length} patients found',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Patient list
          Expanded(
            child:
                filteredPatients.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return _buildPatientCard(context, patient);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
        onPressed: () {
          // Would navigate to add patient screen
          _showAddPatientDialog(context);
        },
      ),
    );
  }

  // Empty state when no patients match the filter
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text(
            'No patients found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Add a new patient to get started',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // Patient card UI
  Widget _buildPatientCard(BuildContext context, Map<String, dynamic> patient) {
    final bool isCritical = patient['status'] == 'Critical';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Would navigate to patient details
          _showPatientDetailsDialog(context, patient);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient avatar
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    isCritical
                        ? Colors.red.withOpacity(0.2)
                        : AppTheme.aliceBlue,
                child: Text(
                  patient['name'].toString().substring(0, 1),
                  style: TextStyle(
                    color: isCritical ? Colors.red : AppTheme.midnightTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Patient info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patient['name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCritical
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            patient['status'].toString(),
                            style: TextStyle(
                              color: isCritical ? Colors.red : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          'ID: ${patient['id']}',
                          Icons.badge_outlined,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          '${patient['age']} yrs',
                          Icons.calendar_today_outlined,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          patient['gender'].toString(),
                          patient['gender'] == 'Male'
                              ? Icons.male
                              : Icons.female,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condition: ${patient['condition']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last visit: ${patient['lastVisit']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info chip UI for patient cards
  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.aliceBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.midnightTeal),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.midnightTeal),
          ),
        ],
      ),
    );
  }

  // Dialog to add a new patient
  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    final conditionController = TextEditingController();

    String gender = 'Male';
    String status = 'Stable';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Patient'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'Enter patient name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Age',
                      hint: 'Enter patient age',
                      controller: ageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Phone Number',
                      hint: 'Enter patient phone',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      label: 'Medical Condition',
                      hint: 'Enter primary condition',
                      controller: conditionController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gender',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Male',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                          activeColor: AppTheme.midnightTeal,
                        ),
                        const Text('Male'),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: 'Female',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                          activeColor: AppTheme.midnightTeal,
                        ),
                        const Text('Female'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Stable',
                          groupValue: status,
                          onChanged: (value) {
                            setState(() {
                              status = value!;
                            });
                          },
                          activeColor: AppTheme.midnightTeal,
                        ),
                        const Text('Stable'),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: 'Critical',
                          groupValue: status,
                          onChanged: (value) {
                            setState(() {
                              status = value!;
                            });
                          },
                          activeColor: AppTheme.midnightTeal,
                        ),
                        const Text('Critical'),
                      ],
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
                    // Validate and add patient
                    if (nameController.text.isNotEmpty &&
                        ageController.text.isNotEmpty) {
                      // Would normally save to backend
                      // For demo, just add to local list
                      setState(() {
                        _patients.add({
                          'id': '00${_patients.length + 1}',
                          'name': nameController.text,
                          'age': int.tryParse(ageController.text) ?? 0,
                          'gender': gender,
                          'phone': phoneController.text,
                          'condition': conditionController.text,
                          'status': status,
                          'lastVisit': 'Just now',
                        });
                      });

                      Navigator.pop(context);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Patient added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Show validation error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Add Patient'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Clean up controllers
      nameController.dispose();
      ageController.dispose();
      phoneController.dispose();
      conditionController.dispose();
    });
  }

  // Dialog to show patient details
  void _showPatientDetailsDialog(
    BuildContext context,
    Map<String, dynamic> patient,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.midnightTeal,
                child: Text(
                  patient['name'].toString().substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['name'].toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Patient ID: ${patient['id']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailItem('Age', '${patient['age']} years'),
                _buildDetailItem('Gender', patient['gender'].toString()),
                _buildDetailItem('Phone', patient['phone'].toString()),
                _buildDetailItem('Condition', patient['condition'].toString()),
                _buildDetailItem('Status', patient['status'].toString()),
                _buildDetailItem('Last Visit', patient['lastVisit'].toString()),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Would navigate to patient's medical record
                Navigator.pushNamed(context, '/records');
              },
              child: const Text('View Records'),
            ),
          ],
        );
      },
    );
  }

  // Helper for patient details dialog
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
