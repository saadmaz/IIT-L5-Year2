import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../../../config/theme.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/ephr_service.dart';
import '../../../models/medication.dart';
import '../../../widgets/app_bar.dart';

/// Medication Detail Screen
/// Shows detailed information about a medication
/// Includes dosage, frequency, instructions, side effects, and more

class MedicationDetail extends StatefulWidget {
  final Map<String, dynamic> medication;
  
  const MedicationDetail({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  State<MedicationDetail> createState() => _MedicationDetailState();
}

class _MedicationDetailState extends State<MedicationDetail> {
  late Medication _medication;
  bool _reminderEnabled = false;
  
  @override
  void initState() {
    super.initState();
    // Convert JSON to Medication object
    _medication = Medication.fromJson(widget.medication);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EPHRAppBar(
        title: _medication.name,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            _buildStatusBadge(),
            const SizedBox(height: 24),
            
            // Medication details
            _buildDetailSection(
              title: 'Medication Details',
              icon: Icons.medication,
              child: _buildMedicationDetails(),
            ),
            const SizedBox(height: 24),
            
            // Dosage and schedule
            _buildDetailSection(
              title: 'Dosage & Schedule',
              icon: Icons.schedule,
              child: _buildDosageAndSchedule(),
            ),
            const SizedBox(height: 24),
            
            // Prescriber information
            _buildDetailSection(
              title: 'Prescriber Information',
              icon: Icons.person,
              child: _buildPrescriberInfo(),
            ),
            const SizedBox(height: 24),
            
            // Side effects and interactions
            if (_medication.sideEffects != null || _medication.interactions != null) ...[
              _buildDetailSection(
                title: 'Side Effects & Interactions',
                icon: Icons.warning,
                child: _buildSideEffectsAndInteractions(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Reminders
            _buildDetailSection(
              title: 'Medication Reminders',
              icon: Icons.notifications,
              child: _buildReminders(),
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
  
  /// Build status badge (active or inactive)
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _medication.isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _medication.isActive ? Icons.check_circle : Icons.cancel,
            color: _medication.isActive ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            _medication.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: _medication.isActive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
  
  /// Build medication details section
  Widget _buildMedicationDetails() {
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
            // Medication name
            const Text(
              'Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _medication.name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // Start and end dates
            const Text(
              'Duration:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    'Start Date:',
                    _formatDate(_medication.startDate),
                  ),
                ),
                if (_medication.endDate != null)
                  Expanded(
                    child: _buildInfoRow(
                      'End Date:',
                      _formatDate(_medication.endDate!),
                    ),
                  ),
              ],
            ),
            
            // Instructions if available
            if (_medication.instructions != null && _medication.instructions!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Instructions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _medication.instructions!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build dosage and schedule section
  Widget _buildDosageAndSchedule() {
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
            // Dosage
            const Text(
              'Dosage:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _medication.dosage,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // Frequency
            const Text(
              'Frequency:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _medication.frequency,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            
            // Example schedule
            const SizedBox(height: 16),
            const Text(
              'Example Schedule:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildScheduleExample(),
          ],
        ),
      ),
    );
  }
  
  /// Build prescriber information section
  Widget _buildPrescriberInfo() {
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
            _buildInfoRow(
              'Prescribed By:',
              _medication.prescribedBy,
            ),
            if (_medication.prescriberId != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Prescriber ID:',
                _medication.prescriberId!,
              ),
            ],
            const SizedBox(height: 16),
            
            // Contact prescriber button
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Contact prescriber functionality would be implemented in a real app
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact prescriber functionality not implemented'),
                    ),
                  );
                },
                icon: const Icon(Icons.phone),
                label: const Text('Contact Prescriber'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build side effects and interactions section
  Widget _buildSideEffectsAndInteractions() {
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
            // Side effects
            if (_medication.sideEffects != null && _medication.sideEffects!.isNotEmpty) ...[
              const Text(
                'Possible Side Effects:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _medication.sideEffects!.map((effect) {
                  return Chip(
                    label: Text(effect),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            
            // Interactions
            if (_medication.interactions != null && _medication.interactions!.isNotEmpty) ...[
              const Text(
                'Known Interactions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _medication.interactions!.map((interaction) {
                  return Chip(
                    label: Text(interaction),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build medication reminders section
  Widget _buildReminders() {
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
            // Toggle for enabling reminders
            SwitchListTile(
              title: const Text(
                'Enable Reminders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _reminderEnabled
                    ? 'Reminders are enabled for this medication'
                    : 'No reminders set for this medication',
              ),
              value: _reminderEnabled,
              activeColor: AppTheme.midnightTeal,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                });
              },
            ),
            
            // Reminder settings (visible only when enabled)
            if (_reminderEnabled) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Reminder Times:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              
              // Sample reminder times
              // In a real app, these would be customizable
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  size: 20,
                ),
                title: const Text('Morning'),
                subtitle: const Text('8:00 AM'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                  ),
                  onPressed: () {},
                ),
                dense: true,
              ),
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  size: 20,
                ),
                title: const Text('Evening'),
                subtitle: const Text('6:00 PM'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                  ),
                  onPressed: () {},
                ),
                dense: true,
              ),
              
              // Add reminder button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Add reminder functionality would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add reminder functionality not implemented'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Reminder'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build schedule example
  Widget _buildScheduleExample() {
    // This is a simplified example based on the frequency
    // In a real app, this would be more sophisticated
    String exampleText = 'Based on your prescription:';
    
    if (_medication.frequency.contains('daily')) {
      exampleText += '\n• Take once every day';
    } else if (_medication.frequency.contains('twice') || _medication.frequency.contains('2x')) {
      exampleText += '\n• Take in the morning around 8:00 AM';
      exampleText += '\n• Take in the evening around 6:00 PM';
    } else if (_medication.frequency.contains('three') || _medication.frequency.contains('3x')) {
      exampleText += '\n• Take in the morning around 8:00 AM';
      exampleText += '\n• Take in the afternoon around 2:00 PM';
      exampleText += '\n• Take in the evening around 8:00 PM';
    } else if (_medication.frequency.contains('four') || _medication.frequency.contains('4x')) {
      exampleText += '\n• Take in the morning around 8:00 AM';
      exampleText += '\n• Take at noon around 12:00 PM';
      exampleText += '\n• Take in the afternoon around 4:00 PM';
      exampleText += '\n• Take before bed around 8:00 PM';
    } else if (_medication.frequency.contains('week')) {
      exampleText += '\n• Take once per week on Mondays';
    } else {
      exampleText += '\n• Follow the instructions provided by your doctor or pharmacist';
    }
    
    return Text(
      exampleText,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }
  
  /// Build actions row
  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Edit button
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit Medication'),
          onPressed: () {
            // Edit functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Edit functionality not implemented'),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        
        // Toggle active status button
        OutlinedButton.icon(
          icon: Icon(
            _medication.isActive ? Icons.cancel : Icons.check,
          ),
          label: Text(
            _medication.isActive ? 'Mark as Inactive' : 'Mark as Active',
          ),
          onPressed: () {
            // Status toggle functionality would be implemented in a real app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status toggle functionality not implemented'),
              ),
            );
          },
        ),
      ],
    );
  }
  
  /// Build an information row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}