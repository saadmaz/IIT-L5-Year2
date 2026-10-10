// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreventingCommonSportsInjuriesScreen extends StatefulWidget {
  const PreventingCommonSportsInjuriesScreen({super.key});

  @override
  State<PreventingCommonSportsInjuriesScreen> createState() =>
      _PreventingCommonSportsInjuriesScreenState();
}

class _PreventingCommonSportsInjuriesScreenState
    extends State<PreventingCommonSportsInjuriesScreen> {
  List<dynamic> _preventions = [];

  @override
  void initState() {
    super.initState();
    fetchPreventionTips();
  }

  Future<void> fetchPreventionTips() async {
    final uri = Uri.parse(
        "http://192.168.8.140:5000/api/sports-injury-prevention"); // Replace with IP if on real device
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _preventions = json.decode(response.body);
      });
    } else {
      print("Failed to fetch injury prevention tips");
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
            "Preventing Sports Injuries",
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
                    "Sports Injury Prevention",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33724B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Preventing sports injuries is crucial for athletes and fitness enthusiasts. By following proper techniques, warming up, and using the right equipment, injuries can be significantly reduced. Here are some essential strategies to stay injury-free in sports.",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _preventions.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _preventions.length,
                            itemBuilder: (context, index) {
                              final tip = _preventions[index];
                              return _buildInjuryPreventionCard(
                                title: tip['title'],
                                description: tip['description'],
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

  Widget _buildInjuryPreventionCard({
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
