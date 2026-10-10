import 'package:flutter/material.dart';

class GlowingEffect extends StatelessWidget {
  final Widget child; // ✅ Accepts a child widget
  final Color glowColor;
  final double blurRadius;

  const GlowingEffect({
    super.key,
    required this.child, // ✅ Define 'child' parameter
    this.glowColor = Colors.teal,
    this.blurRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: blurRadius,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child, // ✅ Properly wraps the child widget
    );
  }
}
