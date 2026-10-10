// File: lib/widgets/posture_feedback_widget.dart
// Description: Widget that displays posture feedback to the user
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/posture_model.dart';
import '../config/app_colors.dart';

/// PostureFeedbackWidget displays real-time feedback on posture issues
class PostureFeedbackWidget extends StatelessWidget {
  final List<PostureIssue> issues;
  final double overallScore;
  final Function(String) onExerciseSelected;
  final bool enableHaptic;
  final bool enableSound;

  const PostureFeedbackWidget({
    Key? key,
    required this.issues,
    required this.overallScore,
    required this.onExerciseSelected,
    this.enableHaptic = true,
    this.enableSound = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide haptic feedback based on issues
    _provideHapticFeedback();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreHeader(),
          const SizedBox(height: 16),
          _buildIssuesList(),
          if (issues.isNotEmpty) _buildRecommendationsButton(),
        ],
      ),
    );
  }

  /// Build the score header with posture quality indicator
  Widget _buildScoreHeader() {
    // Determine color based on score
    Color scoreColor;
    String scoreLabel;

    if (overallScore >= 80) {
      scoreColor = AppColors.success;
      scoreLabel = 'Excellent';
    } else if (overallScore >= 60) {
      scoreColor = AppColors.info;
      scoreLabel = 'Good';
    } else if (overallScore >= 40) {
      scoreColor = AppColors.warning;
      scoreLabel = 'Fair';
    } else {
      scoreColor = AppColors.error;
      scoreLabel = 'Poor';
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Posture Score',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scoreLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: scoreColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scoreColor.withOpacity(0.1),
            border: Border.all(color: scoreColor, width: 3),
          ),
          child: Center(
            child: Text(
              '${overallScore.toInt()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build list of detected posture issues
  Widget _buildIssuesList() {
    if (issues.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Great posture! Keep it up.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Issues Detected',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...issues.map(_buildIssueItem).toList(),
      ],
    );
  }

  /// Build a single issue item
  Widget _buildIssueItem(PostureIssue issue) {
    // Determine severity color and icon
    Color severityColor;
    IconData severityIcon;

    if (issue.severity > 0.7) {
      severityColor = AppColors.error;
      severityIcon = Icons.error_outline;
    } else if (issue.severity > 0.3) {
      severityColor = AppColors.warning;
      severityIcon = Icons.warning_amber_rounded;
    } else {
      severityColor = AppColors.info;
      severityIcon = Icons.info_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(severityIcon, color: severityColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  issue.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(issue.severity * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            issue.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recommendation: ${issue.recommendation}',
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build recommendations button
  Widget _buildRecommendationsButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onExerciseSelected(issues.first.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midnightTeal,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'View Recommended Exercises',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Provide haptic feedback based on posture issues
  void _provideHapticFeedback() {
    if (!enableHaptic || issues.isEmpty) return;

    // Find the highest severity issue
    final highestSeverity = issues.map((i) => i.severity).reduce(
        (value, element) => value > element ? value : element);

    // Provide feedback based on severity
    if (highestSeverity > 0.7) {
      HapticFeedback.heavyImpact();
    } else if (highestSeverity > 0.3) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }
}