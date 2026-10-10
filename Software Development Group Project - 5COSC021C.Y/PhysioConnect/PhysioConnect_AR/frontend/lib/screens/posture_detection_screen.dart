// lib/screens/posture_detection_screen.dart
// Screen for real-time posture detection and feedback

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart'; // Added for permission handling
import '../models/posture_model.dart';
import '../services/posture_detection_service.dart';
import '../services/api_service.dart';
import '../widgets/camera_overlay_widget.dart';
import '../widgets/posture_feedback_widget.dart';
import '../config/app_colors.dart';
import '../config/app_config.dart';

/// PostureDetectionScreen provides real-time posture analysis
class PostureDetectionScreen extends StatefulWidget {
  const PostureDetectionScreen({super.key});

  @override
  State<PostureDetectionScreen> createState() => _PostureDetectionScreenState();
}

class _PostureDetectionScreenState extends State<PostureDetectionScreen>
    with WidgetsBindingObserver {
  // Services
  late final PostureDetectionService _postureService;

  // State
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  PostureSkeleton? _currentSkeleton;
  List<PostureIssue> _currentIssues = [];
  double _overallScore = 100.0;
  bool _showFeedback = false;
  bool _showGuides = true;
  Size _previewSize = const Size(1, 1);

  // Stream subscriptions
  StreamSubscription<PostureSkeleton>? _skeletonSubscription;
  StreamSubscription<List<PostureIssue>>? _issuesSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize services
    _initializeServices();

    // Request camera permission using permission_handler
    _checkAndRequestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes to manage camera resource
    if (state == AppLifecycleState.inactive) {
      _postureService.stopDetection();
    } else if (state == AppLifecycleState.resumed) {
      if (_isCameraPermissionGranted) {
        _postureService.startDetection();
      } else {
        // Re-check permission when app is resumed
        _checkAndRequestCameraPermission();
      }
    }
  }

  /// Initialize the posture detection service
  Future<void> _initializeServices() async {
    try {
      // Create ApiService instance first
      final apiService = ApiService();

      // Initialize PostureDetectionService with apiService
      _postureService = PostureDetectionService(apiService: apiService);

      // Subscribe to skeleton updates - using null check since we're initializing late
      _skeletonSubscription = _postureService.skeletonStream.listen((skeleton) {
        if (mounted) {
          setState(() {
            _currentSkeleton = skeleton;

            // Update preview size first time we get a skeleton
            if (_previewSize == const Size(1, 1)) {
              _updatePreviewSize();
            }
          });
        }
      });

      // Subscribe to posture issues
      _issuesSubscription = _postureService.issuesStream.listen((issues) {
        if (mounted) {
          setState(() {
            _currentIssues = issues;

            // Calculate overall score based on issues
            _calculateOverallScore();
          });
        }
      });

      print("Services initialized successfully");
    } catch (e) {
      print("Error initializing services: $e");
    }
  }

  /// Check and request camera permission using permission_handler
  Future<void> _checkAndRequestCameraPermission() async {
    // First check the permission status
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // Permission is already granted, initialize camera
      _initializeCamera();
    } else if (status.isDenied) {
      // Permission is denied but can be requested
      final result = await Permission.camera.request();

      if (result.isGranted) {
        // User granted permission
        _initializeCamera();
      } else {
        // User denied permission
        if (mounted) {
          setState(() {
            _isCameraPermissionGranted = false;
            _isCameraInitialized = false;
          });

          _showPermissionErrorDialog(
            isPermanentlyDenied: result.isPermanentlyDenied,
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, direct user to settings
      if (mounted) {
        setState(() {
          _isCameraPermissionGranted = false;
          _isCameraInitialized = false;
        });

        _showPermissionErrorDialog(isPermanentlyDenied: true);
      }
    }
  }

  /// Initialize camera after permission is granted
  Future<void> _initializeCamera() async {
    try {
      print("Initializing camera...");
      await _postureService.initializeCamera();

      if (mounted) {
        setState(() {
          _isCameraPermissionGranted = true;
          _isCameraInitialized = true;
        });

        // Start detection after camera is initialized
        _postureService.startDetection();
      }

      print("Camera initialized successfully");
    } catch (e) {
      print("Error initializing camera: $e");
      if (mounted) {
        setState(() {
          _isCameraPermissionGranted = false;
          _isCameraInitialized = false;
        });

        // Show camera error dialog
        _showCameraErrorDialog("$e");
      }
    }
  }

  /// Show error dialog for camera permission
  void _showPermissionErrorDialog({bool isPermanentlyDenied = false}) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: Text(
              isPermanentlyDenied
                  ? 'PhysioConnect needs camera access to analyze your posture. '
                      'Please enable camera permission in your device settings.'
                  : 'PhysioConnect needs camera access to analyze your posture. '
                      'Without this permission, posture detection cannot function.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  if (isPermanentlyDenied) {
                    // Open app settings if permanently denied
                    openAppSettings();
                  } else {
                    // Try requesting permission again
                    _checkAndRequestCameraPermission();
                  }
                },
                child: Text(
                  isPermanentlyDenied ? 'Open Settings' : 'Try Again',
                ),
              ),
            ],
          ),
    );
  }

  /// Show error dialog for camera initialization failures
  void _showCameraErrorDialog(String errorMessage) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Camera Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'There was an error initializing the camera. This could be due to:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Another app using the camera'),
                const Text('• Hardware camera issues'),
                const Text('• Insufficient system resources'),
                const SizedBox(height: 16),
                const Text('Error details:'),
                Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initializeCamera(); // Try initializing again
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
    );
  }

  /// Update the preview size to match the camera preview
  void _updatePreviewSize() {
    if (_postureService.isRunning && _currentSkeleton != null) {
      // Find the extreme points from the skeleton to estimate the preview size
      double minX = double.infinity;
      double minY = double.infinity;
      double maxX = 0;
      double maxY = 0;

      for (final point in _currentSkeleton!.points) {
        if (point.x < minX) minX = point.x;
        if (point.y < minY) minY = point.y;
        if (point.x > maxX) maxX = point.x;
        if (point.y > maxY) maxY = point.y;
      }

      // Calculate size with a safety margin
      _previewSize = Size(maxX * 1.2, maxY * 1.2);
    }
  }

  /// Calculate overall posture score based on issues
  void _calculateOverallScore() {
    if (_currentIssues.isEmpty) {
      _overallScore = 100.0;
      return;
    }

    // Calculate score by subtracting severity percentages
    double totalDeduction = 0;
    for (final issue in _currentIssues) {
      totalDeduction +=
          issue.severity * 40; // Each issue can deduct up to 40 points
    }

    // Ensure score is between 0 and 100
    _overallScore = 100 - totalDeduction;
    if (_overallScore < 0) _overallScore = 0;
    if (_overallScore > 100) _overallScore = 100;
  }

  /// Toggle feedback panel visibility
  void _toggleFeedback() {
    setState(() {
      _showFeedback = !_showFeedback;
    });
  }

  /// Toggle posture guides visibility
  void _toggleGuides() {
    setState(() {
      _showGuides = !_showGuides;
    });
  }

  /// Handle exercise selection
  void _onExerciseSelected(String issueId) {
    // Navigate to exercise screen for this issue
    Navigator.pushNamed(context, '/exercises', arguments: {'issueId': issueId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          'Posture Analysis',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.midnightTeal,
        elevation: 0,
        actions: [
          // Toggle guides button
          IconButton(
            icon: Icon(
              _showGuides ? Icons.visibility : Icons.visibility_off,
              color: AppColors.white,
            ),
            onPressed: _toggleGuides,
            tooltip: 'Toggle Posture Guides',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFeedback,
        backgroundColor: AppColors.midnightTeal,
        child: Icon(
          _showFeedback ? Icons.close : Icons.feedback_outlined,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// Build the main body of the screen
  Widget _buildBody() {
    if (!_isCameraPermissionGranted) {
      return _buildPermissionRequest();
    }

    if (!_isCameraInitialized) {
      return _buildLoadingIndicator();
    }

    return Stack(
      children: [
        // Camera preview
        _buildCameraPreview(),

        // Posture overlay
        _buildPostureOverlay(),

        // Feedback panel (conditional)
        if (_showFeedback) _buildFeedbackPanel(),
      ],
    );
  }

  /// Build the camera permission request widget
  Widget _buildPermissionRequest() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt, size: 80, color: AppColors.midnightTeal),
          const SizedBox(height: 24),
          const Text(
            'Camera Permission Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'PhysioConnect needs camera access to analyze your posture.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _checkAndRequestCameraPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midnightTeal,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Grant Permission',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.midnightTeal),
          SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Build camera preview widget
  Widget _buildCameraPreview() {
    return Container(
      color: AppColors.backgroundPrimary,
      child: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // Typical portrait aspect ratio
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                _postureService.cameraController != null &&
                        _postureService.cameraController!.value.isInitialized
                    ? CameraPreview(_postureService.cameraController!)
                    : Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'Camera not available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  /// Build posture overlay widget
  Widget _buildPostureOverlay() {
    if (_currentSkeleton == null) {
      return Container();
    }

    return IgnorePointer(
      ignoring: true,
      child: CameraOverlayWidget(
        skeleton: _currentSkeleton,
        issues: _currentIssues,
        cameraPreviewSize: _previewSize,
        showSkeleton: true,
        showJointLabels: false,
        highlightIssues: _showGuides,
        pointSize: 8.0,
        lineWidth: 2.0,
      ),
    );
  }

  /// Build feedback panel widget
  Widget _buildFeedbackPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: PostureFeedbackWidget(
          issues: _currentIssues,
          overallScore: _overallScore,
          onExerciseSelected: _onExerciseSelected,
          enableHaptic: AppConfig.enableHapticFeedback,
          enableSound: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose resources
    _skeletonSubscription?.cancel();
    _issuesSubscription?.cancel();
    _postureService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
