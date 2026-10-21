import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

/// Alerts panel widget for displaying alerts and reminders on the dashboard
/// Used for upcoming appointments, medication reminders, etc.

class AlertsPanel extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;
  
  const AlertsPanel({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: alerts.map((alert) => _buildAlertItem(context, alert)).toList(),
        ),
      ),
    );
  }
  
  /// Build a single alert item
  Widget _buildAlertItem(BuildContext context, Map<String, dynamic> alert) {
    // Determine icon and color based on alert type and severity
    IconData icon;
    Color color;
    
    // Alert type
    switch (alert['type']) {
      case 'appointment':
        icon = Icons.event;
        break;
      case 'medication':
        icon = Icons.medication;
        break;
      case 'report':
        icon = Icons.description;
        break;
      default:
        icon = Icons.notifications;
    }
    
    // Alert severity
    switch (alert['severity']) {
      case 'critical':
        color = Colors.red;
        break;
      case 'warning':
        color = Colors.orange;
        break;
      case 'info':
      default:
        color = AppTheme.midnightTeal;
    }
    
    // Format date
    String formattedDate = '';
    if (alert['date'] != null) {
      final date = alert['date'] as DateTime;
      final now = DateTime.now();
      final difference = date.difference(now);
      
      if (difference.inDays == 0) {
        if (date.day == now.day) {
          formattedDate = 'Today';
        } else {
          formattedDate = 'Tomorrow';
        }
      } else if (difference.inDays > 0 && difference.inDays < 7) {
        final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        formattedDate = dayNames[date.weekday - 1];
      } else {
        formattedDate = '${date.day}/${date.month}/${date.year}';
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // Alert message and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['message'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (formattedDate.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
}