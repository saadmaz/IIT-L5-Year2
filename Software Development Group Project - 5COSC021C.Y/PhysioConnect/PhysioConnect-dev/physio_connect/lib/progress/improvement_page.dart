import 'package:flutter/material.dart';

class ImprovementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Improvement Details"),
        backgroundColor: const Color(0xFF33724B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pain Monitoring Overview 🩹",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _painCard("Lower Back Pain", "Moderate Pain (Level 4)", "You might experience stiffness and occasional discomfort. Gentle stretching and posture correction are advised."),
            _painCard("Knee Injury", "Severe Pain (Level 7)", "You may feel sharp pain when bending. Avoid excessive weight-bearing exercises and follow rehab sessions."),
            _painCard("Shoulder Strain", "Mild Pain (Level 2)", "Mild discomfort when raising arms. Ice therapy and mobility exercises can help."),
          ],
        ),
      ),
    );
  }

  Widget _painCard(String area, String severity, String advice) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFEAF7FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(area, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 5),
            Text(severity, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF33724B))),
            const SizedBox(height: 10),
            Text(advice, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
