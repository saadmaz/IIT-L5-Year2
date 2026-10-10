import 'package:flutter/material.dart';
import '../components/gauge_pain_indicator.dart';
import '../components/pain_adjuster.dart';
import '../components/pop_up_pain_advice.dart';
import '../screens/pain_history_screen.dart';
import '../utils/storage_helper.dart';
import 'package:intl/intl.dart';

class PainMonitoringPage extends StatefulWidget {
  const PainMonitoringPage({super.key});

  @override
  PainMonitoringPageState createState() => PainMonitoringPageState();
}

class PainMonitoringPageState extends State<PainMonitoringPage> {
  double _painLevel = 5.0;
  String _painLocation = '';
  List<Map<String, dynamic>> _painHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPainHistory();
  }

  Future<void> _loadPainHistory() async {
    final history = await StorageHelper.loadPainHistory();
    setState(() {
      _painHistory = history;
    });
  }

  Future<void> _savePainEntry() async {
    if (_painLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a pain location!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newEntry = {
      'date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      'painLevel': _painLevel,
      'painLocation': _painLocation,
    };

    await StorageHelper.addPainEntry(newEntry);
    await _loadPainHistory(); // Refresh history after saving
  }

  void _updatePainLevel(double value) {
    setState(() {
      _painLevel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF), // Alice Blue Background
      appBar: AppBar(
        title: const Text(
          'Pain Monitoring',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF33724B), // Midnight Teal
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        actions: [
          if (_painHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history,
                  color: Color(0xFF33724B)), // Midnight Teal
              tooltip: "View Pain History",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PainHistoryScreen(painHistory: _painHistory),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Pain Level Gauge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF33724B),
                    Color(0xFF1F6662)
                  ], // Midnight Teal Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(3, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Current Pain Level",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GaugePainIndicator(painLevel: _painLevel),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Pain Level Adjuster
            PainAdjuster(
              painLevel: _painLevel,
              onPainLevelChanged: _updatePainLevel,
            ),

            const SizedBox(height: 20),

            // ✅ Pain Level Advice
            PopUpPainAdvice(painLevel: _painLevel),

            const SizedBox(height: 20),

            // ✅ Pain Location Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Pain Location",
                  labelStyle: const TextStyle(
                      color: Color(0xFF33724B)), // Midnight Teal
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.location_on,
                      color: Color(0xFF33724B)), // Midnight Teal
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                style: const TextStyle(color: Colors.black87),
                onChanged: (value) {
                  _painLocation = value;
                },
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Save Entry Button
            ElevatedButton.icon(
              onPressed: _savePainEntry,
              icon: const Icon(Icons.save, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33724B), // Midnight Teal
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              label: const Text(
                'Save Entry',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ View Pain History Button
            if (_painHistory.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PainHistoryScreen(painHistory: _painHistory),
                    ),
                  );
                },
                child: const Text(
                  "View Pain History",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33724B), // Midnight Teal
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
