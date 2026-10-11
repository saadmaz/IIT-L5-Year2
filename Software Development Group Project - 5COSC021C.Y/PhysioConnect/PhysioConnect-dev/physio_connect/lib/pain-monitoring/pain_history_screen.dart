import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PainHistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> painHistory;

  const PainHistoryScreen({super.key, required this.painHistory});

  @override
  PainHistoryScreenState createState() => PainHistoryScreenState();
}

class PainHistoryScreenState extends State<PainHistoryScreen> {
  List<Map<String, dynamic>> _filteredPainHistory = [];
  String selectedFilter = "Month"; // Default filter

  @override
  void initState() {
    super.initState();
    _applyFilter(selectedFilter);
  }

  /// ✅ Apply filter for relevant pain history
  void _applyFilter(String filter) {
    DateTime now = DateTime.now();
    DateTime cutoffDate;

    switch (filter) {
      case "Day":
        cutoffDate = now.subtract(const Duration(days: 1));
        break;
      case "Week":
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case "Month":
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case "6 Months":
        cutoffDate = now.subtract(const Duration(days: 180));
        break;
      default:
        cutoffDate = now;
    }

    setState(() {
      selectedFilter = filter;
      _filteredPainHistory = widget.painHistory.where((entry) {
        try {
          return _parseEntryDate(entry['date']).isAfter(cutoffDate);
        } catch (e) {
          return false;
        }
      }).toList();
    });
  }

  /// Parse a stored entry date. Older entries used an en dash separator,
  /// so normalise it before parsing.
  DateTime _parseEntryDate(String dateString) {
    return DateFormat('yyyy-MM-dd - kk:mm')
        .parse(dateString.replaceAll(String.fromCharCode(0x2013), '-'));
  }

  /// ✅ Format Date as "Fri 21 Mar"
  String _formatDate(String dateString) {
    try {
      DateTime dateTime = _parseEntryDate(dateString);
      return DateFormat('E d MMM').format(dateTime); // Fri 21 Mar
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// ✅ Format Time as "02:46 AM"
  String _formatTime(String dateString) {
    try {
      DateTime dateTime = _parseEntryDate(dateString);
      return DateFormat('hh:mm a').format(dateTime); // 02:46 AM
    } catch (e) {
      return "--:--";
    }
  }

  /// ✅ Get Color for Pain Level
  Color _getPainColor(num level) {
    if (level <= 3) return const Color(0xFF33724B); // Midnight Teal
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF), // Alice Blue Background
      appBar: AppBar(
        title: const Text(
          'Pain History',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF33724B)), // Midnight Teal
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF33724B)),
            tooltip: "Refresh Data",
            onPressed: () => _applyFilter(selectedFilter),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Timeframe Selection with Better UI
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Day", "Week", "Month", "6 Months"]
                  .map((filter) => ChoiceChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (selected) {
                          if (selected) _applyFilter(filter);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF33724B), // Midnight Teal
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedFilter == filter
                              ? Colors.white
                              : const Color(0xFF33724B), // Midnight Teal
                        ),
                      ))
                  .toList(),
            ),
          ),

          // ✅ Improved Pain Level Chart
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SfCartesianChart(
                backgroundColor: Colors.transparent,
                primaryXAxis: CategoryAxis(
                  labelRotation: 0,
                  labelStyle: const TextStyle(
                      color: Color(0xFF33724B)), // Midnight Teal
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 10,
                  interval: 1,
                  labelStyle: const TextStyle(
                      color: Color(0xFF33724B)), // Midnight Teal
                ),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _filteredPainHistory,
                    xValueMapper: (data, _) => _formatDate(data['date']),
                    yValueMapper: (data, _) => (data['painLevel'] as num)
                        .toInt(), // ✅ Ensured safety for int conversion
                    color: const Color(0xFF33724B), // Midnight Teal
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Enhanced Pain Entries List
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredPainHistory.length,
              itemBuilder: (context, index) {
                final entry = _filteredPainHistory[index];
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.circle,
                        color: _getPainColor(entry['painLevel']), size: 12),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pain Level: ${entry['painLevel'].toInt()}",
                          style: TextStyle(
                              color: _getPainColor(entry['painLevel']),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatTime(entry['date']),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "📍 Location: ${entry['painLocation']}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
