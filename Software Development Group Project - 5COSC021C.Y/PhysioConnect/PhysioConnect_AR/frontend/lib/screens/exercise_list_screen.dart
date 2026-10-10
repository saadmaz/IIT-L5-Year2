// File: lib/screens/exercise_list_screen.dart
// Description: Screen for displaying and filtering exercises
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/exercise_model.dart';
import '../widgets/exercise_card_widget.dart';

/// ExerciseListScreen displays a filterable list of exercises
class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  // Filter state
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  
  // Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Mock data
  late List<Exercise> _exercises;
  late List<ExerciseCategory> _categories;
  
  // Filtered exercises
  List<Exercise> get _filteredExercises {
    return _exercises.where((exercise) {
      // Apply category filter
      if (_selectedCategory != 'All' && exercise.category != _selectedCategory) {
        return false;
      }
      
      // Apply difficulty filter
      if (_selectedDifficulty != 'All') {
        final difficultyValue = _getDifficultyValue(_selectedDifficulty);
        if (exercise.difficultyLevel < difficultyValue - 1 || 
            exercise.difficultyLevel >= difficultyValue) {
          return false;
        }
      }
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return exercise.name.toLowerCase().contains(query) || 
               exercise.description.toLowerCase().contains(query) ||
               exercise.targetArea.toLowerCase().contains(query);
      }
      
      return true;
    }).toList();
  }
  
  @override
  void initState() {
    super.initState();
    _loadMockData();
    
    // Listen for search changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    
    // Check for route arguments (for specific issue filter)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRouteArguments();
    });
  }
  
  /// Check route arguments for filtering
  void _checkRouteArguments() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final issueId = arguments['issueId'] as String?;
      if (issueId != null) {
        // Filter exercises for this issue
        setState(() {
          _exercises = _exercises.where((e) => 
            e.targetPostureIssues.contains(issueId)).toList();
        });
      }
      
      final exerciseId = arguments['exerciseId'] as String?;
      if (exerciseId != null) {
        // Show exercise details
        _showExerciseDetails(_exercises.firstWhere((e) => e.id == exerciseId));
      }
    }
  }
  
  /// Load mock exercise data
  void _loadMockData() {
    // Load exercise categories
    _categories = [
      ExerciseCategory(
        id: 'neck',
        name: 'Neck',
        description: 'Exercises for neck muscles and alignment',
        iconUrl: 'assets/icons/neck.png',
        exerciseCount: 8,
      ),
      ExerciseCategory(
        id: 'shoulders',
        name: 'Shoulders',
        description: 'Exercises for shoulder strength and posture',
        iconUrl: 'assets/icons/shoulders.png',
        exerciseCount: 12,
      ),
      ExerciseCategory(
        id: 'back',
        name: 'Back',
        description: 'Exercises for back strength and pain relief',
        iconUrl: 'assets/icons/back.png',
        exerciseCount: 15,
      ),
      ExerciseCategory(
        id: 'core',
        name: 'Core',
        description: 'Exercises for core stability and strength',
        iconUrl: 'assets/icons/core.png',
        exerciseCount: 10,
      ),
    ];
    
    // Load exercises
    _exercises = [
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
        name: 'Shoulder Blade Squeezes',
        description: 'Strengthen upper back and improve posture',
        category: 'Shoulders',
        targetArea: 'Upper Back',
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
      Exercise(
        id: '3',
        name: 'Thoracic Extension',
        description: 'Improve mobility in the mid-back',
        category: 'Back',
        targetArea: 'Mid Back',
        imageUrls: ['assets/images/exercises/thoracic_extension.jpg'],
        videoUrl: 'https://example.com/videos/thoracic_extension.mp4',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            instruction: 'Sit on a chair with a rolled towel placed horizontally across your mid-back',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 2,
            instruction: 'Gently arch backward over the towel',
            durationSeconds: 10,
          ),
          ExerciseStep(
            stepNumber: 3,
            instruction: 'Return to the starting position and repeat',
            durationSeconds: 0,
          ),
        ],
        recommendedSets: 2,
        recommendedReps: 8,
        recommendedDurationSeconds: 0,
        difficultyLevel: 2.5,
        targetPostureIssues: ['kyphosis'],
      ),
      Exercise(
        id: '4',
        name: 'Wall Angels',
        description: 'Improve shoulder mobility and posture',
        category: 'Shoulders',
        targetArea: 'Shoulders, Upper Back',
        imageUrls: ['assets/images/exercises/wall_angels.jpg'],
        videoUrl: 'https://example.com/videos/wall_angels.mp4',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            instruction: 'Stand with your back against a wall, feet about 6 inches from the wall',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 2,
            instruction: 'Place arms against the wall in a "W" position',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 3,
            instruction: 'Slide arms up the wall to a "Y" position while keeping contact with the wall',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 4,
            instruction: 'Return to the "W" position and repeat',
            durationSeconds: 0,
          ),
        ],
        recommendedSets: 3,
        recommendedReps: 8,
        recommendedDurationSeconds: 0,
        difficultyLevel: 3.0,
        targetPostureIssues: ['rounded_shoulders', 'forward_head_posture'],
      ),
      Exercise(
        id: '5',
        name: 'Plank',
        description: 'Strengthen core for better posture support',
        category: 'Core',
        targetArea: 'Core, Shoulders',
        imageUrls: ['assets/images/exercises/plank.jpg'],
        videoUrl: 'https://example.com/videos/plank.mp4',
        steps: [
          ExerciseStep(
            stepNumber: 1,
            instruction: 'Start in push-up position with forearms on the ground',
            durationSeconds: 0,
          ),
          ExerciseStep(
            stepNumber: 2,
            instruction: 'Keep your body in a straight line from head to heels',
            durationSeconds: 30,
          ),
          ExerciseStep(
            stepNumber: 3,
            instruction: 'Rest and repeat',
            durationSeconds: 0,
          ),
        ],
        recommendedSets: 3,
        recommendedReps: 1,
        recommendedDurationSeconds: 30,
        difficultyLevel: 3.5,
        targetPostureIssues: ['anterior_pelvic_tilt', 'weak_core'],
      ),
    ];
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          'Exercises',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.midnightTeal,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          _buildCategoriesRow(),
          Expanded(
            child: _filteredExercises.isEmpty
                ? _buildEmptyState()
                : _buildExerciseList(),
          ),
        ],
      ),
    );
  }
  
  /// Build search bar and filter buttons
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.midnightTeal,
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter buttons row
          Row(
            children: [
              // Difficulty filter
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Difficulty',
                  value: _selectedDifficulty,
                  items: const ['All', 'Beginner', 'Intermediate', 'Advanced'],
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Category filter
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Category',
                  value: _selectedCategory,
                  items: ['All', ..._categories.map((c) => c.name)],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build filter dropdown
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.midnightTeal),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
  
  /// Build horizontal category row
  Widget _buildCategoriesRow() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.aliceBlue,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category.name;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? 'All' : category.name;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.midnightTeal : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.white.withOpacity(0.2) 
                          : AppColors.aliceBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      color: isSelected ? AppColors.white : AppColors.midnightTeal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${category.exerciseCount} exercises',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected 
                          ? AppColors.white.withOpacity(0.8) 
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// Build exercise list
  Widget _buildExerciseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = _filteredExercises[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ExerciseCardWidget(
            exercise: exercise,
            onTap: () => _showExerciseDetails(exercise),
          ),
        );
      },
    );
  }
  
  /// Build empty state when no exercises match the filters
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No exercises found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or search query',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Reset filters
              setState(() {
                _selectedCategory = 'All';
                _selectedDifficulty = 'All';
                _searchController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midnightTeal,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
  
  /// Show exercise details in a modal bottom sheet
  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Handle indicator
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header with exercise image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.aliceBlue,
                      image: exercise.imageUrls.isNotEmpty
                          ? DecorationImage(
                              image: AssetImage(exercise.imageUrls.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: exercise.imageUrls.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 64,
                              color: AppColors.midnightTeal.withOpacity(0.5),
                            ),
                          )
                        : null,
                  ),
                  // Exercise details
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Title and difficulty
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            _buildDifficultyBadge(exercise.difficultyLevel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Category and target area
                        Row(
                          children: [
                            _buildPillTag(
                              text: exercise.category,
                              icon: _getCategoryIcon(exercise.category),
                            ),
                            const SizedBox(width: 8),
                            _buildPillTag(
                              text: exercise.targetArea,
                              icon: Icons.accessibility_new,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          exercise.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Exercise details card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.aliceBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (exercise.recommendedSets > 0)
                                _buildExerciseDetailItem(
                                  icon: Icons.repeat,
                                  label: 'Sets',
                                  value: '${exercise.recommendedSets}',
                                ),
                              if (exercise.recommendedReps > 0)
                                _buildExerciseDetailItem(
                                  icon: Icons.fitness_center,
                                  label: 'Reps',
                                  value: '${exercise.recommendedReps}',
                                ),
                              if (exercise.recommendedDurationSeconds > 0)
                                _buildExerciseDetailItem(
                                  icon: Icons.timer,
                                  label: 'Duration',
                                  value: _formatDuration(exercise.recommendedDurationSeconds),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Steps header
                        const Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Steps list
                        ...exercise.steps.map((step) => _buildStepItem(step)),
                        const SizedBox(height: 32),
                        // Start button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement exercise start functionality
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Exercise started'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.midnightTeal,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Start Exercise',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  /// Build exercise step item
  Widget _buildStepItem(ExerciseStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: AppColors.midnightTeal,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step.stepNumber}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.instruction,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (step.durationSeconds > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Hold for ${_formatDuration(step.durationSeconds)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.midnightTeal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build exercise detail item
  Widget _buildExerciseDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.midnightTeal,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  /// Build pill-shaped tag
  Widget _buildPillTag({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.aliceBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.midnightTeal.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.midnightTeal,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.midnightTeal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build difficulty badge
  Widget _buildDifficultyBadge(double difficultyLevel) {
    String difficultyText;
    Color difficultyColor;
    
    if (difficultyLevel <= 2) {
      difficultyText = 'Beginner';
      difficultyColor = AppColors.success;
    } else if (difficultyLevel <= 3.5) {
      difficultyText = 'Intermediate';
      difficultyColor = AppColors.info;
    } else {
      difficultyText = 'Advanced';
      difficultyColor = AppColors.error;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: difficultyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficultyText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: difficultyColor,
        ),
      ),
    );
  }
  
  /// Get icon for exercise category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Neck':
        return Icons.height;
      case 'Shoulders':
        return Icons.accessibility;
      case 'Back':
        return Icons.airline_seat_flat;
      case 'Core':
        return Icons.fitness_center;
      default:
        return Icons.sports_gymnastics;
    }
  }
  
  /// Format seconds to mm:ss or simply "x seconds"
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '$seconds sec';
    }
  }
  
  /// Get difficulty level value (1-5) from string
  double _getDifficultyValue(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return 2.0;
      case 'Intermediate':
        return 4.0;
      case 'Advanced':
        return 5.0;
      default:
        return 0.0;
    }
  }
}