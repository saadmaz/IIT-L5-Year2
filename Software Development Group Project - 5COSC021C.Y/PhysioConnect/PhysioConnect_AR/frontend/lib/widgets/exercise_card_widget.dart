// File: lib/widgets/exercise_card_widget.dart
// Description: Widget for displaying exercise cards
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../config/app_colors.dart';

/// ExerciseCardWidget displays an exercise in a card format
class ExerciseCardWidget extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final bool showDetails;
  
  const ExerciseCardWidget({
    Key? key,
    required this.exercise,
    this.onTap,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            _buildExerciseImage(),
            const SizedBox(width: 16),
            Expanded(
              child: _buildExerciseInfo(),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build exercise image or placeholder
  Widget _buildExerciseImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.aliceBlue,
        borderRadius: BorderRadius.circular(8),
        image: exercise.imageUrls.isNotEmpty
            ? DecorationImage(
                image: AssetImage(exercise.imageUrls.first),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: exercise.imageUrls.isEmpty
          ? Icon(
              Icons.fitness_center,
              color: AppColors.midnightTeal.withOpacity(0.5),
              size: 32,
            )
          : null,
    );
  }
  
  /// Build exercise information
  Widget _buildExerciseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDifficultyLabel(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          exercise.description,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (showDetails) ...[
          const SizedBox(height: 8),
          _buildExerciseDetails(),
        ],
      ],
    );
  }
  
  /// Build exercise difficulty label
  Widget _buildDifficultyLabel() {
    String difficultyText;
    Color difficultyColor;
    
    if (exercise.difficultyLevel <= 2) {
      difficultyText = 'Easy';
      difficultyColor = AppColors.success;
    } else if (exercise.difficultyLevel <= 3.5) {
      difficultyText = 'Medium';
      difficultyColor = AppColors.info;
    } else {
      difficultyText = 'Hard';
      difficultyColor = AppColors.error;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: difficultyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficultyText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: difficultyColor,
        ),
      ),
    );
  }
  
  /// Build exercise details (sets, reps, duration)
  Widget _buildExerciseDetails() {
    return Row(
      children: [
        if (exercise.recommendedSets > 0) ...[
          _buildDetailItem(
            Icons.repeat,
            '${exercise.recommendedSets} sets',
          ),
          const SizedBox(width: 12),
        ],
        if (exercise.recommendedReps > 0) ...[
          _buildDetailItem(
            Icons.fitness_center,
            '${exercise.recommendedReps} reps',
          ),
          const SizedBox(width: 12),
        ],
        if (exercise.recommendedDurationSeconds > 0)
          _buildDetailItem(
            Icons.timer,
            _formatDuration(exercise.recommendedDurationSeconds),
          ),
      ],
    );
  }
  
  /// Build a single detail item
  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.midnightTeal,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  /// Format seconds to mm:ss
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '$seconds sec';
    }
  }
}