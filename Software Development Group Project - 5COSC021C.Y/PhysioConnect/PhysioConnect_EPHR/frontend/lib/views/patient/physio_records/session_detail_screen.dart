import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_bar.dart';

/// Session Detail Screen
/// Shows detailed information about a physiotherapy session
/// Includes session notes, progress, recommendations, and exercises

class SessionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> session;
  
  const SessionDetailScreen({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final date = widget.session['date'] as DateTime;
    final duration = widget.session['duration'] as int;
    
    return Scaffold(
      appBar: EPHRAppBar(
        title: widget.session['type'],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session header
            _buildSessionHeader(date, duration),
            const SizedBox(height: 24),
            
            // Session notes
            _buildDetailSection(
              title: 'Session Notes',
              icon: Icons.notes,
              child: _buildSessionNotes(),
            ),
            const SizedBox(height: 24),
            
            // Progress
            _buildDetailSection(
              title: 'Progress',
              icon: Icons.trending_up,
              child: _buildProgress(),
            ),
            const SizedBox(height: 24),
            
            // Recommendations
            _buildDetailSection(
              title: 'Recommendations',
              icon: Icons.lightbulb,
              child: _buildRecommendations(),
            ),
            const SizedBox(height: 24),
            
            // Next appointment
            if (widget.session['nextAppointment'] != null)
              _buildDetailSection(
                title: 'Next Appointment',
                icon: Icons.event,
                child: _buildNextAppointment(),
              ),
            const SizedBox(height: 24),
            
            // Actions
            _buildActionsRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  /// Build session header with therapist info and date
  Widget _buildSessionHeader(DateTime date, int duration) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Therapist avatar and info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.aliceBlue,
                  radius: 30,
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.midnightTeal,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.session['therapistName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Physiotherapist',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Session info
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppTheme.midnightTeal,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Date'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: AppTheme.midnightTeal,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$duration min',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Duration'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.type_specimen,
                        color: AppTheme.midnightTeal,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.session['type'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text('Type'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a section with title and icon
  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.midnightTeal,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.midnightTeal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Section content
        child,
      ],
    );
  }
  
  /// Build session notes section
  Widget _buildSessionNotes() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.session['notes'],
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  /// Build progress section
  Widget _buildProgress() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.session['progress'],
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  /// Build recommendations section
  Widget _buildRecommendations() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.session['recommendations'],
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  /// Build next appointment section
  Widget _buildNextAppointment() {
    final nextAppointment = widget.session['nextAppointment'] as DateTime;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event,
                  color: AppTheme.midnightTeal,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(nextAppointment),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Appointment actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Reschedule functionality would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reschedule functionality not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Reschedule'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Cancel functionality would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cancel functionality not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build actions row
  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Download report button
        ElevatedButton.icon(
          icon: const Icon(Icons.download),
          label: const Text('Download Report'),
          onPressed: () {
            // Download functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Download functionality not implemented'),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        
        // Contact therapist button
        OutlinedButton.icon(
          icon: const Icon(Icons.message),
          label: const Text('Contact Therapist'),
          onPressed: () {
            // Contact functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contact functionality not implemented'),
              ),
            );
          },
        ),
      ],
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}