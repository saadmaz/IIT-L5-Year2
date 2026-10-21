import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/file_viewer.dart';

/// Test Detail Screen
/// Shows detailed information about a test result or medical report
/// Includes report summary, findings, and document viewing

class TestDetailScreen extends StatefulWidget {
  final Map<String, dynamic> test;
  
  const TestDetailScreen({
    Key? key,
    required this.test,
  }) : super(key: key);

  @override
  State<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  bool _isLoadingFile = false;
  String? _filePath;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    // In a real app, we would download and cache the file here
    // For now, just simulate the process
    _simulateFileDownload();
  }
  
  /// Simulate file download (would be real download in a real app)
  Future<void> _simulateFileDownload() async {
    setState(() {
      _isLoadingFile = true;
      _error = null;
    });
    
    try {
      // In a real app, we would download the file using storageService
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would be the path to the downloaded file
      _filePath = '/path/to/downloaded/file.pdf';
      
      setState(() {
        _isLoadingFile = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFile = false;
        _error = e.toString();
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final date = widget.test['date'] as DateTime;
    return Scaffold(
      appBar: EPHRAppBar(
        title: widget.test['title'],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test result header
            _buildTestHeader(date),
            const SizedBox(height: 24),
            
            // Test details
            _buildDetailSection(
              title: 'Test Details',
              icon: Icons.info,
              child: _buildTestDetails(),
            ),
            const SizedBox(height: 24),
            
            // Summary section
            _buildDetailSection(
              title: 'Summary',
              icon: Icons.summarize,
              child: _buildSummary(),
            ),
            const SizedBox(height: 24),
            
            // Document viewer
            _buildDetailSection(
              title: 'Document',
              icon: Icons.description,
              child: _buildDocumentViewer(),
            ),
            const SizedBox(height: 24),
            
            // Actions
            _buildActionsRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  /// Build test header with provider info and date
  Widget _buildTestHeader(DateTime date) {
    // Get icon based on result type
    IconData typeIcon;
    switch (widget.test['type']) {
      case 'Imaging':
        typeIcon = Icons.image;
        break;
      case 'Laboratory':
        typeIcon = Icons.science;
        break;
      case 'Assessment':
        typeIcon = Icons.assessment;
        break;
      default:
        typeIcon = Icons.description;
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test type icon
            CircleAvatar(
              backgroundColor: AppTheme.aliceBlue,
              radius: 30,
              child: Icon(
                typeIcon,
                color: AppTheme.midnightTeal,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            
            // Test information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with importance badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.test['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (widget.test['isImportant'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Important',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Category and date
                  Text(
                    '${widget.test['category']} • ${_formatDate(date)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Provider info
                  Row(
                    children: [
                      const Icon(
                        Icons.business,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.test['providerName'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Ordered by
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Ordered by: ${widget.test['orderedBy']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
  
  /// Build test details section
  Widget _buildTestDetails() {
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
            // Type
            _buildDetailRow('Type:', widget.test['type']),
            const SizedBox(height: 8),
            
            // Category
            _buildDetailRow('Category:', widget.test['category']),
            const SizedBox(height: 8),
            
            // Provider
            _buildDetailRow('Provider:', widget.test['providerName']),
            const SizedBox(height: 8),
            
            // Provider type
            _buildDetailRow('Provider Type:', widget.test['providerType']),
            const SizedBox(height: 8),
            
            // Ordered by
            _buildDetailRow('Ordered By:', widget.test['orderedBy']),
            const SizedBox(height: 8),
            
            // Date
            _buildDetailRow(
              'Date:', 
              _formatDate(widget.test['date'] as DateTime),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build summary section
  Widget _buildSummary() {
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
            // Summary text
            Text(
              widget.test['summary'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            
            // In a real app, we might have more detailed findings here
            const SizedBox(height: 16),
            const Text(
              'This is a simplified view. Please refer to the full document below for detailed findings and recommendations.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build document viewer section
  Widget _buildDocumentViewer() {
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
            if (_isLoadingFile)
              // Loading indicator
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
                    ),
                    SizedBox(height: 16),
                    Text('Loading document...'),
                  ],
                ),
              )
            else if (_error != null)
              // Error message
              Center(
                child: Column(
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
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _simulateFileDownload,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
            else if (_filePath != null)
              // In a real app, we would use the FileViewer widget here
              // For now, just show a placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'PDF Document',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Document viewer not implemented in demo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              // No document available
              const Center(
                child: Text('No document available'),
              ),
              
            // Document controls
            if (_filePath != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Download functionality would be implemented in a real app
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download functionality not implemented'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Open in external viewer functionality would be implemented in a real app
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('External viewer functionality not implemented'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open In Viewer'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build actions row
  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Share with provider button
        ElevatedButton.icon(
          icon: const Icon(Icons.share),
          label: const Text('Share with Provider'),
          onPressed: () {
            // Share functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share functionality not implemented'),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        
        // Print button
        OutlinedButton.icon(
          icon: const Icon(Icons.print),
          label: const Text('Print'),
          onPressed: () {
            // Print functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Print functionality not implemented'),
              ),
            );
          },
        ),
      ],
    );
  }
  
  /// Build a detail row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}