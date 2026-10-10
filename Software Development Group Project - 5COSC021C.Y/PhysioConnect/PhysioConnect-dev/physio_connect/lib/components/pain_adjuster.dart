import 'package:flutter/material.dart';

class PainAdjuster extends StatefulWidget {
  final double painLevel;
  final Function(double) onPainLevelChanged;

  const PainAdjuster({
    super.key,
    required this.painLevel,
    required this.onPainLevelChanged,
  });

  @override
  State<PainAdjuster> createState() => _PainAdjusterState();
}

class _PainAdjusterState extends State<PainAdjuster> {
  // Pain emoji scale mapping based on pain intensity
  final List<String> _emojiFaces = [
    "😃", // 1 - Very Happy (No Pain)
    "🙂", // 2 - Slightly Happy (Minimal Pain)
    "😐", // 3 - Neutral (Mild Pain)
    "😕", // 4 - Slight Discomfort
    "😟", // 5 - Noticeable Discomfort
    "😣", // 6 - Uncomfortable Pain
    "😫", // 7 - High Discomfort
    "😖", // 8 - Severe Pain
    "😡", // 9 - Intense Pain
    "🤬", // 10 - Unbearable Pain
  ];

  void _updatePainLevel(double value) {
    widget.onPainLevelChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Adjust Pain Level",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),

        // Pain Level Emoji
        Text(
          _emojiFaces[(widget.painLevel - 1).toInt()],
          style: const TextStyle(fontSize: 50),
        ),

        const SizedBox(height: 10),

        // Pain Level Slider with Gradient Background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.yellow, Colors.orange, Colors.red],
              stops: [0.0, 0.4, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Slider(
            value: widget.painLevel,
            min: 1,
            max: 10,
            divisions: 9,
            label: widget.painLevel.toInt().toString(),
            activeColor: Colors.white,
            inactiveColor: Colors.white38,
            thumbColor: Colors.black,
            onChanged: _updatePainLevel,
          ),
        ),
      ],
    );
  }
}