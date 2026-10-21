import 'package:flutter/material.dart';
// import '../../../config/theme.dart';
import '../../../models/appointment.dart';
import '../../../widgets/app_bar.dart';

class AppointmentDetail extends StatelessWidget {
  final Map<String, dynamic> appointment;
  
  const AppointmentDetail({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentData = Appointment.fromJson(appointment);
    
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Appointment Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Therapist info
                    Text(
                      'Appointment with ${appointmentData.therapistName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    
                    // Date and time
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(_formatDate(appointmentData.appointmentDate)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(_formatTime(appointmentData.appointmentDate)),
                      ],
                    ),
                    
                    // Duration
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('${appointmentData.durationMinutes} minutes'),
                      ],
                    ),
                    
                    // Location or virtual
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          appointmentData.isVirtual ? Icons.videocam : Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(appointmentData.isVirtual 
                            ? 'Virtual appointment' 
                            : appointmentData.location ?? 'No location specified'),
                        ),
                      ],
                    ),
                    
                    // Status
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointmentData.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _formatStatus(appointmentData.status),
                        style: TextStyle(
                          color: _getStatusColor(appointmentData.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Reason for visit
            const Text('Reason for Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(appointmentData.reasonForVisit ?? 'No reason specified'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            if (!appointmentData.isPast && appointmentData.status == 'scheduled')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('Reschedule'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reschedule not implemented')),
                      );
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cancel not implemented')),
                      );
                    },
                  ),
                ],
              ),
              
            if (appointmentData.isVirtual && !appointmentData.isPast)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.videocam),
                    label: const Text('Join Video Call'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video call not implemented')),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled': return Colors.blue;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'missed': return Colors.orange;
      default: return Colors.grey;
    }
  }
  
  String _formatStatus(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}