import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnderstandingMuscleStrainsScreen extends StatefulWidget {
  const UnderstandingMuscleStrainsScreen({super.key});

  @override
  State<UnderstandingMuscleStrainsScreen> createState() =>
      _UnderstandingMuscleStrainsScreenState();
}

class _UnderstandingMuscleStrainsScreenState
    extends State<UnderstandingMuscleStrainsScreen> {
  List<dynamic> _strains = [];

  @override
  void initState() {
    super.initState();
    fetchStrains();
  }

  Future<void> fetchStrains() async {
    final uri = Uri.parse(
        "http://192.168.8.140:5000/api/strains"); // Use your IP for real device
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        _strains = json.decode(response.body);
      });
    } else {
      // Handle error
      print("Failed to fetch data");
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
            "Understanding Muscle Strains",
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
                  // ignore: deprecated_member_use
                  Colors.white.withOpacity(0.1),
                  // ignore: deprecated_member_use
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
                    "Understanding Muscle Strains",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33724B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Learn about the types of muscle strains and treatments.",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: _strains.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _strains.length,
                            itemBuilder: (context, index) {
                              final strain = _strains[index];
                              return _buildStrainCard(
                                title: strain['title'],
                                description: strain['description'],
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

  Widget _buildStrainCard(
      {required String title, required String description}) {
    return Card(
      // ignore: deprecated_member_use
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
