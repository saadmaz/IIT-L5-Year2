// File: frontend/lib/features/ehpr/widgets/record_timeline.dart

import 'package:flutter/material.dart';
import '../../../config/constants.dart';

class RecordTimeline extends StatelessWidget {
  const RecordTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample timeline events - in a real app, this would come from an API
    final timelineEvents = [
      {
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'title': 'Initial Assessment',
        'description': 'Initial evaluation for lower back pain',
        'type': 'assessment',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 28)),
        'title': 'Treatment Plan Created',
        'description': 'Core strengthening and mobility program',
        'type': 'treatment',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 21)),
        'title': 'Progress Note',
        'description': 'Improvement in range of motion',
        'type': 'progress',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 14)),
        'title': 'X-Ray Results',
        'description': 'No structural abnormalities detected',
        'type': 'document',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'title': 'Progress Note',
        'description': 'Pain reduced from 7/10 to 4/10',
        'type': 'progress',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: timelineEvents.length,
        itemBuilder: (context, index) {
          final event = timelineEvents[index];
          final isLast = index == timelineEvents.length - 1;

          return TimelineItem(
            date: event['date'] as DateTime,
            title: event['title'] as String,
            description: event['description'] as String,
            type: event['type'] as String,
            isLast: isLast,
          );
        },
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final DateTime date;
  final String title;
  final String description;
  final String type;
  final bool isLast;

  const TimelineItem({
    Key? key,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getTypeColor(),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),

          // Event content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.paddingSmall,
                bottom: AppDimensions.paddingMedium,
              ),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getTypeIcon(),
                            size: 16,
                            color: _getTypeColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case 'assessment':
        return Colors.blue;
      case 'treatment':
        return AppColors.midnightTeal;
      case 'progress':
        return Colors.amber;
      case 'document':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'assessment':
        return Icons.medical_services;
      case 'treatment':
        return Icons.healing;
      case 'progress':
        return Icons.trending_up;
      case 'document':
        return Icons.description;
      default:
        return Icons.event_note;
    }
  }
}
