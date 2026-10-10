// File: lib/widgets/camera_overlay_widget.dart
// Description: Widget that displays overlays on the camera feed for posture detection
// Author: PhysioConnect Team
// Date: April 9, 2025

import 'package:flutter/material.dart';
import '../models/posture_model.dart';
import '../config/app_colors.dart';

/// CameraOverlayWidget displays overlays on the camera feed for posture detection
class CameraOverlayWidget extends StatelessWidget {
  // Posture data
  final PostureSkeleton? skeleton;
  final List<PostureIssue> issues;
  final Size cameraPreviewSize;
  
  // Rendering options
  final bool showSkeleton;
  final bool showJointLabels;
  final bool highlightIssues;
  final double pointSize;
  final double lineWidth;
  
  const CameraOverlayWidget({
    super.key,
    this.skeleton,
    this.issues = const [],
    required this.cameraPreviewSize,
    this.showSkeleton = true,
    this.showJointLabels = false,
    this.highlightIssues = true,
    this.pointSize = 10.0,
    this.lineWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    if (skeleton == null) {
      return Container(); // No overlay if no skeleton
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate scaling factors to fit skeleton on the display
        final scaleX = constraints.maxWidth / cameraPreviewSize.width;
        final scaleY = constraints.maxHeight / cameraPreviewSize.height;
        
        return Stack(
          children: [
            // Draw the skeleton
            if (showSkeleton)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: SkeletonPainter(
                  skeleton: skeleton!,
                  issues: issues,
                  scaleX: scaleX,
                  scaleY: scaleY,
                  showJointLabels: showJointLabels,
                  highlightIssues: highlightIssues,
                  pointSize: pointSize,
                  lineWidth: lineWidth,
                ),
              ),
            
            // Ideal posture guide overlay (subtle transparent guide)
            if (highlightIssues && issues.isNotEmpty)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: PostureGuidePainter(
                  issues: issues,
                  skeleton: skeleton!,
                  scaleX: scaleX,
                  scaleY: scaleY,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Custom painter to draw the posture skeleton
class SkeletonPainter extends CustomPainter {
  final PostureSkeleton skeleton;
  final List<PostureIssue> issues;
  final double scaleX;
  final double scaleY;
  final bool showJointLabels;
  final bool highlightIssues;
  final double pointSize;
  final double lineWidth;
  
  SkeletonPainter({
    required this.skeleton,
    required this.issues,
    required this.scaleX,
    required this.scaleY,
    required this.showJointLabels,
    required this.highlightIssues,
    required this.pointSize,
    required this.lineWidth,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Default paint for skeleton
    final skeletonPaint = Paint()
      ..color = AppColors.midnightTeal
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    
    // Problem paint (for highlighting issues)
    final problemPaint = Paint()
      ..color = AppColors.error
      ..strokeWidth = lineWidth + 1
      ..style = PaintingStyle.stroke;
    
    // Draw connections between joints
    _drawSkeletonConnections(canvas, skeletonPaint, problemPaint);
    
    // Draw points and labels
    for (final point in skeleton.points) {
      // Scale the coordinates
      final x = point.x * scaleX;
      final y = point.y * scaleY;
      final center = Offset(x, y);
      
      // Check if this joint is part of an issue
      final isIssueJoint = highlightIssues && _isJointAffectedByIssue(point.name);
      
      // Draw the point
      Paint circlePaint = Paint()
        ..color = isIssueJoint ? AppColors.error : AppColors.midnightTeal
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        center,
        pointSize,
        circlePaint,
      );
      
      // Draw label if enabled
      if (showJointLabels) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: point.name,
            style: TextStyle(
              color: isIssueJoint ? AppColors.error : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y + pointSize + 4),
        );
      }
    }
  }
  
  /// Draw connections between skeleton joints
  void _drawSkeletonConnections(
    Canvas canvas, 
    Paint normalPaint, 
    Paint problemPaint
  ) {
    // Define connections between joints
    final connections = _getSkeletonConnections();
    
    // Draw each connection
    for (final connection in connections) {
      // Find the points
      final startPoint = _findPointByName(connection[0]);
      final endPoint = _findPointByName(connection[1]);
      
      if (startPoint != null && endPoint != null) {
        // Scale the coordinates
        final startOffset = Offset(
          startPoint.x * scaleX,
          startPoint.y * scaleY,
        );
        final endOffset = Offset(
          endPoint.x * scaleX,
          endPoint.y * scaleY,
        );
        
        // Check if this connection involves any joints with issues
        final hasIssue = highlightIssues && 
          (_isJointAffectedByIssue(startPoint.name) || 
           _isJointAffectedByIssue(endPoint.name));
        
        // Draw the line with appropriate color
        canvas.drawLine(
          startOffset,
          endOffset,
          hasIssue ? problemPaint : normalPaint,
        );
      }
    }
  }
  
  /// Find a point by name
  PosturePoint? _findPointByName(String name) {
    try {
      return skeleton.points.firstWhere((point) => point.name == name);
    } catch (e) {
      return null;
    }
  }
  
  /// Check if a joint is affected by any issues
  bool _isJointAffectedByIssue(String jointName) {
    for (final issue in issues) {
      if (issue.relatedJoints.contains(jointName)) {
        return true;
      }
    }
    return false;
  }
  
  /// Get connections between skeleton joints
  List<List<String>> _getSkeletonConnections() {
    return [
      // Head and neck
      ['Nose', 'Left Eye'],
      ['Nose', 'Right Eye'],
      ['Left Eye', 'Left Ear'],
      ['Right Eye', 'Right Ear'],
      ['Nose', 'Left Shoulder'],
      ['Nose', 'Right Shoulder'],
      
      // Shoulders
      ['Left Shoulder', 'Right Shoulder'],
      
      // Arms
      ['Left Shoulder', 'Left Elbow'],
      ['Left Elbow', 'Left Wrist'],
      ['Right Shoulder', 'Right Elbow'],
      ['Right Elbow', 'Right Wrist'],
      
      // Torso
      ['Left Shoulder', 'Left Hip'],
      ['Right Shoulder', 'Right Hip'],
      ['Left Hip', 'Right Hip'],
      
      // Legs
      ['Left Hip', 'Left Knee'],
      ['Left Knee', 'Left Ankle'],
      ['Right Hip', 'Right Knee'],
      ['Right Knee', 'Right Ankle'],
    ];
  }
  
  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) {
    return skeleton != oldDelegate.skeleton || 
           issues != oldDelegate.issues ||
           highlightIssues != oldDelegate.highlightIssues ||
           showJointLabels != oldDelegate.showJointLabels;
  }
}

/// Custom painter to draw posture guides
class PostureGuidePainter extends CustomPainter {
  final List<PostureIssue> issues;
  final PostureSkeleton skeleton;
  final double scaleX;
  final double scaleY;
  
  PostureGuidePainter({
    required this.issues,
    required this.skeleton,
    required this.scaleX,
    required this.scaleY,
  });
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    // Process each issue and draw appropriate guides
    for (final issue in issues) {
      switch (issue.id) {
        case 'forward_head_posture':
          _drawForwardHeadGuide(canvas, issue, canvasSize);
          break;
        case 'rounded_shoulders':
          _drawRoundedShoulderGuide(canvas, issue);
          break;
        // Add more issue types as needed
      }
    }
  }
  
  /// Draw guide for forward head posture
  void _drawForwardHeadGuide(Canvas canvas, PostureIssue issue, Size canvasSize) {
    final nosePoint = _findPointByName('Nose');
    final leftShoulderPoint = _findPointByName('Left Shoulder');
    final rightShoulderPoint = _findPointByName('Right Shoulder');
    
    if (nosePoint == null || leftShoulderPoint == null || rightShoulderPoint == null) {
      return;
    }
    
    // Calculate mid-shoulder point
    final midShoulderX = (leftShoulderPoint.x + rightShoulderPoint.x) / 2;
    // We need to calculate midShoulderY for vertical alignment
    
    // Draw vertical alignment line
    final paint = Paint()
      ..color = AppColors.aliceBlue.withAlpha(179)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;
    
    // Draw vertical alignment guide
    canvas.drawLine(
      Offset(midShoulderX * scaleX, 0),
      Offset(midShoulderX * scaleX, canvasSize.height),
      paint,
    );
    
    // Draw ideal position indicator
    final idealPaint = Paint()
      ..color = AppColors.success.withAlpha(128)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(midShoulderX * scaleX, nosePoint.y * scaleY * 0.95),
      15,
      idealPaint,
    );
  }
  
  /// Draw guide for rounded shoulders
  void _drawRoundedShoulderGuide(Canvas canvas, PostureIssue issue) {
    final leftShoulderPoint = _findPointByName('Left Shoulder');
    final rightShoulderPoint = _findPointByName('Right Shoulder');
    
    if (leftShoulderPoint == null || rightShoulderPoint == null) {
      return;
    }
    
    // Draw shoulder alignment guides
    final paint = Paint()
      ..color = AppColors.aliceBlue.withAlpha(179)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Draw arched guide for proper shoulder position
    final path = Path();
    path.moveTo(leftShoulderPoint.x * scaleX, leftShoulderPoint.y * scaleY);
    
    // Calculate control points for a more natural curve
    final midX = (leftShoulderPoint.x + rightShoulderPoint.x) / 2 * scaleX;
    final midY = ((leftShoulderPoint.y + rightShoulderPoint.y) / 2 - 20) * scaleY;
    
    path.quadraticBezierTo(
      midX, midY,
      rightShoulderPoint.x * scaleX, rightShoulderPoint.y * scaleY,
    );
    
    canvas.drawPath(path, paint);
    
    // Draw ideal position indicators
    final idealPaint = Paint()
      ..color = AppColors.success.withAlpha(128)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(leftShoulderPoint.x * scaleX, (leftShoulderPoint.y - 10) * scaleY),
      10,
      idealPaint,
    );
    
    canvas.drawCircle(
      Offset(rightShoulderPoint.x * scaleX, (rightShoulderPoint.y - 10) * scaleY),
      10,
      idealPaint,
    );
  }
  
  /// Find a point by name
  PosturePoint? _findPointByName(String name) {
    try {
      return skeleton.points.firstWhere((point) => point.name == name);
    } catch (e) {
      return null;
    }
  }
  
  @override
  bool shouldRepaint(covariant PostureGuidePainter oldDelegate) {
    return issues != oldDelegate.issues || skeleton != oldDelegate.skeleton;
  }
}