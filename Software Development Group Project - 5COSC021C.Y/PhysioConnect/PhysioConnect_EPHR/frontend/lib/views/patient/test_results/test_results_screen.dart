import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';
import '../../../widgets/ephr_card.dart';

/// Test Results Screen
/// Displays list of test results and medical reports
/// Allows viewing and managing documents like X-rays, MRIs, blood tests, etc.

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({Key? key}) : super(key: key);

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _testResults = [];
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _loadTestResults();
  }
  
  /// Load test results from API
  Future<void> _loadTestResults() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final storageService = Provider.of<StorageService>(context, listen: false);
      
      // Set auth token
      storageService.setAuthToken(authService.authToken ?? '');
      
      // In a real app, these would come from API calls
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock test results
      _testResults = [
        {
          'id': '1',
          'title': 'Lumbar Spine MRI',
          'type': 'Imaging',
          'category': 'MRI',
          'date': DateTime.now().subtract(const Duration(days: 14)),
          'providerName': 'City General Hospital',
          'providerType': 'Hospital',
          'orderedBy': 'Dr. Michael Chen',
          'summary': 'Mild disc herniation at L4-L5 level. No nerve compression observed.',
          'documentUrl': 'https://example.com/documents/mri_report.pdf',
          'isImportant': true,
        },
        {
          'id': '2',
          'title': 'Complete Blood Count (CBC)',
          'type': 'Laboratory',
          'category': 'Blood Test',
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'providerName': 'LifeLabs Medical Laboratory',
          'providerType': 'Laboratory',
          'orderedBy': 'Dr. Sarah Johnson',
          'summary': 'All values within normal range. No abnormalities detected.',
          'documentUrl': 'https://example.com/documents/cbc_results.pdf',
          'isImportant': false,
        },
        {
          'id': '3',
          'title': 'X-Ray Right Knee',
          'type': 'Imaging',
          'category': 'X-Ray',
          'date': DateTime.now().subtract(const Duration(days: 60)),
          'providerName': 'Ortho Imaging Center',
          'providerType': 'Imaging Center',
          'orderedBy': 'Dr. Sarah Johnson',
          'summary': 'No fracture or dislocation. Mild joint space narrowing consistent with early osteoarthritis.',
          'documentUrl': 'https://example.com/documents/knee_xray.pdf',
          'isImportant': false,
        },
        {
          'id': '4',
          'title': 'Vitamin D Level',
          'type': 'Laboratory',
          'category': 'Blood Test',
          'date': DateTime.now().subtract(const Duration(days: 90)),
          'providerName': 'LifeLabs Medical Laboratory',
          'providerType': 'Laboratory',
          'orderedBy': 'Dr. Sarah Johnson',
          'summary': 'Vitamin D level slightly below normal range. Supplementation recommended.',
          'documentUrl': 'https://example.com/documents/vitamin_d.pdf',
          'isImportant': true,
        },
        {
          'id': '5',
          'title': 'Physical Therapy Initial Assessment',
          'type': 'Assessment',
          'category': 'Evaluation',
          'date': DateTime.now().subtract(const Duration(days: 45)),
          'providerName': 'City Physiotherapy Clinic',
          'providerType': 'Clinic',
          'orderedBy': 'Dr. Sarah Johnson',
          'summary': 'Comprehensive evaluation of lower back pain. Treatment plan created for 8 weeks of therapy.',
          'documentUrl': 'https://example.com/documents/pt_assessment.pdf',
          'isImportant': true,
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
          content: Text('Error loading test results: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  /// Get unique categories from test results
  List<String> _getCategories() {
    final categories = _testResults.map((result) => result['category'] as String).toSet().toList();
    categories.sort();
    return categories;
  }
  
  /// Get filtered test results based on search and category filters
  List<Map<String, dynamic>> _getFilteredResults() {
    return _testResults.where((result) {
      // Apply search filter
      final title = result['title'].toString().toLowerCase();
      final type = result['type'].toString().toLowerCase();
      final category = result['category'].toString().toLowerCase();
      final provider = result['providerName'].toString().toLowerCase();
      final summary = result['summary'].toString().toLowerCase();
      
      final searchLower = _searchQuery.toLowerCase();
      final matchesSearch = searchLower.isEmpty || 
          title.contains(searchLower) ||
          type.contains(searchLower) ||
          category.contains(searchLower) ||
          provider.contains(searchLower) ||
          summary.contains(searchLower);
      
      // Apply category filter
      final matchesCategory = _selectedCategory == null || 
          result['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Test Results & Reports',
      ),
      drawer: NavigationDrawer(currentRoute: AppRoutes.testResults),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.uploadDocument)
              .then((_) => _loadTestResults());
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.upload_file),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : _error != null
              ? _buildErrorView()
              : _testResults.isEmpty
                  ? _buildEmptyView()
                  : _buildTestResultsList(),
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
            onPressed: _loadTestResults,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build empty view
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No Test Results Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your test results and reports will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.uploadDocument)
                  .then((_) => _loadTestResults());
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Document'),
          ),
        ],
      ),
    );
  }
  
  /// Build test results list
  Widget _buildTestResultsList() {
    final filteredResults = _getFilteredResults();
    final categories = _getCategories();
    
    return Column(
      children: [
        // Search and filter bar
        _buildSearchAndFilterBar(categories),
        
        // Results
        Expanded(
          child: filteredResults.isEmpty
              ? _buildNoResultsFoundView()
              : RefreshIndicator(
                  onRefresh: _loadTestResults,
                  color: AppTheme.midnightTeal,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      return _buildTestResultCard(filteredResults[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }
  
  /// Build search and filter bar
  Widget _buildSearchAndFilterBar(List<String> categories) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.aliceBlue,
      child: Column(
        children: [
          // Search field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search test results...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Category filter
          if (categories.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All categories option
                  _buildCategoryFilterChip('All', null),
                  
                  // Category options
                  ...categories.map((category) {
                    return _buildCategoryFilterChip(category, category);
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  /// Build category filter chip
  Widget _buildCategoryFilterChip(String label, String? value) {
    final isSelected = _selectedCategory == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? value : null;
          });
        },
        selectedColor: AppTheme.midnightTeal.withOpacity(0.2),
        checkmarkColor: AppTheme.midnightTeal,
      ),
    );
  }
  
  /// Build no results found view
  Widget _buildNoResultsFoundView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No results match your search',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedCategory = null;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
  
  /// Build a test result card
  Widget _buildTestResultCard(Map<String, dynamic> result) {
    // Get icon based on result type
    IconData typeIcon;
    switch (result['type']) {
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
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: result['title'],
        subtitle: '${result['category']} • ${_formatDate(result['date'] as DateTime)}',
        leading: CircleAvatar(
          backgroundColor: AppTheme.aliceBlue,
          child: Icon(
            typeIcon,
            color: AppTheme.midnightTeal,
            size: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    'Provider: ${result['providerName']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
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
                    'Ordered by: ${result['orderedBy']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Summary
            Text(
              result['summary'],
              style: const TextStyle(
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Important badge if applicable
            if (result['isImportant'] == true) ...[
              const SizedBox(height: 8),
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
          ],
        ),
        actions: [
          // View button
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.testDetail,
                arguments: result,
              );
            },
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('View'),
          ),
          
          // Download button
          IconButton(
            onPressed: () {
              // Download functionality would be implemented in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download functionality not implemented'),
                ),
              );
            },
            icon: const Icon(
              Icons.download,
              size: 20,
              color: AppTheme.midnightTeal,
            ),
            tooltip: 'Download',
          ),
        ],
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.testDetail,
            arguments: result,
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