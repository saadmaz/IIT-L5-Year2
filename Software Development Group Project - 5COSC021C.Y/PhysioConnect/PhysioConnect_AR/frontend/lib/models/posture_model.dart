// File: lib/models/posture_model.dart
// Description: Data models related to posture detection

// Remove the unused import: import 'dart:convert';
// Only add import statements when they're actually used

/// PosturePoint represents a single joint or landmark in posture detection
class PosturePoint {
  final int id;
  final String name;
  final double x;
  final double y;
  final double confidence;

  PosturePoint({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.confidence,
  });

  factory PosturePoint.fromJson(Map<String, dynamic> json) {
    return PosturePoint(
      id: json['id'],
      name: json['name'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      confidence: json['confidence'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'x': x,
      'y': y,
      'confidence': confidence,
    };
  }
}

/// PostureSkeleton represents the full posture skeleton with all detected points
class PostureSkeleton {
  final List<PosturePoint> points;
  final DateTime timestamp;

  PostureSkeleton({
    required this.points,
    required this.timestamp,
  });

  factory PostureSkeleton.fromJson(Map<String, dynamic> json) {
    // Add the dart:convert import here ONLY if you need to parse JSON strings
    // Otherwise, if you're already receiving Map<String, dynamic> objects, you don't need it
    return PostureSkeleton(
      points: (json['points'] as List)
          .map((point) => PosturePoint.fromJson(point))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// PostureIssue represents a specific posture problem detected
class PostureIssue {
  final String id;
  final String name;
  final String description;
  final double severity; // 0.0 to 1.0
  final List<String> relatedJoints;
  final String recommendation;

  PostureIssue({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
    required this.relatedJoints,
    required this.recommendation,
  });

  factory PostureIssue.fromJson(Map<String, dynamic> json) {
    return PostureIssue(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      severity: json['severity'].toDouble(),
      relatedJoints: List<String>.from(json['relatedJoints']),
      recommendation: json['recommendation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'severity': severity,
      'relatedJoints': relatedJoints,
      'recommendation': recommendation,
    };
  }
}

/// PostureAnalysisResult represents the complete result of a posture analysis
class PostureAnalysisResult {
  final String id;
  final DateTime timestamp;
  final PostureSkeleton skeleton;
  final List<PostureIssue> issues;
  final double overallScore; // 0.0 to 100.0
  final String generalFeedback;

  PostureAnalysisResult({
    required this.id,
    required this.timestamp,
    required this.skeleton,
    required this.issues,
    required this.overallScore,
    required this.generalFeedback,
  });

  factory PostureAnalysisResult.fromJson(Map<String, dynamic> json) {
    return PostureAnalysisResult(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      skeleton: PostureSkeleton.fromJson(json['skeleton']),
      issues: (json['issues'] as List)
          .map((issue) => PostureIssue.fromJson(issue))
          .toList(),
      overallScore: json['overallScore'].toDouble(),
      generalFeedback: json['generalFeedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'skeleton': skeleton.toJson(),
      'issues': issues.map((issue) => issue.toJson()).toList(),
      'overallScore': overallScore,
      'generalFeedback': generalFeedback,
    };
  }
}