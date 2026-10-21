import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navigation_drawer.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  
  // Mock patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'id': '1',
      'name': 'John Smith',
      'age': 42,
      'condition': 'Lower Back Pain',
      'lastVisit': DateTime.now().subtract(const Duration(days: 7)),
      'nextVisit': DateTime.now().add(const Duration(days: 7)),
      'profilePic': null,
      'status': 'Active',
      'adherence': 0.85,
    },
    {
      'id': '2',
      'name': 'Emily Johnson',
      'age': 35,
      'condition': 'Shoulder Rehabilitation',
      'lastVisit': DateTime.now().subtract(const Duration(days: 14)),
      'nextVisit': DateTime.now().add(const Duration(days: 2)),
      'profilePic': null,
      'status': 'Active',
      'adherence': 0.95,
    },
    {
      'id': '3',
      'name': 'Michael Chen',
      'age': 68,
      'condition': 'Knee Replacement Recovery',
      'lastVisit': DateTime.now().subtract(const Duration(days: 3)),
      'nextVisit': DateTime.now().add(const Duration(days: 11)),
      'profilePic': null,
      'status': 'Active',
      'adherence': 0.75,
    },
    {
      'id': '4',
      'name': 'Sarah Wilson',
      'age': 29,
      'condition': 'Ankle Sprain',
      'lastVisit': DateTime.now().subtract(const Duration(days: 21)),
      'nextVisit': null,
      'profilePic': null,
      'status': 'Inactive',
      'adherence': 0.60,
    },
  ];
  
  List<Map<String, dynamic>> _getFilteredPatients() {
    if (_searchQuery.isEmpty) return _patients;
    
    return _patients.where((patient) {
      final name = patient['name'].toString().toLowerCase();
      final condition = patient['condition'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) || 
             condition.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPatients = _getFilteredPatients();
    
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Patient List'),
      drawer: NavigationDrawer(currentRoute: AppRoutes.physioPatientList),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search patients...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppTheme.aliceBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                
                // Patients count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Showing ${filteredPatients.length} patients',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Patient list
                Expanded(
                  child: filteredPatients.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No patients found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredPatients.length,
                          itemBuilder: (context, index) {
                            return _buildPatientCard(filteredPatients[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildPatientCard(Map<String, dynamic> patient) {
    final bool isActive = patient['status'] == 'Active';
    final double adherence = patient['adherence'] as double;
    
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
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context, 
            AppRoutes.physioPatientRecord,
            arguments: patient['id'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient info row
              Row(
                children: [
                  // Profile picture
                  CircleAvatar(
                    backgroundColor: AppTheme.aliceBlue,
                    radius: 24,
                    child: Text(
                      patient['name'].toString().substring(0, 1),
                      style: const TextStyle(
                        color: AppTheme.midnightTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Patient name and age
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${patient['age']} years old',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      patient['status'],
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Condition
              Row(
                children: [
                  const Icon(Icons.medical_information, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Condition: ${patient['condition']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Last visit
              Row(
                children: [
                  const Icon(Icons.event_available, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Last visit: ${_formatDate(patient['lastVisit'])}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Next visit
              Row(
                children: [
                  const Icon(Icons.event, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Next visit: ${patient['nextVisit'] != null ? _formatDate(patient['nextVisit']) : 'Not scheduled'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Adherence
              Row(
                children: [
                  const Icon(Icons.fitness_center, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('Exercise adherence: ', style: TextStyle(fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: adherenceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(adherence * 100).toInt()}%',
                      style: TextStyle(
                        color: adherenceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Patient record button
                  OutlinedButton.icon(
                    icon: const Icon(Icons.medical_information),
                    label: const Text('View Records'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.physioPatientRecord,
                        arguments: patient['id'],
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  
                  // Message button
                  OutlinedButton.icon(
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.physioCommunication,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}