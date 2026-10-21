import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/medication.dart';
import '../../../widgets/app_bar.dart';
// import '../../../widgets/navigation_drawer.dart';
import '../../../widgets/ephr_card.dart';

/// Medications Screen
/// Lists current and past medications
/// Tracks prescriptions with dosage, frequency, and prescriber information

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<Medication> _medications = [];
  List<Map<String, dynamic>> _allergies = [];
  String? _error;
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMedications();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  /// Load medications from API
  Future<void> _loadMedications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      final userId = authService.userState.currentUser?.id ?? '';
      
      // Load medications
      _medications = await ephrService.getMedications(userId);
      
      // Sort by start date (newest first)
      _medications.sort((a, b) => b.startDate.compareTo(a.startDate));
      
      // Mock allergies data (would come from API in a real app)
      _allergies = [
        {
          'id': '1',
          'type': 'Medication',
          'name': 'Penicillin',
          'severity': 'High',
          'reaction': 'Rash, difficulty breathing',
          'diagnosedDate': DateTime(2019, 5, 12),
        },
        {
          'id': '2',
          'type': 'Food',
          'name': 'Peanuts',
          'severity': 'Medium',
          'reaction': 'Hives, swelling',
          'diagnosedDate': DateTime(2018, 3, 24),
        },
        {
          'id': '3',
          'type': 'Environmental',
          'name': 'Pollen',
          'severity': 'Low',
          'reaction': 'Sneezing, watery eyes',
          'diagnosedDate': DateTime(2020, 8, 15),
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
          content: Text('Error loading medications: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Medications & Allergies',
      ),
      // drawer: NavigationDrawer(currentRoute: AppRoutes.medications),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addMedication)
              .then((_) => _loadMedications());
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
      ),
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
                        Tab(text: 'Medications'),
                        Tab(text: 'Allergies'),
                      ],
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Medications tab
                          _medications.isEmpty
                              ? _buildEmptyMedicationsView()
                              : _buildMedicationsList(),
                          
                          // Allergies tab
                          _allergies.isEmpty
                              ? _buildEmptyAllergiesView()
                              : _buildAllergiesList(),
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
            onPressed: _loadMedications,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build empty medications view
  Widget _buildEmptyMedicationsView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              color: Colors.grey[400],
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'No Medications Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your medications will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addMedication)
                    .then((_) => _loadMedications());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build empty allergies view
  Widget _buildEmptyAllergiesView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coronavirus,
              color: Colors.grey[400],
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'No Allergies Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your allergies will appear here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Add allergy function would be implemented in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add allergy functionality not implemented'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Allergy'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build medications list
  Widget _buildMedicationsList() {
    // Split into current and past medications
    final currentMedications = _medications
        .where((medication) => medication.isCurrent)
        .toList();
    final pastMedications = _medications
        .where((medication) => !medication.isCurrent)
        .toList();
    
    return RefreshIndicator(
      onRefresh: _loadMedications,
      color: AppTheme.midnightTeal,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current medications
            if (currentMedications.isNotEmpty) ...[
              const Text(
                'Current Medications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...currentMedications.map((medication) => _buildMedicationCard(medication)),
              const SizedBox(height: 24),
            ],
            
            // Past medications
            if (pastMedications.isNotEmpty) ...[
              const Text(
                'Past Medications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...pastMedications.map((medication) => _buildMedicationCard(medication)),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build a medication card
  Widget _buildMedicationCard(Medication medication) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: medication.name,
        subtitle: 'Prescribed by: ${medication.prescribedBy}',
        leading: CircleAvatar(
          backgroundColor: medication.isCurrent
              ? Colors.green.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          child: Icon(
            Icons.medication,
            color: medication.isCurrent ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dosage and frequency
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medical_services,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Dosage: ${medication.dosage}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Frequency: ${medication.frequency}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Dates
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
                      Expanded(
                        child: Text(
                          'Started: ${_formatDate(medication.startDate)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (medication.endDate != null)
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event_available,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Ended: ${_formatDate(medication.endDate!)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            // Instructions if available
            if (medication.instructions != null && medication.instructions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Instructions: ${medication.instructions}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
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
                AppRoutes.medicationDetail,
                arguments: medication.toJson(),
              );
            },
            child: const Text('View Details'),
          ),
          
          // Edit button
          IconButton(
            onPressed: () {
              // Edit functionality would be implemented in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality not implemented'),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
              size: 20,
              color: AppTheme.midnightTeal,
            ),
            tooltip: 'Edit',
          ),
        ],
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.medicationDetail,
            arguments: medication.toJson(),
          );
        },
      ),
    );
  }
  
  /// Build allergies list
  Widget _buildAllergiesList() {
    return RefreshIndicator(
      onRefresh: _loadMedications,
      color: AppTheme.midnightTeal,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Allergies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Allergies cards
            ..._allergies.map((allergy) => _buildAllergyCard(allergy)),
            
            // Add button
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add allergy function would be implemented in a real app
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add allergy functionality not implemented'),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Allergy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build an allergy card
  Widget _buildAllergyCard(Map<String, dynamic> allergy) {
    // Determine color based on severity
    Color severityColor;
    switch (allergy['severity']) {
      case 'High':
        severityColor = Colors.red;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.yellow;
    }
    
    // Determine icon based on type
    IconData typeIcon;
    switch (allergy['type']) {
      case 'Medication':
        typeIcon = Icons.medication;
        break;
      case 'Food':
        typeIcon = Icons.fastfood;
        break;
      default:
        typeIcon = Icons.eco;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // View allergy details would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Allergy details functionality not implemented'),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type and severity
                Row(
                  children: [
                    // Type icon
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      radius: 16,
                      child: Icon(
                        typeIcon,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Allergy name and type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allergy['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            allergy['type'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Severity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        allergy['severity'],
                        style: TextStyle(
                          color: severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                
                // Reaction
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reaction:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        allergy['reaction'],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Diagnosed date
                Row(
                  children: [
                    const Text(
                      'Diagnosed:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(allergy['diagnosedDate']),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Edit allergy functionality would be implemented in a real app
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit allergy functionality not implemented'),
                          ),
                        );
                      },
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete allergy functionality would be implemented in a real app
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delete allergy functionality not implemented'),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
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
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
