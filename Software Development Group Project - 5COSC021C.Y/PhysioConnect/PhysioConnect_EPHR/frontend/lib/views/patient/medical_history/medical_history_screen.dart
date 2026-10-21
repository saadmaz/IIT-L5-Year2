import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/medical_record.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/ephr_card.dart';

/// Medical History Screen
/// Lists past conditions, surgeries, diagnoses
/// Allows for editable entries with dates and physician notes

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  bool _isLoading = true;
  List<MedicalRecord> _medicalRecords = [];
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }
  
  /// Load medical records from API
  Future<void> _loadMedicalRecords() async {
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
      
      // Load medical records
      _medicalRecords = await ephrService.getMedicalRecords(userId);
      
      // Sort by diagnosis date (newest first)
      _medicalRecords.sort((a, b) => b.diagnosisDate.compareTo(a.diagnosisDate));
      
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
          content: Text('Error loading medical records: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Medical History',
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.midnightTeal,
              ),
              child: Text(
                'EPHR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Medical History'),
              selected: true,
              onTap: () {
                // Already on this page, so just close the drawer
                Navigator.pop(context);
              },
            ),
            // Add more navigation items as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add medical record screen
          // This would be implemented in a real app
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add medical record functionality not implemented'),
            ),
          );
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
              : _medicalRecords.isEmpty
                  ? _buildEmptyView()
                  : _buildMedicalRecordsList(),
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
            onPressed: _loadMedicalRecords,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build the empty view
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_information,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No Medical Records Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your medical history will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add medical record screen
              // This would be implemented in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add medical record functionality not implemented'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Medical Record'),
          ),
        ],
      ),
    );
  }
  
  /// Build the medical records list
  Widget _buildMedicalRecordsList() {
    return RefreshIndicator(
      onRefresh: _loadMedicalRecords,
      color: AppTheme.midnightTeal,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _medicalRecords.length,
        itemBuilder: (context, index) {
          final record = _medicalRecords[index];
          return _buildMedicalRecordCard(record);
        },
      ),
    );
  }
  
  /// Build a single medical record card
  Widget _buildMedicalRecordCard(MedicalRecord record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: record.condition,
        subtitle: 'Diagnosed: ${_formatDate(record.diagnosisDate)}',
        leading: CircleAvatar(
          backgroundColor: record.isResolved
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          child: Icon(
            record.isResolved ? Icons.check : Icons.healing,
            color: record.isResolved ? Colors.green : Colors.orange,
            size: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Text(
              record.description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            // Diagnosed by
            if (record.diagnosisBy != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Diagnosed by: ${record.diagnosisBy}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            
            // Treatment plan
            if (record.treatmentPlan != null && record.treatmentPlan!.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(
                    Icons.medical_services,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Treatment: ${record.treatmentPlan}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            
            // Resolution status
            if (record.isResolved && record.resolvedDate != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.event_available,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Resolved on: ${_formatDate(record.resolvedDate!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
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
                AppRoutes.medicalEntryDetail,
                arguments: record.toJson(),
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
            AppRoutes.medicalEntryDetail,
            arguments: record.toJson(),
          );
        },
      ),
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}