// File: lib/screens/home_screen.dart
// Description: Home screen of the PhysioConnect AR application
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/posture_model.dart';
import '../models/exercise_model.dart';
import '../widgets/exercise_card_widget.dart';

/// HomeScreen is the main dashboard of the app
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for demonstration purposes
  late List<PostureAnalysisResult> _recentAnalyses;
  late List<Exercise> _recommendedExercises;
  double _weeklyProgress = 0.78; // 78% progress

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  /// Load mock data for demonstration
  void _loadMockData() {
    // Mock posture analyses
    _recentAnalyses = [
      PostureAnalysisResult(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        skeleton: PostureSkeleton(
          points: [], // Empty for mock
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        issues: [
          PostureIssue(
            id: 'forward_head_posture',
            name: 'Forward Head Posture',
            description: 'Your head is positioned forward of your shoulders',
            severity: 0.65,
            relatedJoints: ['Nose', 'Left Shoulder', 'Right Shoulder'],
            recommendation: 'Try chin tucks and neck stretches',
          ),
        ],
        overallScore: 72.0,
        generalFeedback: 'Your posture needs some improvement',
      ),
      PostureAnalysisResult(
        id: '2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        skeleton: PostureSkeleton(
          points: [], // Empty for mock
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        issues: [
          PostureIssue(
            id: 'rounded_shoulders',
            name: 'Rounded Shoulders',
            description: 'Your shoulders are rolled forward',
            severity: 0.45,
            relatedJoints: ['Left Shoulder', 'Right Shoulder'],
            recommendation: 'Try chest stretches and rowing exercises',
          ),
        ],
        overallScore: 80.0,
        generalFeedback: 'Your posture is improving',
      ),
    ];

    // Mock recommended exercises
    _recommendedExercises = [
      Exercise(
        id: '1',
        name: 'Chin Tucks',
        description: 'Strengthen deep neck flexors and stretch neck extensors',
        category: 'Neck',
        targetArea: 'Neck',
        imageUrls: ['assets/images/exercises/chin_tucks.jpg'],
        videoUrl: 'https://example.com/videos/chin_tucks.mp4',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            instruction: 'Stand with your back against a wall',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 2,
            instruction: 'Pull your chin straight back, keeping your head level',
            durationSeconds: 5,
          ),
          ExerciseStep(
            stepNumber: 3,
            instruction: 'Hold for 5 seconds, then relax',
            durationSeconds: 5,
          ),
        ],
        recommendedSets: 3,
        recommendedReps: 10,
        recommendedDurationSeconds: 0,
        difficultyLevel: 2.0,
        targetPostureIssues: ['forward_head_posture'],
      ),
      Exercise(
        id: '2',
        name: 'Shoulder Blade Squeeze',
        description: 'Strengthen upper back and improve posture',
        category: 'Upper Back',
        targetArea: 'Shoulders',
        imageUrls: ['assets/images/exercises/shoulder_squeeze.jpg'],
        videoUrl: 'https://example.com/videos/shoulder_squeeze.mp4',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            instruction: 'Sit or stand with good posture',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 2,
            instruction: 'Squeeze your shoulder blades together',
            durationSeconds: 5,
          ),
          ExerciseStep(
            stepNumber: 3,
            instruction: 'Hold for 5 seconds, then relax',
            durationSeconds: 5,
          ),
        ],
        recommendedSets: 3,
        recommendedReps: 10,
        recommendedDurationSeconds: 0,
        difficultyLevel: 1.5,
        targetPostureIssues: ['rounded_shoulders'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          'PhysioConnect',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.midnightTeal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.white,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostureCard(),
              const SizedBox(height: 24),
              _buildWeeklyProgressSection(),
              const SizedBox(height: 24),
              _buildRecentAnalysesSection(),
              const SizedBox(height: 24),
              _buildRecommendedExercisesSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main posture card with quick action
  Widget _buildPostureCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/posture'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.midnightTeal,
              AppColors.lightTeal,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Posture Detection',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Analyze your posture in real-time',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.midnightTeal,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Start Analysis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightTeal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build weekly progress section
  Widget _buildWeeklyProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildProgressIndicator(_weeklyProgress),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${(_weeklyProgress * 100).round()}% Completed',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.midnightTeal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You\'re making great progress! Keep up with your exercises.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('5', 'Sessions', Icons.access_time),
                  _buildStatCard('12', 'Exercises', Icons.fitness_center),
                  _buildStatCard('78', 'Avg Score', Icons.analytics),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build progress indicator wheel
  Widget _buildProgressIndicator(double progress) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: AppColors.aliceBlue,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.midnightTeal,
              ),
            ),
          ),
          Center(
            child: Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.midnightTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a stat card for the progress section
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.aliceBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.midnightTeal,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Build recent analyses section
  Widget _buildRecentAnalysesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Analyses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/posture'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentAnalyses.length,
            itemBuilder: (context, index) {
              final analysis = _recentAnalyses[index];
              return _buildAnalysisCard(analysis);
            },
          ),
        ),
      ],
    );
  }

  /// Build a single analysis card
  Widget _buildAnalysisCard(PostureAnalysisResult analysis) {
    // Format timestamp
    final now = DateTime.now();
    final difference = now.difference(analysis.timestamp);
    String timeAgo;
    
    if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}h ago';
    } else {
      timeAgo = '${difference.inDays}d ago';
    }
    
    // Determine color based on score
    Color scoreColor;
    if (analysis.overallScore >= 80) {
      scoreColor = AppColors.success;
    } else if (analysis.overallScore >= 60) {
      scoreColor = AppColors.info;
    } else if (analysis.overallScore >= 40) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.aliceBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.accessibility_new,
                  color: AppColors.midnightTeal,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${analysis.overallScore.round()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (analysis.issues.isNotEmpty)
            Text(
              analysis.issues.first.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          Text(
            analysis.generalFeedback,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build recommended exercises section
  Widget _buildRecommendedExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended Exercises',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/exercises'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recommendedExercises.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ExerciseCardWidget(
                exercise: _recommendedExercises[index],
                onTap: () {
                  // Navigate to exercise details
                  Navigator.pushNamed(
                    context,
                    '/exercises',
                    arguments: {'exerciseId': _recommendedExercises[index].id},
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}