// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RehabilitationExercisesScreen extends StatefulWidget {
  const RehabilitationExercisesScreen({super.key});

  @override
  State<RehabilitationExercisesScreen> createState() =>
      _RehabilitationExercisesScreenState();
}

class _RehabilitationExercisesScreenState
    extends State<RehabilitationExercisesScreen> {
  List<dynamic> _exercises = [];

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    final uri = Uri.parse(
        "http://192.168.8.140:5000/api/rehabilitation-exercises"); // Replace localhost with IP for real device
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _exercises = json.decode(response.body);
      });
    } else {
      print("Failed to fetch rehabilitation exercises");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Rehabilitation Exercises",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33724B),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF33724B)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rehabilitation Exercises",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33724B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Rehabilitation exercises are essential for recovering from injuries, restoring mobility, and strengthening weakened muscles. These exercises help prevent re-injury and improve overall functional movement. Below are some effective rehabilitation exercises you can incorporate into your recovery process.",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _exercises.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = _exercises[index];
                              return _buildRehabExerciseCard(
                                title: exercise['title'],
                                description: exercise['description'],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRehabExerciseCard({
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
