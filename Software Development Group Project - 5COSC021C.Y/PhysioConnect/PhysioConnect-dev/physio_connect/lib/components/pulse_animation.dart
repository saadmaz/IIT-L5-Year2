import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const PulseAnimation(
      {super.key, this.size = 100, this.color = Colors.redAccent});

  @override
  PulseAnimationState createState() => PulseAnimationState();
}

class PulseAnimationState extends State<PulseAnimation>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0.85, end: 1.15).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color,
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.favorite,
                  color: widget.color, size: widget.size / 2),
            ),
          ),
        );
      },
    );
  }
}
