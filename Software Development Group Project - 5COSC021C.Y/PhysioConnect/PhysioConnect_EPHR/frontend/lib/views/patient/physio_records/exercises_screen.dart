import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';

/// Exercises Screen
/// Displays a library of prescribed exercises
/// Allows filtering by body part and status

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _exercises = [];
  Map<String, List<Map<String, dynamic>>> _exercisesByArea = {};
  String? _selectedArea;
  bool _showOnlyActive = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadExercises();
  }
  
  /// Load exercises from API
  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      // In a real app, these would come from API calls
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock exercises
      _exercises = [
        {
          'id': '1',
          'name': 'Pelvic Tilts',
          'description': 'Lie on your back with knees bent. Tighten your stomach muscles and flatten your back against the floor.',
          'repetitions': '10 reps, 3 sets',
          'frequency': 'Daily',
          'targetArea': 'Lower Back',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 2)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/pelvic-tilts',
          'isActive': true,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '5 minutes',
          'equipment': 'None',
          'imageUrl': 'assets/images/exercises/pelvic_tilts.jpg',
        },
        {
          'id': '2',
          'name': 'Cat-Cow Stretch',
          'description': 'Start on hands and knees. Alternate between arching and rounding your back.',
          'repetitions': '10 reps, 2 sets',
          'frequency': 'Daily',
          'targetArea': 'Lower Back, Core',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 2)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/cat-cow',
          'isActive': true,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '5 minutes',
          'equipment': 'None',
          'imageUrl': 'assets/images/exercises/cat_cow.jpg',
        },
        {
          'id': '3',
          'name': 'Piriformis Stretch',
          'description': 'Lie on your back. Cross one leg over the other and pull the knee toward your chest.',
          'repetitions': 'Hold for 30 seconds, 3 reps each side',
          'frequency': 'Daily',
          'targetArea': 'Hip, Lower Back',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 9)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/piriformis-stretch',
          'isActive': true,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '5 minutes',
          'equipment': 'None',
          'imageUrl': 'assets/images/exercises/piriformis_stretch.jpg',
        },
        {
          'id': '4',
          'name': 'Standing Hamstring Stretch',
          'description': 'Place heel on a low stool. Keep leg straight and lean forward from the hips.',
          'repetitions': 'Hold for 30 seconds, 3 reps each side',
          'frequency': '3 times per week',
          'targetArea': 'Hamstrings',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 16)),
          'assignedBy': 'Dr. Michael Chen',
          'videoUrl': 'https://example.com/exercises/hamstring-stretch',
          'isActive': false,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '5 minutes',
          'equipment': 'Stool or chair',
          'imageUrl': 'assets/images/exercises/hamstring_stretch.jpg',
        },
        {
          'id': '5',
          'name': 'Quadriceps Stretch',
          'description': 'Stand on one leg, pull the other foot toward your buttocks. Keep knees close together.',
          'repetitions': 'Hold for 30 seconds, 3 reps each side',
          'frequency': 'Daily',
          'targetArea': 'Quadriceps',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 9)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/quad-stretch',
          'isActive': true,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '5 minutes',
          'equipment': 'None',
          'imageUrl': 'assets/images/exercises/quad_stretch.jpg',
        },
        {
          'id': '6',
          'name': 'Glute Bridges',
          'description': 'Lie on your back with knees bent. Lift hips off the floor, squeezing glutes at the top.',
          'repetitions': '10 reps, 3 sets',
          'frequency': 'Daily',
          'targetArea': 'Glutes, Core',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 2)),
          'assignedBy': 'Dr. Sarah Johnson',
          'videoUrl': 'https://example.com/exercises/glute-bridges',
          'isActive': true,
          'difficultyLevel': 'Beginner',
          'estimatedDuration': '10 minutes',
          'equipment': 'None',
          'imageUrl': 'assets/images/exercises/glute_bridges.jpg',
        },
        {
          'id': '7',
          'name': 'Wall Slides',
          'description': 'Stand with back against wall. Slide down into squat position and back up.',
          'repetitions': '10 reps, 3 sets',
          'frequency': '3 times per week',
          'targetArea': 'Quadriceps, Glutes',
          'dateAssigned': DateTime.now().subtract(const Duration(days: 16)),
          'assignedBy': 'Dr. Michael Chen',
          'videoUrl': 'https://example.com/exercises/wall-slides',
          'isActive': false,
          'difficultyLevel': 'Intermediate',
          'estimatedDuration': '10 minutes',
          'equipment': 'Wall',
          'imageUrl': 'assets/images/exercises/wall_slides.jpg',
        },
      ];
      
      // Group exercises by target area
      _exercisesByArea = {};
      for (final exercise in _exercises) {
        final targetArea = exercise['targetArea'] as String;
        final areas = targetArea.split(', ');
        
        for (final area in areas) {
          if (!_exercisesByArea.containsKey(area)) {
            _exercisesByArea[area] = [];
          }
          _exercisesByArea[area]!.add(exercise);
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading exercises: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  /// Get filtered exercises based on current filters
  List<Map<String, dynamic>> _getFilteredExercises() {
    List<Map<String, dynamic>> filteredExercises = List.from(_exercises);
    
    // Filter by target area if selected
    if (_selectedArea != null) {
      filteredExercises = _exercisesByArea[_selectedArea]!;
    }
    
    // Filter by active status if enabled
    if (_showOnlyActive) {
      filteredExercises = filteredExercises
          .where((exercise) => exercise['isActive'] == true)
          .toList();
    }
    
    return filteredExercises;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Exercise Library',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : _error != null
              ? _buildErrorView()
              : _exercises.isEmpty
                  ? _buildEmptyView()
                  : _buildExerciseLibrary(),
    );
  }
  
  /// Build the error view
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $_error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadExercises,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build empty view
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No Exercises Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your prescribed exercises will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.appointments);
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('Book a Session'),
          ),
        ],
      ),
    );
  }
  
  /// Build exercise library
  Widget _buildExerciseLibrary() {
    final filteredExercises = _getFilteredExercises();
    
    return Column(
      children: [
        // Filters
        _buildFiltersBar(),
        
        // Results count
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Text(
                'Showing ${filteredExercises.length} exercises',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              if (filteredExercises.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedArea = null;
                      _showOnlyActive = true;
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset Filters'),
                ),
            ],
          ),
        ),
        
        // Exercise grid
        Expanded(
          child: filteredExercises.isEmpty
              ? _buildNoExercisesFoundView()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    return _buildExerciseCard(filteredExercises[index]);
                  },
                ),
        ),
      ],
    );
  }
  
  /// Build filters bar
  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.aliceBlue,
      child: Column(
        children: [
          // Target area filter
          Row(
            children: [
              const Text(
                'Target Area:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // All areas option
                      _buildAreaFilterChip('All', null),
                      
                      // Target area options
                      ..._exercisesByArea.keys.map((area) {
                        return _buildAreaFilterChip(area, area);
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Active only filter
          Row(
            children: [
              const Text(
                'Status:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Active Only'),
                selected: _showOnlyActive,
                onSelected: (selected) {
                  setState(() {
                    _showOnlyActive = selected;
                  });
                },
                selectedColor: AppTheme.midnightTeal.withOpacity(0.2),
                checkmarkColor: AppTheme.midnightTeal,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build area filter chip
  Widget _buildAreaFilterChip(String label, String? value) {
    final isSelected = _selectedArea == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedArea = selected ? value : null;
          });
        },
        selectedColor: AppTheme.midnightTeal.withOpacity(0.2),
        checkmarkColor: AppTheme.midnightTeal,
      ),
    );
  }
  
  /// Build no exercises found view
  Widget _buildNoExercisesFoundView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises match your filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filter settings',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedArea = null;
                _showOnlyActive = true;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
  
  /// Build an exercise card
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showExerciseDetailDialog(exercise);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: exercise['isActive']
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                exercise['isActive'] ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: exercise['isActive'] ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Exercise image placeholder
            Container(
              height: 80,
              width: double.infinity,
              color: AppTheme.aliceBlue,
              child: const Icon(
                Icons.fitness_center,
                color: AppTheme.midnightTeal,
                size: 40,
              ),
            ),
            
            // Exercise details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name
                  Text(
                    exercise['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Target area
                  Text(
                    'Target: ${exercise['targetArea']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Difficulty level
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        exercise['difficultyLevel'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Show exercise detail dialog
  void _showExerciseDetailDialog(Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(exercise['name']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: exercise['isActive']
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exercise['isActive'] ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: exercise['isActive'] ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Exercise image placeholder
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.aliceBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppTheme.midnightTeal,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Information rows
                _buildDetailRow('Target Area:', exercise['targetArea']),
                const SizedBox(height: 8),
                _buildDetailRow('Repetitions:', exercise['repetitions']),
                const SizedBox(height: 8),
                _buildDetailRow('Frequency:', exercise['frequency']),
                const SizedBox(height: 8),
                _buildDetailRow('Difficulty:', exercise['difficultyLevel']),
                const SizedBox(height: 8),
                _buildDetailRow('Duration:', exercise['estimatedDuration']),
                const SizedBox(height: 8),
                _buildDetailRow('Equipment:', exercise['equipment']),
                const SizedBox(height: 16),
                
                // Description
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(exercise['description']),
                const SizedBox(height: 16),
                
                // Assignment info
                _buildDetailRow(
                  'Assigned By:', 
                  exercise['assignedBy'],
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Date Assigned:', 
                  _formatDate(exercise['dateAssigned'] as DateTime),
                ),
                const SizedBox(height: 16),
                
                // Video link (would be a video player in a real app)
                if (exercise['videoUrl'] != null) ...[
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Launch video in a real app
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Video player not implemented'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Demo Video'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            // Track progress button
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Track progress functionality would be implemented in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Track progress functionality not implemented'),
                  ),
                );
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('Track Progress'),
            ),
            
            // Close button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  /// Build a detail row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}