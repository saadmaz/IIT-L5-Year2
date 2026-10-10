// File: lib/services/posture_detection_service.dart
// Description: Service for detecting and analyzing posture
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
// Replace google_ml_kit with the new specific pose detection package
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/posture_model.dart';
import '../config/app_config.dart';
import 'api_service.dart';

/// PostureDetectionService handles posture detection using ML Kit
class PostureDetectionService {
  // ML Kit pose detector - updated to use the new API
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.accurate,
    ),
  );
  
  // Camera controller
  CameraController? _cameraController;
  
  // Getter for camera controller
  CameraController? get cameraController => _cameraController;
  
  // Stream controllers
  final StreamController<PostureSkeleton> _skeletonStreamController =
      StreamController<PostureSkeleton>.broadcast();
  final StreamController<List<PostureIssue>> _issuesStreamController =
      StreamController<List<PostureIssue>>.broadcast();
  
  // Detection state
  bool _isRunning = false;
  Timer? _detectionTimer;
  
  // API service for server-side analysis
  final ApiService _apiService;
  
  // Constructor
  PostureDetectionService({required ApiService apiService})
      : _apiService = apiService;
  
  // Getters for streams
  Stream<PostureSkeleton> get skeletonStream => _skeletonStreamController.stream;
  Stream<List<PostureIssue>> get issuesStream => _issuesStreamController.stream;
  bool get isRunning => _isRunning;
  
  /// Initialize the camera for pose detection
  Future<void> initializeCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras available');
    }
    
    // Use front camera for posture detection
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    
    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);
    
    // Set optimal frame rate
    await _cameraController!.setFocusMode(FocusMode.auto);
    await _cameraController!.setExposureMode(ExposureMode.auto);
  }
  
  /// Start posture detection
  Future<void> startDetection() async {
    if (_isRunning) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      await initializeCamera();
    }
    
    _isRunning = true;
    
    // Start processing frames at regular intervals
    _detectionTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.postureDetectionIntervalMs),
      (timer) => _processCurrentFrame(),
    );
  }
  
  /// Stop posture detection
  Future<void> stopDetection() async {
    _isRunning = false;
    _detectionTimer?.cancel();
    _detectionTimer = null;
  }
  
  /// Process the current camera frame
  Future<void> _processCurrentFrame() async {
    if (!_isRunning || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    
    try {
      // Capture image from camera
      final image = await _cameraController!.takePicture();
      
      // Convert to InputImage format for ML Kit
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Process image with ML Kit
      final poses = await _poseDetector.processImage(inputImage);
      
      // Delete the temporary file
      File(image.path).deleteSync();
      
      if (poses.isEmpty) {
        return;
      }
      
      // Convert to our model
      final pose = poses.first;
      final skeleton = _convertToPostureSkeleton(pose);
      
      // Emit skeleton
      _skeletonStreamController.add(skeleton);
      
      // Analyze posture and find issues
      final issues = await _analyzePosture(skeleton);
      
      // Emit issues
      _issuesStreamController.add(issues);
      
    } catch (e) {
      print('Error processing frame: $e');
    }
  }
  
  /// Convert ML Kit pose to PostureSkeleton
  PostureSkeleton _convertToPostureSkeleton(Pose pose) {
    final points = <PosturePoint>[];
    
    // Map each landmark to a PosturePoint
    for (final landmark in pose.landmarks.entries) {
      points.add(
        PosturePoint(
          id: _getLandmarkTypeId(landmark.key),
          name: _getLandmarkName(landmark.key),
          x: landmark.value.x,
          y: landmark.value.y,
          confidence: landmark.value.likelihood,
        ),
      );
    }
    
    return PostureSkeleton(
      points: points,
      timestamp: DateTime.now(),
    );
  }
  
  /// Get the ID of a pose landmark
  int _getLandmarkTypeId(PoseLandmarkType type) {
    // Map landmark types to numeric IDs
    switch (type) {
      case PoseLandmarkType.nose: return 0;
      case PoseLandmarkType.leftEye: return 1;
      case PoseLandmarkType.rightEye: return 2;
      case PoseLandmarkType.leftEar: return 3;
      case PoseLandmarkType.rightEar: return 4;
      case PoseLandmarkType.leftShoulder: return 5;
      case PoseLandmarkType.rightShoulder: return 6;
      case PoseLandmarkType.leftElbow: return 7;
      case PoseLandmarkType.rightElbow: return 8;
      case PoseLandmarkType.leftWrist: return 9;
      case PoseLandmarkType.rightWrist: return 10;
      case PoseLandmarkType.leftHip: return 11;
      case PoseLandmarkType.rightHip: return 12;
      case PoseLandmarkType.leftKnee: return 13;
      case PoseLandmarkType.rightKnee: return 14;
      case PoseLandmarkType.leftAnkle: return 15;
      case PoseLandmarkType.rightAnkle: return 16;
      default: return -1;
    }
  }
  
  /// Get the name of a pose landmark
  String _getLandmarkName(PoseLandmarkType type) {
    switch (type) {
      case PoseLandmarkType.nose:
        return 'Nose';
      case PoseLandmarkType.leftEye:
        return 'Left Eye';
      case PoseLandmarkType.rightEye:
        return 'Right Eye';
      case PoseLandmarkType.leftEar:
        return 'Left Ear';
      case PoseLandmarkType.rightEar:
        return 'Right Ear';
      case PoseLandmarkType.leftShoulder:
        return 'Left Shoulder';
      case PoseLandmarkType.rightShoulder:
        return 'Right Shoulder';
      case PoseLandmarkType.leftElbow:
        return 'Left Elbow';
      case PoseLandmarkType.rightElbow:
        return 'Right Elbow';
      case PoseLandmarkType.leftWrist:
        return 'Left Wrist';
      case PoseLandmarkType.rightWrist:
        return 'Right Wrist';
      case PoseLandmarkType.leftHip:
        return 'Left Hip';
      case PoseLandmarkType.rightHip:
        return 'Right Hip';
      case PoseLandmarkType.leftKnee:
        return 'Left Knee';
      case PoseLandmarkType.rightKnee:
        return 'Right Knee';
      case PoseLandmarkType.leftAnkle:
        return 'Left Ankle';
      case PoseLandmarkType.rightAnkle:
        return 'Right Ankle';
      default:
        return 'Unknown';
    }
  }
  
  /// Analyze posture and identify issues
  Future<List<PostureIssue>> _analyzePosture(PostureSkeleton skeleton) async {
    // First perform local analysis
    final localIssues = _performLocalAnalysis(skeleton);
    
    // If available, also use server-side analysis
    try {
      final response = await _apiService.post(
        '/posture/analyze',
        body: skeleton.toJson(),
        fromJson: (json) {
          return (json['issues'] as List)
              .map((issue) => PostureIssue.fromJson(issue))
              .toList();
        },
      );
      
      if (response.isSuccess && response.data != null) {
        // Merge local and server issues, removing duplicates
        final serverIssues = response.data as List<PostureIssue>;
        final allIssues = [...localIssues];
        
        for (final serverIssue in serverIssues) {
          if (!allIssues.any((issue) => issue.id == serverIssue.id)) {
            allIssues.add(serverIssue);
          }
        }
        
        return allIssues;
      }
    } catch (e) {
      print('Error during server-side posture analysis: $e');
    }
    
    // Return local issues if server analysis fails
    return localIssues;
  }
  
  /// Perform local analysis of posture skeleton
  List<PostureIssue> _performLocalAnalysis(PostureSkeleton skeleton) {
    final issues = <PostureIssue>[];
    
    // Check for forward head posture
    final forwardHeadIssue = _checkForwardHeadPosture(skeleton);
    if (forwardHeadIssue != null) {
      issues.add(forwardHeadIssue);
    }
    
    // Check for rounded shoulders
    final roundedShouldersIssue = _checkRoundedShoulders(skeleton);
    if (roundedShouldersIssue != null) {
      issues.add(roundedShouldersIssue);
    }
    
    return issues;
  }
  
  /// Check for forward head posture
  PostureIssue? _checkForwardHeadPosture(PostureSkeleton skeleton) {
    // Find necessary points
    final nosePoint = _findPointByName(skeleton, 'Nose');
    final leftShoulderPoint = _findPointByName(skeleton, 'Left Shoulder');
    final rightShoulderPoint = _findPointByName(skeleton, 'Right Shoulder');
    
    // If any point is missing, return null
    if (nosePoint == null || leftShoulderPoint == null || rightShoulderPoint == null) {
      return null;
    }
    
    // Calculate mid-shoulder point
    final midShoulderX = (leftShoulderPoint.x + rightShoulderPoint.x) / 2;
    final midShoulderY = (leftShoulderPoint.y + rightShoulderPoint.y) / 2;
    
    // Calculate forward head angle
    final dx = nosePoint.x - midShoulderX;
    final dy = nosePoint.y - midShoulderY;
    final angle = dx / dy; // Simplified angle calculation
    
    // Determine severity based on angle
    double severity = 0.0;
    if (angle > 0.3) {
      severity = 0.8; // High severity
    } else if (angle > 0.2) {
      severity = 0.5; // Medium severity
    } else if (angle > 0.1) {
      severity = 0.2; // Low severity
    } else {
      return null; // No issue detected
    }
    
    // Create and return issue
    return PostureIssue(
      id: 'forward_head_posture',
      name: 'Forward Head Posture',
      description: 'Your head is positioned forward of your shoulders, which can strain your neck and upper back.',
      severity: severity,
      relatedJoints: ['Nose', 'Left Shoulder', 'Right Shoulder'],
      recommendation: 'Try chin tucks and neck stretches to improve head alignment.',
    );
  }
  
  /// Check for rounded shoulders
  PostureIssue? _checkRoundedShoulders(PostureSkeleton skeleton) {
    // Find necessary points
    final leftShoulderPoint = _findPointByName(skeleton, 'Left Shoulder');
    final rightShoulderPoint = _findPointByName(skeleton, 'Right Shoulder');
    final leftHipPoint = _findPointByName(skeleton, 'Left Hip');
    final rightHipPoint = _findPointByName(skeleton, 'Right Hip');
    
    // If any point is missing, return null
    if (leftShoulderPoint == null || rightShoulderPoint == null || 
        leftHipPoint == null || rightHipPoint == null) {
      return null;
    }
    
    // Calculate mid points
    final midShoulderZ = (leftShoulderPoint.y + rightShoulderPoint.y) / 2;
    final midHipZ = (leftHipPoint.y + rightHipPoint.y) / 2;
    
    // Calculate shoulder roundness by comparing Z-positions
    // Note: This is a simplification as ML Kit doesn't provide accurate depth
    final shoulderForwardness = midShoulderZ - midHipZ;
    
    // Determine severity based on shoulder position
    double severity = 0.0;
    if (shoulderForwardness > 15) {
      severity = 0.8; // High severity
    } else if (shoulderForwardness > 10) {
      severity = 0.5; // Medium severity
    } else if (shoulderForwardness > 5) {
      severity = 0.2; // Low severity
    } else {
      return null; // No issue detected
    }
    
    // Create and return issue
    return PostureIssue(
      id: 'rounded_shoulders',
      name: 'Rounded Shoulders',
      description: 'Your shoulders are rolling forward, which can lead to upper back and neck pain.',
      severity: severity,
      relatedJoints: ['Left Shoulder', 'Right Shoulder', 'Left Hip', 'Right Hip'],
      recommendation: 'Try chest stretches and rowing exercises to strengthen your upper back.',
    );
  }
  
  /// Find a point by name in the skeleton
  PosturePoint? _findPointByName(PostureSkeleton skeleton, String name) {
    try {
      return skeleton.points.firstWhere((point) => point.name == name);
    } catch (e) {
      return null;
    }
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await stopDetection();
    await _poseDetector.close();
    await _cameraController?.dispose();
    await _skeletonStreamController.close();
    await _issuesStreamController.close();
  }
}