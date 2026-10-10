import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomizedInjuryRemediesScreen extends StatefulWidget {
  const CustomizedInjuryRemediesScreen({super.key});

  @override
  State<CustomizedInjuryRemediesScreen> createState() =>
      _CustomizedInjuryRemediesScreenState();
}

class _CustomizedInjuryRemediesScreenState
    extends State<CustomizedInjuryRemediesScreen> {
  List remedies = [];

  @override
  void initState() {
    super.initState();
    fetchRemedies();
  }

  Future<void> fetchRemedies() async {
    final response = await http
        .get(Uri.parse('http://192.168.8.140:5000/api/custom-remedies'));
    if (response.statusCode == 200) {
      setState(() {
        remedies = json.decode(response.body);
      });
    }
  }

  void _handleRemedyTap(int remedyId, String remedyTitle) async {
    final response = await http.get(
        Uri.parse('http://192.168.8.140:5000/api/muscle-groups/$remedyId'));
    if (response.statusCode == 200) {
      List groups = json.decode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(remedyTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: groups.map((group) {
              return ListTile(
                leading:
                    const Icon(Icons.chevron_right, color: Color(0xFF33724B)),
                title: Text(group['name']),
                onTap: () {
                  Navigator.of(context).pop();
                  _showInstructions(group['id'], group['name']);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    }
  }

  void _showInstructions(int muscleGroupId, String name) async {
    final response = await http.get(Uri.parse(
        'http://192.168.8.140:5000/api/remedy-details/$muscleGroupId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Instructions for $name"),
          content: Text(
            data['instructions'] ?? 'No instructions found.',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    }
  }

  Widget _buildRemedyCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.healing, color: Color(0xFF33724B)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 13)),
        onTap: onTap,
      ),
    );
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
            "Customized Injury Remedies",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33724B),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF33724B)),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
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
                    "These remedies consider factors such as the user's type of injury, acuteness, wounded area, and the progress in healing to provide personalized treatment plans or exercises tailored to an individual’s recovery needs. Below are the key remedies users can access:",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: remedies.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: remedies.length,
                            itemBuilder: (context, index) {
                              final remedy = remedies[index];
                              return _buildRemedyCard(
                                context,
                                title: remedy['title'],
                                description: remedy['description'] ?? '',
                                onTap: () => _handleRemedyTap(
                                    remedy['id'], remedy['title']),
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
}
