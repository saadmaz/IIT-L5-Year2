import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(label),
        backgroundColor: Colors.green.shade100,
        onPressed: onTap,
      ),
    );
  }
}
