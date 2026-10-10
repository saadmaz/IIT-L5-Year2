import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugePainIndicator extends StatelessWidget {
  final double painLevel;

  const GaugePainIndicator({super.key, required this.painLevel});

  // ✅ Function to determine gauge color based on pain level
  Color _getPainColor(double level) {
    if (level <= 3) return Colors.green; // Mild Pain
    if (level <= 6) return Colors.yellow; // Moderate Pain
    return Colors.red; // Severe Pain
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180, // Adjust height as needed
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 10,
                startAngle: 180,
                endAngle: 0,
                showLabels: true,
                showTicks: false,
                axisLineStyle: const AxisLineStyle(
                  thickness: 20, // Thickness of the gauge track
                  color: Colors.grey, // Background of the gauge
                ),
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: painLevel,
                    color: _getPainColor(painLevel), // Highlighted color
                    startWidth: 20,
                    endWidth: 20,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: painLevel,
                    enableAnimation: true,
                    animationType: AnimationType.elasticOut,
                    needleColor: Colors.black,
                    needleStartWidth: 2,
                    needleEndWidth: 6,
                    knobStyle: const KnobStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderColor: Color.fromARGB(0, 0, 0, 0),
                      borderWidth: 2,
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          painLevel.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const Text(
                          "Pain Level",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    positionFactor: 0.5,
                    angle: 90,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
