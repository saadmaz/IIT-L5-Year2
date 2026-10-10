import 'package:flutter/material.dart';

class ProgressInput extends StatefulWidget {
  final Function(String, double) onSubmit;

  const ProgressInput({super.key, required this.onSubmit});

  @override
  _ProgressInputState createState() => _ProgressInputState();
}

class _ProgressInputState extends State<ProgressInput> {
  final _weekController = TextEditingController();
  final _progressController = TextEditingController();

  void _submitData() {
    final week = _weekController.text;
    final percentage = double.tryParse(_progressController.text) ?? 0;

    if (week.isEmpty || percentage <= 0) return;

    widget.onSubmit(week, percentage);
    _weekController.clear();
    _progressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _weekController,
              decoration: const InputDecoration(labelText: "Week"),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _progressController,
              decoration: const InputDecoration(labelText: "Progress (%)"),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF33724B)),
              child: const Text("Add Progress"),
            ),
          ],
        ),
      ),
    );
  }
}
