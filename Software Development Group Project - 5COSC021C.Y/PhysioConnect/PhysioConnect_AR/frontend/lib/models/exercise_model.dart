// Description: Data models related to exercises

/// Exercise represents a physical exercise with instructions
class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final String targetArea;
  final List<String> imageUrls;
  final String videoUrl;
  final List<ExerciseStep> steps;
  final int recommendedSets;
  final int recommendedReps;
  final int recommendedDurationSeconds;
  final double difficultyLevel; // 1.0 to 5.0
  final List<String> targetPostureIssues;
  final bool isFavorite;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.targetArea,
    required this.imageUrls,
    required this.videoUrl,
    required this.steps,
    required this.recommendedSets,
    required this.recommendedReps,
    required this.recommendedDurationSeconds,
    required this.difficultyLevel,
    required this.targetPostureIssues,
    this.isFavorite = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      targetArea: json['targetArea'],
      imageUrls: List<String>.from(json['imageUrls']),
      videoUrl: json['videoUrl'],
      steps: (json['steps'] as List)
          .map((step) => ExerciseStep.fromJson(step))
          .toList(),
      recommendedSets: json['recommendedSets'],
      recommendedReps: json['recommendedReps'],
      recommendedDurationSeconds: json['recommendedDurationSeconds'],
      difficultyLevel: json['difficultyLevel'].toDouble(),
      targetPostureIssues: List<String>.from(json['targetPostureIssues']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'targetArea': targetArea,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'steps': steps.map((step) => step.toJson()).toList(),
      'recommendedSets': recommendedSets,
      'recommendedReps': recommendedReps,
      'recommendedDurationSeconds': recommendedDurationSeconds,
      'difficultyLevel': difficultyLevel,
      'targetPostureIssues': targetPostureIssues,
      'isFavorite': isFavorite,
    };
  }

  // Create a copy of this exercise with modified properties
  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? targetArea,
    List<String>? imageUrls,
    String? videoUrl,
    List<ExerciseStep>? steps,
    int? recommendedSets,
    int? recommendedReps,
    int? recommendedDurationSeconds,
    double? difficultyLevel,
    List<String>? targetPostureIssues,
    bool? isFavorite,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      targetArea: targetArea ?? this.targetArea,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      steps: steps ?? this.steps,
      recommendedSets: recommendedSets ?? this.recommendedSets,
      recommendedReps: recommendedReps ?? this.recommendedReps,
      recommendedDurationSeconds: recommendedDurationSeconds ?? this.recommendedDurationSeconds,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      targetPostureIssues: targetPostureIssues ?? this.targetPostureIssues,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// ExerciseStep represents a single step in an exercise
class ExerciseStep {
  final int stepNumber;
  final String instruction;
  final String? imageUrl;
  final int durationSeconds;

  ExerciseStep({
    required this.stepNumber,
    required this.instruction,
    this.imageUrl,
    required this.durationSeconds,
  });

  factory ExerciseStep.fromJson(Map<String, dynamic> json) {
    return ExerciseStep(
      stepNumber: json['stepNumber'],
      instruction: json['instruction'],
      imageUrl: json['imageUrl'],
      durationSeconds: json['durationSeconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'instruction': instruction,
      'imageUrl': imageUrl,
      'durationSeconds': durationSeconds,
    };
  }
}

/// ExerciseCategory represents a category of exercises
class ExerciseCategory {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int exerciseCount;

  ExerciseCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.exerciseCount,
  });

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    return ExerciseCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      exerciseCount: json['exerciseCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'exerciseCount': exerciseCount,
    };
  }
}