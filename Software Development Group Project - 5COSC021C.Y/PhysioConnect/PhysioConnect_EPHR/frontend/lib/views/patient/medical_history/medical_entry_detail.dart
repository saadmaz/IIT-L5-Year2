import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../services/auth_service.dart';
// import '../../../services/ephr_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/medical_record.dart';
import '../../../widgets/app_bar.dart';
// import '../../../widgets/ephr_card.dart';

/// Medical Entry Detail Screen
/// Shows detailed view of a medical record entry
/// Includes all information, notes, and linked documents

class MedicalEntryDetail extends StatefulWidget {
  final Map<String, dynamic> record;
  
  const MedicalEntryDetail({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<MedicalEntryDetail> createState() => _MedicalEntryDetailState();
}

class _MedicalEntryDetailState extends State<MedicalEntryDetail> {
  late MedicalRecord _medicalRecord;
  bool _isLoading = false;
  List<Map<String, dynamic>> _documents = [];
  
  @override
  void initState() {
    super.initState();
    // Convert JSON to MedicalRecord object
    _medicalRecord = MedicalRecord.fromJson(widget.record);
    _loadDocuments();
  }
  
  /// Load documents associated with this medical record
  Future<void> _loadDocuments() async {
    if (_medicalRecord.documentIds == null || _medicalRecord.documentIds!.isEmpty) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final storageService = Provider.of<StorageService>(context, listen: false);
      
      // Set auth token
      storageService.setAuthToken(authService.authToken ?? '');
      
      // Load document metadata for each document
      final documentsData = <Map<String, dynamic>>[];
      
      for (final documentId in _medicalRecord.documentIds!) {
        try {
          final metadata = await storageService.getDocumentMetadata(documentId);
          documentsData.add(metadata);
        } catch (e) {
          // Skip if document metadata couldn't be loaded
          print('Error loading document $documentId: $e');
        }
      }
      
      setState(() {
        _documents = documentsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading documents: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EPHRAppBar(
        title: _medicalRecord.condition,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            _buildStatusBadge(),
            const SizedBox(height: 24),
            
            // Medical condition details
            _buildDetailSection(
              title: 'Condition Details',
              icon: Icons.medical_information,
              child: _buildConditionDetails(),
            ),
            const SizedBox(height: 24),
            
            // Treatment information
            if (_medicalRecord.treatmentPlan != null && _medicalRecord.treatmentPlan!.isNotEmpty) ...[
              _buildDetailSection(
                title: 'Treatment Plan',
                icon: Icons.healing,
                child: _buildTreatmentPlan(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Notes
            if (_medicalRecord.notes != null && _medicalRecord.notes!.isNotEmpty) ...[
              _buildDetailSection(
                title: 'Notes',
                icon: Icons.note,
                child: _buildNotes(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Documents
            if (_medicalRecord.documentIds != null && _medicalRecord.documentIds!.isNotEmpty) ...[
              _buildDetailSection(
                title: 'Related Documents',
                icon: Icons.description,
                child: _buildDocumentsList(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Actions
            _buildActionsRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  /// Build status badge (resolved or active)
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _medicalRecord.isResolved
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _medicalRecord.isResolved ? Icons.check_circle : Icons.access_time,
            color: _medicalRecord.isResolved ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            _medicalRecord.isResolved ? 'Resolved' : 'Active',
            style: TextStyle(
              color: _medicalRecord.isResolved ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a section with title and icon
  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.midnightTeal,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.midnightTeal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Section content
        child,
      ],
    );
  }
  
  /// Build condition details section
  Widget _buildConditionDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _medicalRecord.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // Diagnosis details
            const Text(
              'Diagnosis Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Date:', 
              _formatDate(_medicalRecord.diagnosisDate)
            ),
            if (_medicalRecord.diagnosisBy != null) ...[
              const SizedBox(height: 4),
              _buildInfoRow('Diagnosed by:', _medicalRecord.diagnosisBy!),
            ],
            
            // Resolution details
            if (_medicalRecord.isResolved && _medicalRecord.resolvedDate != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Resolution Information:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                'Resolved on:', 
                _formatDate(_medicalRecord.resolvedDate!)
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build treatment plan section
  Widget _buildTreatmentPlan() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _medicalRecord.treatmentPlan ?? 'No treatment plan provided',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build notes section
  Widget _buildNotes() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _medicalRecord.notes ?? 'No notes provided',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build documents list section
  Widget _buildDocumentsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
        ),
      );
    }
    
    if (_documents.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _medicalRecord.documentIds == null || _medicalRecord.documentIds!.isEmpty
                ? 'No documents attached'
                : 'Documents could not be loaded',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _documents.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final document = _documents[index];
          return ListTile(
            leading: _getDocumentIcon(document['fileType'] ?? ''),
            title: Text(
              document['fileName'] ?? 'Document ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              document['uploadedDate'] != null
                  ? 'Uploaded: ${_formatDate(DateTime.parse(document['uploadedDate']))}'
                  : '',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Download button
                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: AppTheme.midnightTeal,
                  ),
                  onPressed: () {
                    // Download functionality would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Download functionality not implemented'),
                      ),
                    );
                  },
                  tooltip: 'Download',
                ),
                
                // View button
                IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    color: AppTheme.midnightTeal,
                  ),
                  onPressed: () {
                    // View document functionality would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('View document functionality not implemented'),
                      ),
                    );
                  },
                  tooltip: 'View',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /// Build actions row
  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Edit button
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit Record'),
          onPressed: () {
            // Edit functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Edit functionality not implemented'),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        
        // Toggle resolution status button
        OutlinedButton.icon(
          icon: Icon(
            _medicalRecord.isResolved ? Icons.refresh : Icons.check,
          ),
          label: Text(
            _medicalRecord.isResolved ? 'Mark as Active' : 'Mark as Resolved',
          ),
          onPressed: () {
            // Status toggle functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status toggle functionality not implemented'),
              ),
            );
          },
        ),
      ],
    );
  }
  
  /// Build an information row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  /// Get icon for document type
  Widget _getDocumentIcon(String fileType) {
    IconData icon;
    Color color;
    
    if (fileType.contains('pdf')) {
      icon = Icons.picture_as_pdf;
      color = Colors.red;
    } else if (fileType.contains('image')) {
      icon = Icons.image;
      color = Colors.blue;
    } else if (fileType.contains('word')) {
      icon = Icons.description;
      color = Colors.blue;
    } else if (fileType.contains('excel') || fileType.contains('sheet')) {
      icon = Icons.table_chart;
      color = Colors.green;
    } else {
      icon = Icons.insert_drive_file;
      color = Colors.grey;
    }
    
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}