import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelProgressPage extends StatefulWidget {
  @override
  _LevelProgressPageState createState() => _LevelProgressPageState();
}

class _LevelProgressPageState extends State<LevelProgressPage> with SingleTickerProviderStateMixin {
  double _progress = 0.5; // Current progress towards the next level (50% complete)
  bool _isDarkMode = false; // Toggle for dark mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Current Level Details",
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.white),
        ),
        backgroundColor: const Color(0xFF33724B),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // **Circular Level Progress Display**
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    _animatedCircle("Beginner", 1.0, "Completed ✅"),
                    _animatedCircle("Intermediate", _progress, "In Progress 🔵"),
                    _animatedCircle("Advanced", 0.0, "Locked 🔒"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // **Progress Summary**
            _progressSummary(),

            const SizedBox(height: 30),

            // **Animated Button for Fun**
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _progress += 0.1;
                  if (_progress >= 1.0) _progress = 1.0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33724B),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Train & Level Up 🔥",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ).animate().fade(duration: 700.ms).moveY(begin: 20),
          ],
        ),
      ),
    );
  }

  // **Circular Progress Indicator for Each Level**
  Widget _animatedCircle(String title, double progress, String status) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF33724B)),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().scale(delay: 200.ms, duration: 500.ms),
        const SizedBox(height: 10),
        Text(
          status,
          style: TextStyle(fontSize: 14, color: _isDarkMode ? Colors.white70 : Colors.black87),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // **Progress Summary with Animations**
  Widget _progressSummary() {
    return Column(
      children: [
        const Text(
          "Level Breakdown 🏆",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ).animate().fade(duration: 700.ms),
        const SizedBox(height: 15),
        _progressTile("Beginner Level ✅", "Completed with 10 Sessions"),
        _progressTile("Intermediate Level 🔵", "5 More Sessions to Advance"),
        _progressTile("Advanced Level 🔒", "15 More Sessions Required"),
        _progressTile("Expert Level 🚀", "25 More Sessions to Mastery"),
      ],
    );
  }

  // **Reusable Progress Tile**
  Widget _progressTile(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFEAF7FF),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.star, color: Color(0xFF33724B), size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ),
    ).animate().fade(duration: 600.ms);
  }
}
