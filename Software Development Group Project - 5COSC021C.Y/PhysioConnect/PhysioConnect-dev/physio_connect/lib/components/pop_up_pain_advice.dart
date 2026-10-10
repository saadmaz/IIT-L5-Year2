import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PopUpPainAdvice extends StatefulWidget {
  final double painLevel;

  const PopUpPainAdvice({super.key, required this.painLevel});

  @override
  PopUpPainAdviceState createState() =>
      PopUpPainAdviceState(); // ✅ Public state
}

class PopUpPainAdviceState extends State<PopUpPainAdvice> {
  bool _expanded = false;

  // ✅ Pain descriptions (1-10)
  final Map<int, Map<String, String>> _painAdvice = {
    1: {
      "summary": "No pain detected! 🎉",
      "advice":
          "You're feeling great! Keep up with healthy movement, hydration, and good posture."
    },
    2: {
      "summary": "Mild discomfort, nothing serious. 😊",
      "advice":
          "This could be from daily activities. Try some light stretching and take breaks from prolonged positions."
    },
    3: {
      "summary": "Slight muscle stiffness. 💪",
      "advice":
          "Gentle movement, hydration, and avoiding staying in one position too long will help relieve stiffness."
    },
    4: {
      "summary": "Noticeable tension in muscles. 🏋️",
      "advice":
          "Try light stretches, warm compress, and massage. Keep moving gently to avoid stiffness."
    },
    5: {
      "summary": "Mild pain, but manageable. ❄️",
      "advice":
          "Consider using an ice pack (15 min on/off). Gentle mobility exercises can prevent worsening pain."
    },
    6: {
      "summary": "Moderate pain, limit strenuous activity. 🚶",
      "advice":
          "Take short rest periods, use heat therapy, and avoid excessive strain on the affected area."
    },
    7: {
      "summary": "Significant discomfort. 🛑",
      "advice":
          "You should limit heavy activity. Use warm compress, consider pain relief methods, and monitor symptoms."
    },
    8: {
      "summary": "High pain, be cautious. ⚠️",
      "advice":
          "Your pain is severe. Avoid further stress on the area. Seek professional advice if it persists."
    },
    9: {
      "summary": "Intense pain, consider medical help. 🏥",
      "advice":
          "Pain at this level needs attention. Contact a physiotherapist or doctor if it lasts more than 24 hours."
    },
    10: {
      "summary": "Extreme pain! Seek help now! 🚨",
      "advice":
          "Severe pain can indicate injury or serious conditions. Stop all activity and seek emergency care immediately!"
    },
  };

  // ✅ Get advice based on pain level (ensures valid range)
  Map<String, String> _getAdvice() {
    int level = widget.painLevel.toInt().clamp(1, 10);
    return _painAdvice[level]!;
  }

  // ✅ Get color based on severity
  Color _getPainColor() {
    if (widget.painLevel <= 3) return Colors.green;
    if (widget.painLevel <= 6) return Colors.yellow;
    if (widget.painLevel <= 8) return Colors.orange;
    return Colors.red;
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> advice = _getAdvice();

    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _getPainColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              advice["summary"]!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  advice["advice"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ).animate().fade(duration: 300.ms).slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
