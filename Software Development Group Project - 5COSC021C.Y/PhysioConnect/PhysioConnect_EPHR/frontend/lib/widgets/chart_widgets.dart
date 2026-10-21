import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';

/// Collection of custom chart widgets for data visualization
/// Used in dashboard, pain tracker, and other screens

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final String title;
  final String xAxisTitle;
  final String yAxisTitle;
  final double minY;
  final double maxY;
  final int divisions;
  final bool showDots;
  
  const LineChartWidget({
    Key? key,
    required this.spots,
    required this.title,
    required this.xAxisTitle,
    required this.yAxisTitle,
    this.minY = 0,
    required this.maxY,
    this.divisions = 5,
    this.showDots = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Line chart
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: maxY / divisions,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Text(
                    xAxisTitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Text(
                    yAxisTitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              minX: 0,
              maxX: spots.isNotEmpty ? spots.last.x : 10,
              minY: minY,
              maxY: maxY,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.grey[800]!.withOpacity(0.8),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      return LineTooltipItem(
                        '${touchedSpot.y.toStringAsFixed(1)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppTheme.midnightTeal,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: showDots,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.midnightTeal,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.midnightTeal.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PainScaleWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final bool isInteractive;
  
  const PainScaleWidget({
    Key? key,
    required this.value,
    this.onChanged,
    this.isInteractive = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pain scale slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _getColorForPainLevel(value),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: _getColorForPainLevel(value),
            overlayColor: _getColorForPainLevel(value).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            trackHeight: 8,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 10,
            label: value.toInt().toString(),
            onChanged: isInteractive ? onChanged : null,
          ),
        ),
        
        // Pain scale labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPainLabel('No Pain', 0),
              _buildPainLabel('Moderate', 5),
              _buildPainLabel('Severe', 10),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build a pain level label widget
  Widget _buildPainLabel(String label, int value) {
    final bool isCurrentValue = this.value.round() == value;
    
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: isCurrentValue ? FontWeight.bold : FontWeight.normal,
            color: isCurrentValue ? _getColorForPainLevel(value.toDouble()) : Colors.grey[600],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCurrentValue ? _getColorForPainLevel(value.toDouble()) : Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  /// Get color based on pain level
  Color _getColorForPainLevel(double level) {
    if (level <= 3) {
      return Colors.green;
    } else if (level <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class BodyPainMapWidget extends StatelessWidget {
  final Map<String, double> painPoints;
  final Function(String bodyPart)? onBodyPartTap;
  
  const BodyPainMapWidget({
    Key? key,
    required this.painPoints,
    this.onBodyPartTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Body outline image
        Image.asset(
          'assets/images/body_outline.png',
          height: 400,
          fit: BoxFit.contain,
        ),
        
        // Pain points
        ...painPoints.entries.map((entry) {
          final bodyPart = entry.key;
          final painLevel = entry.value;
          
          // Position would need to be determined based on body part
          final position = _getPositionForBodyPart(bodyPart);
          
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onTap: () {
                if (onBodyPartTap != null) {
                  onBodyPartTap!(bodyPart);
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _getColorForPainLevel(painLevel).withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    painLevel.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
  
  /// Get position for a body part on the map
  Offset _getPositionForBodyPart(String bodyPart) {
    // These would be predetermined positions based on the body outline image
    // Just placeholder positions for now
    final Map<String, Offset> positions = {
      'head': const Offset(150, 40),
      'neck': const Offset(150, 70),
      'rightShoulder': const Offset(120, 90),
      'leftShoulder': const Offset(180, 90),
      'rightArm': const Offset(100, 140),
      'leftArm': const Offset(200, 140),
      'chest': const Offset(150, 120),
      'abdomen': const Offset(150, 170),
      'rightLeg': const Offset(130, 250),
      'leftLeg': const Offset(170, 250),
      'rightKnee': const Offset(130, 280),
      'leftKnee': const Offset(170, 280),
      'rightFoot': const Offset(130, 350),
      'leftFoot': const Offset(170, 350),
      'back': const Offset(300, 150),
      'lowerBack': const Offset(300, 200),
    };
    
    return positions[bodyPart] ?? const Offset(150, 150);
  }
  
  /// Get color based on pain level
  Color _getColorForPainLevel(double level) {
    if (level <= 3) {
      return Colors.green;
    } else if (level <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}