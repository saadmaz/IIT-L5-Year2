import 'package:flutter/material.dart';

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const CallControlButton({
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 28,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed ?? () {},
      ),
    );
  }
}
