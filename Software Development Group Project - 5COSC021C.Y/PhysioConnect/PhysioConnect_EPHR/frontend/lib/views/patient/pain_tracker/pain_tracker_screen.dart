import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/pain_entry.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';
import '../../../widgets/chart_widgets.dart';
import '../../../widgets/ephr_card.dart';

/// Pain Tracker Screen
/// Visual tracker for pain intensity on a scale from 1-10
/// Track by date and affected body part, with notes and triggers

class PainTrackerScreen extends StatefulWidget {
  const PainTrackerScreen({Key? key}) : super(key: key);

  @override
  State<PainTrackerScreen> createState() => _PainTrackerScreenState();
}

class _PainTrackerScreenState extends State<PainTrackerScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<PainEntry> _painEntries = [];
  Map<String, List<PainEntry>> _entriesByBodyPart = {};
  Map<String, double> _painPoints = {};
  String? _error;
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPainEntries();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  /// Load pain entries from API
  Future<void> _loadPainEntries() async {
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
      
      // Load pain entries
      _painEntries = await ephrService.getPainEntries(userId);
      
      // Sort by date (newest first)
      _painEntries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      
      // Group entries by body part
      _entriesByBodyPart = {};
      for (final entry in _painEntries) {
        if (!_entriesByBodyPart.containsKey(entry.bodyPart)) {
          _entriesByBodyPart[entry.bodyPart] = [];
        }
        _entriesByBodyPart[entry.bodyPart]!.add(entry);
      }
      
      // Calculate average pain level by body part for the body map
      _painPoints = {};
      _entriesByBodyPart.forEach((bodyPart, entries) {
        final sum = entries.fold(0, (sum, entry) => sum + entry.painLevel);
        final average = sum / entries.length;
        _painPoints[bodyPart] = average;
      });
      
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
          content: Text('Error loading pain entries: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Pain Tracker',
      ),
      drawer: NavigationDrawer(currentRoute: AppRoutes.painTracker),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPainEntry)
              .then((_) => _loadPainEntries());
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
              : _painEntries.isEmpty
                  ? _buildEmptyView()
                  : _buildPainTrackerContent(),
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
            onPressed: _loadPainEntries,
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
            Icons.healing,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No Pain Records Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your pain tracking data will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPainEntry)
                  .then((_) => _loadPainEntries());
            },
            icon: const Icon(Icons.add),
            label: const Text('Track Pain Now'),
          ),
        ],
      ),
    );
  }
  
  /// Build the main pain tracker content
  Widget _buildPainTrackerContent() {
    return Column(
      children: [
        // Tab bar for switching between views
        TabBar(
          controller: _tabController,
          labelColor: AppTheme.midnightTeal,
          indicatorColor: AppTheme.midnightTeal,
          tabs: const [
            Tab(text: 'Timeline'),
            Tab(text: 'Body Map'),
          ],
        ),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Timeline view
              _buildTimelineView(),
              
              // Body map view
              _buildBodyMapView(),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build the timeline view
  Widget _buildTimelineView() {
    return RefreshIndicator(
      onRefresh: _loadPainEntries,
      color: AppTheme.midnightTeal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pain trend chart
            _buildPainTrendSection(),
            const SizedBox(height: 24),
            
            // Recent entries
            const Text(
              'Recent Pain Entries',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Pain entries list
            ...List.generate(_painEntries.length, (index) {
              return _buildPainEntryCard(_painEntries[index]);
            }),
            
            // View all history button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.painHistory);
                },
                icon: const Icon(Icons.history),
                label: const Text('View Complete History'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build the body map view
  Widget _buildBodyMapView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Body pain map
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pain Map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap on pain points to see details',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: BodyPainMapWidget(
                      painPoints: _painPoints,
                      onBodyPartTap: (bodyPart) {
                        _showBodyPartDetails(bodyPart);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Pain by body part
          const Text(
            'Pain by Body Part',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Body part list
          ..._entriesByBodyPart.entries.map((entry) {
            final bodyPart = entry.key;
            final entries = entry.value;
            final averagePain = entries.fold(0, (sum, entry) => sum + entry.painLevel) / entries.length;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getColorForPainLevel(averagePain).withOpacity(0.2),
                  child: Text(
                    averagePain.toStringAsFixed(1),
                    style: TextStyle(
                      color: _getColorForPainLevel(averagePain),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  bodyPart,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('${entries.length} entries'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showBodyPartDetails(bodyPart);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  /// Build pain trend section with chart
  Widget _buildPainTrendSection() {
    // Get last 7 days of entries
    final last7DaysEntries = _painEntries.length > 7 
        ? _painEntries.sublist(0, 7) 
        : _painEntries;
    
    // Create chart data points from newest to oldest
    final spots = List.generate(last7DaysEntries.length, (index) {
      return FlSpot(index.toDouble(), last7DaysEntries[index].painLevel.toDouble());
    }).reversed.toList();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pain Trend (Last 7 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LineChartWidget(
              spots: spots,
              title: '',
              xAxisTitle: 'Days',
              yAxisTitle: 'Pain Level',
              minY: 0,
              maxY: 10,
              divisions: 5,
            ),
            const SizedBox(height: 16),
            
            // Current pain level indicator
            if (_painEntries.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Most Recent Pain Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              PainScaleWidget(
                value: _painEntries.first.painLevel.toDouble(),
                isInteractive: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build a single pain entry card
  Widget _buildPainEntryCard(PainEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: entry.bodyPart,
        subtitle: _formatDateTime(entry.recordedAt),
        leading: CircleAvatar(
          backgroundColor: _getColorForPainLevel(entry.painLevel.toDouble()).withOpacity(0.2),
          child: Text(
            entry.painLevel.toString(),
            style: TextStyle(
              color: _getColorForPainLevel(entry.painLevel.toDouble()),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pain type
            if (entry.painType != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.local_hospital,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Type: ${entry.painType}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            // Description
            if (entry.description != null && entry.description!.isNotEmpty) ...[
              Text(
                entry.description!,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
            ],
            
            // Triggers
            if (entry.triggers != null && entry.triggers!.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Triggers: ${entry.triggers!.join(", ")}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          // View details action
          TextButton(
            onPressed: () {
              // Navigate to pain entry detail
              // This would be implemented in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pain entry detail view not implemented'),
                ),
              );
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
  
  /// Show body part details popup
  void _showBodyPartDetails(String bodyPart) {
    // Get entries for this body part
    final entries = _entriesByBodyPart[bodyPart] ?? [];
    if (entries.isEmpty) return;
    
    // Calculate average pain level
    final totalPain = entries.fold(0, (sum, entry) => sum + entry.painLevel);
    final averagePain = totalPain / entries.length;
    
    // Count by pain type
    final painTypeCount = <String, int>{};
    for (final entry in entries) {
      if (entry.painType != null) {
        painTypeCount[entry.painType!] = (painTypeCount[entry.painType!] ?? 0) + 1;
      }
    }
    
    // Get most common triggers
    final triggerCount = <String, int>{};
    for (final entry in entries) {
      if (entry.triggers != null) {
        for (final trigger in entry.triggers!) {
          triggerCount[trigger] = (triggerCount[trigger] ?? 0) + 1;
        }
      }
    }
    final sortedTriggers = triggerCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Show dialog with details
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getColorForPainLevel(averagePain).withOpacity(0.2),
                    child: Text(
                      averagePain.toStringAsFixed(1),
                      style: TextStyle(
                        color: _getColorForPainLevel(averagePain),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bodyPart,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${entries.length} entries',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Pain scale
              const Text(
                'Average Pain Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              PainScaleWidget(
                value: averagePain,
                isInteractive: false,
              ),
              const SizedBox(height: 16),
              
              // Pain types
              if (painTypeCount.isNotEmpty) ...[
                const Text(
                  'Pain Types',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...painTypeCount.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_hospital,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${e.value} entries',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
              
              // Common triggers
              if (sortedTriggers.isNotEmpty) ...[
                const Text(
                  'Common Triggers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...sortedTriggers.take(3).map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${e.value} entries',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // View all entries
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.painHistory)
                            .then((_) => _loadPainEntries());
                      },
                      child: const Text('View All Entries'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Add new entry
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.addPainEntry)
                            .then((_) => _loadPainEntries());
                      },
                      child: const Text('Add New Entry'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Get color based on pain level
  Color _getColorForPainLevel(double level) {
    if (level <= 3) {
      return Colors.green;
    } else if (level <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  /// Format date and time to display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}