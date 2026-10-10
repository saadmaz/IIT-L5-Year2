import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PainLevelDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Pain Level History'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPainLevelOverviewCard(),
            const SizedBox(height: 20),
            _buildPainLevelChart(),
            const SizedBox(height: 20),
            _buildPainInterventionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPainLevelOverviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade700.withOpacity(0.7),
            Colors.orange.shade900.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Pain Level',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '4/10',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.sentiment_neutral,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Moderate discomfort, requires careful management',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPainLevelChart() {
    final List<PainData> painData = [
      PainData('Week 1', 6),
      PainData('Week 2', 5),
      PainData('Week 3', 4),
      PainData('Week 4', 4),
      PainData('Week 5', 4),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pain Level Progression',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                minimum: 0,
                maximum: 10,
                interval: 2,
                majorGridLines: const MajorGridLines(
                  color: Colors.white12,
                  dashArray: [5, 5],
                ),
              ),
              series: <CartesianSeries<PainData, String>>[
                LineSeries<PainData, String>(
                  dataSource: painData,
                  xValueMapper: (PainData pain, _) => pain.week,
                  yValueMapper: (PainData pain, _) => pain.level,
                  color: Colors.orange,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Colors.white,
                    borderColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPainInterventionSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Interventions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInterventionItem(
            'Physical Therapy',
            'Gentle stretching and mobility exercises',
            Icons.sports_gymnastics,
          ),
          const SizedBox(height: 10),
          _buildInterventionItem(
            'Pain Management',
            'Heat therapy and targeted muscle relaxation',
            Icons.medical_services,
          ),
        ],
      ),
    );
  }

  Widget _buildInterventionItem(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobilityDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Mobility Progress'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMobilityOverviewCard(),
            const SizedBox(height: 20),
            _buildMobilityChart(),
            const SizedBox(height: 20),
            _buildMobilityExercisesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilityOverviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700.withOpacity(0.7),
            Colors.blue.shade900.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mobility Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '75%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.directions_walk,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Steady improvement in range of motion',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilityChart() {
    final List<MobilityData> mobilityData = [
      MobilityData('Week 1', 40),
      MobilityData('Week 2', 55),
      MobilityData('Week 3', 65),
      MobilityData('Week 4', 70),
      MobilityData('Week 5', 75),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mobility Progression',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                minimum: 0,
                maximum: 100,
                interval: 20,
                majorGridLines: const MajorGridLines(
                  color: Colors.white12,
                  dashArray: [5, 5],
                ),
              ),
              series: <CartesianSeries<MobilityData, String>>[
                AreaSeries<MobilityData, String>(
                  dataSource: mobilityData,
                  xValueMapper: (MobilityData mobility, _) => mobility.week,
                  yValueMapper: (MobilityData mobility, _) => mobility.percentage,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.7),
                      Colors.blue.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderColor: Colors.blue,
                  borderWidth: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilityExercisesSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Mobility Exercises',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildExerciseItem(
            'Stretching Routine',
            'Improve flexibility and reduce stiffness',
            Icons.accessibility,
          ),
          const SizedBox(height: 10),
          _buildExerciseItem(
            'Range of Motion',
            'Gentle movements to increase joint mobility',
            Icons.sports_gymnastics,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StrengthDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Strength Progress'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStrengthOverviewCard(),
            const SizedBox(height: 20),
            _buildStrengthChart(),
            const SizedBox(height: 20),
            _buildStrengthTrainingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthOverviewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade700.withOpacity(0.7),
            Colors.green.shade900.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Strength Development',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '60%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Consistent progress in muscle strength',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthChart() {
    final List<StrengthData> strengthData = [
      StrengthData('Week 1', 30),
      StrengthData('Week 2', 40),
      StrengthData('Week 3', 50),
      StrengthData('Week 4', 55),
      StrengthData('Week 5', 60),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Strength Progression',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: const TextStyle(color: Colors.white70),
                axisLine: const AxisLine(width: 0),
                minimum: 0,
                maximum: 100,
                interval: 20,
                majorGridLines: const MajorGridLines(
                  color: Colors.white12,
                  dashArray: [5, 5],
                ),
              ),
              series: <CartesianSeries<StrengthData, String>>[
                ColumnSeries<StrengthData, String>(
                  dataSource: strengthData,
                  xValueMapper: (StrengthData strength, _) => strength.week,
                  yValueMapper: (StrengthData strength, _) => strength.percentage,
                  color: Colors.green,
                  width: 0.6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthTrainingSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Strength Training Recommendations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTrainingItem(
            'Resistance Training',
            'Gradual increase in weight and repetitions',
            Icons.sports_gymnastics,
          ),
          const SizedBox(height: 10),
          _buildTrainingItem(
            'Core Strengthening',
            'Targeted exercises for stability and support',
            Icons.sports_kabaddi,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingItem(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper classes for chart data
class PainData {
  final String week;
  final double level;

  PainData(this.week, this.level);
}

class MobilityData {
  final String week;
  final double percentage;

  MobilityData(this.week, this.percentage);
}

class StrengthData {
  final String week;
  final double percentage;

  StrengthData(this.week, this.percentage);
}