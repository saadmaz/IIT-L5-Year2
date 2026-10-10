import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BalanceStabilityScreen extends StatefulWidget {
  const BalanceStabilityScreen({super.key});

  @override
  State<BalanceStabilityScreen> createState() => _BalanceStabilityScreenState();
}

class _BalanceStabilityScreenState extends State<BalanceStabilityScreen> {
  List<dynamic> workouts = [];

  @override
  void initState() {
    super.initState();
    fetchBalanceWorkouts();
  }

  Future<void> fetchBalanceWorkouts() async {
    final uri = Uri.parse('http://localhost:5000/api/balance-workouts'); // Use actual IP on real device
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workouts = data;
        });
      } else {
        print("Failed to load balance workouts: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching balance workouts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text("Balance & Stability Training"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: workouts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return _buildExerciseStep(
            workout['title'],
            workout['description'],
            workout['instructions'],
          );
        },
      ),
    );
  }

  Widget _buildExerciseStep(String title, String description, String instructions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF33724B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 5),
              Text(instructions, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
