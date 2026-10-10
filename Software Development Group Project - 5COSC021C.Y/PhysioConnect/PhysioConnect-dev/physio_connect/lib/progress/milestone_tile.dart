import 'package:flutter/material.dart';
import '../models/milestone.dart';

class MilestoneTile extends StatelessWidget {
  final Milestone milestone;

  const MilestoneTile({Key? key, required this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: milestone.achieved ? Colors.green[400] : Colors.grey[800],
      child: ListTile(
        leading: Icon(
          milestone.achieved ? Icons.check_circle : Icons.hourglass_empty,
          color: milestone.achieved ? Colors.white : Colors.yellowAccent,
        ),
        title: Text(
          milestone.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
