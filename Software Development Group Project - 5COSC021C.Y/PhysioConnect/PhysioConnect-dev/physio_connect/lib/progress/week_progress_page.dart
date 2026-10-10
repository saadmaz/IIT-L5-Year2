import 'package:flutter/material.dart';

class WeekProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> _weeklyProgress = [
    {"week": "Week 1", "daysUsed": 5, "sessionDetails": "Stretching, Light Mobility"},
    {"week": "Week 2", "daysUsed": 4, "sessionDetails": "Strength Training, Posture Correction"},
    {"week": "Week 3", "daysUsed": 6, "sessionDetails": "Balance Training, Light Cardio"},
    {"week": "Week 4", "daysUsed": 3, "sessionDetails": "Pain Management, Recovery Rest"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Weekly Progress"),
        backgroundColor: const Color(0xFF33724B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _weeklyProgress.length,
          itemBuilder: (context, index) {
            return _weekProgressCard(
              _weeklyProgress[index]["week"],
              _weeklyProgress[index]["daysUsed"],
              _weeklyProgress[index]["sessionDetails"],
            );
          },
        ),
      ),
    );
  }

  Widget _weekProgressCard(String week, int daysUsed, String details) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFEAF7FF),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(week, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 5),
            Text("Days Used: $daysUsed", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF33724B))),
            const SizedBox(height: 5),
            Text("Session Details: $details", style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
