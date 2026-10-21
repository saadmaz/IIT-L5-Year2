import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../config/theme.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/pain_entry.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/chart_widgets.dart';

/// Pain History Screen
/// Shows historical view of pain entries with filtering options
/// Includes trends, patterns, and detailed record viewing

class PainHistoryScreen extends StatefulWidget {
  const PainHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PainHistoryScreen> createState() => _PainHistoryScreenState();
}

class _PainHistoryScreenState extends State<PainHistoryScreen> {
  bool _isLoading = true;
  List<PainEntry> _allPainEntries = [];
  List<PainEntry> _filteredPainEntries = [];
  Map<String, List<PainEntry>> _entriesByBodyPart = {};
  Map<String, List<PainEntry>> _entriesByPainType = {};
  String? _error;
  
  // Filters
  String? _selectedBodyPart;
  String? _selectedPainType;
  RangeValues _painLevelRange = const RangeValues(0, 10);
  DateTimeRange? _dateRange;
  
  @override
  void initState() {
    super.initState();
    _loadPainEntries();
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
      _allPainEntries = await ephrService.getPainEntries(userId);
      
      // Sort by date (newest first)
      _allPainEntries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      
      // Group entries by body part
      _entriesByBodyPart = {};
      for (final entry in _allPainEntries) {
        if (!_entriesByBodyPart.containsKey(entry.bodyPart)) {
          _entriesByBodyPart[entry.bodyPart] = [];
        }
        _entriesByBodyPart[entry.bodyPart]!.add(entry);
      }
      
      // Group entries by pain type
      _entriesByPainType = {};
      for (final entry in _allPainEntries) {
        if (entry.painType != null) {
          if (!_entriesByPainType.containsKey(entry.painType)) {
            _entriesByPainType[entry.painType!] = [];
          }
          _entriesByPainType[entry.painType!]!.add(entry);
        }
      }
      
      // Apply initial filters (no filters)
      _applyFilters();
      
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
  
  /// Apply filters to pain entries
  void _applyFilters() {
    _filteredPainEntries = List.from(_allPainEntries);
    
    // Filter by body part
    if (_selectedBodyPart != null) {
      _filteredPainEntries = _filteredPainEntries
          .where((entry) => entry.bodyPart == _selectedBodyPart)
          .toList();
    }
    
    // Filter by pain type
    if (_selectedPainType != null) {
      _filteredPainEntries = _filteredPainEntries
          .where((entry) => entry.painType == _selectedPainType)
          .toList();
    }
    
    // Filter by pain level range
    _filteredPainEntries = _filteredPainEntries
        .where((entry) =>
            entry.painLevel >= _painLevelRange.start.round() &&
            entry.painLevel <= _painLevelRange.end.round())
        .toList();
    
    // Filter by date range
    if (_dateRange != null) {
      _filteredPainEntries = _filteredPainEntries
          .where((entry) =>
              entry.recordedAt.isAfter(_dateRange!.start) &&
              entry.recordedAt.isBefore(_dateRange!.end.add(const Duration(days: 1))))
          .toList();
    }
    
    setState(() {});
  }
  
  /// Reset all filters
  void _resetFilters() {
    setState(() {
      _selectedBodyPart = null;
      _selectedPainType = null;
      _painLevelRange = const RangeValues(0, 10);
      _dateRange = null;
      _applyFilters();
    });
  }
  
  /// Show filter dialog
  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Pain Entries'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Body part filter
                    const Text(
                      'Body Part',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String?>(
                      value: _selectedBodyPart,
                      isExpanded: true,
                      hint: const Text('All Body Parts'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Body Parts'),
                        ),
                        ..._entriesByBodyPart.keys.map((bodyPart) {
                          return DropdownMenuItem<String?>(
                            value: bodyPart,
                            child: Text(bodyPart),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedBodyPart = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Pain type filter
                    const Text(
                      'Pain Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String?>(
                      value: _selectedPainType,
                      isExpanded: true,
                      hint: const Text('All Pain Types'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Pain Types'),
                        ),
                        ..._entriesByPainType.keys.map((painType) {
                          return DropdownMenuItem<String?>(
                            value: painType,
                            child: Text(painType),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedPainType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Pain level range filter
                    const Text(
                      'Pain Level Range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(_painLevelRange.start.round().toString()),
                        Expanded(
                          child: RangeSlider(
                            values: _painLevelRange,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            labels: RangeLabels(
                              _painLevelRange.start.round().toString(),
                              _painLevelRange.end.round().toString(),
                            ),
                            onChanged: (values) {
                              setDialogState(() {
                                _painLevelRange = values;
                              });
                            },
                          ),
                        ),
                        Text(_painLevelRange.end.round().toString()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Date range filter
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final now = DateTime.now();
                              final initialDateRange = DateTimeRange(
                                start: now.subtract(const Duration(days: 30)),
                                end: now,
                              );
                              
                              final newDateRange = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                initialDateRange: _dateRange ?? initialDateRange,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppTheme.midnightTeal,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              
                              if (newDateRange != null) {
                                setDialogState(() {
                                  _dateRange = newDateRange;
                                });
                              }
                            },
                            child: Text(
                              _dateRange != null
                                  ? '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'
                                  : 'Select Date Range',
                            ),
                          ),
                        ),
                        if (_dateRange != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setDialogState(() {
                                _dateRange = null;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                // Reset button
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _selectedBodyPart = null;
                      _selectedPainType = null;
                      _painLevelRange = const RangeValues(0, 10);
                      _dateRange = null;
                    });
                  },
                  child: const Text('Reset'),
                ),
                
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                
                // Apply button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Pain History',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : _error != null
              ? _buildErrorView()
              : _allPainEntries.isEmpty
                  ? _buildEmptyView()
                  : _buildPainHistoryContent(),
      floatingActionButton: _allPainEntries.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _showFiltersDialog,
              backgroundColor: AppTheme.midnightTeal,
              child: const Icon(Icons.filter_list),
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
            'Start tracking your pain to see history',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/patient/pain-tracker/add');
            },
            icon: const Icon(Icons.add),
            label: const Text('Track Pain Now'),
          ),
        ],
      ),
    );
  }
  
  /// Build the main pain history content
  Widget _buildPainHistoryContent() {
    return Column(
      children: [
        // Active filters banner
        if (_selectedBodyPart != null ||
            _selectedPainType != null ||
            _painLevelRange.start > 0 ||
            _painLevelRange.end < 10 ||
            _dateRange != null)
          _buildActiveFiltersBanner(),
        
        // Pain entries list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadPainEntries,
            color: AppTheme.midnightTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pain level distribution
                  _buildPainDistributionChart(),
                  const SizedBox(height: 24),
                  
                  // Pain entries by body part
                  _buildPainByBodyPartChart(),
                  const SizedBox(height: 24),
                  
                  // Pain entries list header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pain Records (${_filteredPainEntries.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_filteredPainEntries.length != _allPainEntries.length)
                        Text(
                          'Filtered from ${_allPainEntries.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Pain entries list
                  _filteredPainEntries.isEmpty
                      ? _buildNoMatchingEntriesMessage()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredPainEntries.length,
                          itemBuilder: (context, index) {
                            return _buildPainEntryItem(_filteredPainEntries[index]);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Build active filters banner
  Widget _buildActiveFiltersBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.aliceBlue,
      child: Row(
        children: [
          const Icon(
            Icons.filter_list,
            size: 16,
            color: AppTheme.midnightTeal,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Filters: ' +
                  [
                    if (_selectedBodyPart != null) 'Body Part: $_selectedBodyPart',
                    if (_selectedPainType != null) 'Type: $_selectedPainType',
                    if (_painLevelRange.start > 0 || _painLevelRange.end < 10)
                      'Pain Level: ${_painLevelRange.start.round()}-${_painLevelRange.end.round()}',
                    if (_dateRange != null)
                      'Date: ${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}',
                  ].join(', '),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.midnightTeal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _resetFilters,
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.midnightTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build pain distribution chart
  Widget _buildPainDistributionChart() {
    // Count entries by pain level
    final painLevelCounts = List<int>.filled(11, 0);
    for (final entry in _filteredPainEntries) {
      painLevelCounts[entry.painLevel]++;
    }
    
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
            const Text(
              'Pain Level Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: painLevelCounts.isEmpty
                      ? 5
                      : (painLevelCounts.reduce((a, b) => a > b ? a : b) * 1.2),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey[800]!.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${painLevelCounts[groupIndex]} records',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      axisNameWidget: const Text(
                        'Pain Level',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      axisNameWidget: const Text(
                        'Number of Records',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    11,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: painLevelCounts[index].toDouble(),
                          color: _getColorForPainLevel(index.toDouble()),
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build pain by body part chart
  Widget _buildPainByBodyPartChart() {
    // Count entries by body part
    final bodyPartCounts = <String, int>{};
    for (final entry in _filteredPainEntries) {
      bodyPartCounts[entry.bodyPart] = (bodyPartCounts[entry.bodyPart] ?? 0) + 1;
    }
    
    // Sort by count (descending)
    final sortedBodyParts = bodyPartCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Take top 5
    final topBodyParts = sortedBodyParts.take(5).toList();
    
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
            const Text(
              'Most Affected Body Parts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            topBodyParts.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : Column(
                    children: topBodyParts.map((entry) {
                      final bodyPart = entry.key;
                      final count = entry.value;
                      final percentage = count / _filteredPainEntries.length * 100;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    bodyPart,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey[200],
                                    color: AppTheme.midnightTeal,
                                    minHeight: 10,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '$count (${percentage.toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
  
  /// Build no matching entries message
  Widget _buildNoMatchingEntriesMessage() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No pain records match your filters',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filter criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetFilters,
            child: const Text('Clear Filters'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  /// Build a single pain entry item
  Widget _buildPainEntryItem(PainEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        title: Text(
          entry.bodyPart,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDateTime(entry.recordedAt)),
            if (entry.painType != null)
              Text(
                'Type: ${entry.painType}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to pain entry detail
          // This would be implemented in a real app
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pain entry detail view not implemented'),
            ),
          );
        },
      ),
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
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Format date and time to display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}