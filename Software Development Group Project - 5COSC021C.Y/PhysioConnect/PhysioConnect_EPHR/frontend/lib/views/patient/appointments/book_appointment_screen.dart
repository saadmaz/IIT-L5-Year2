// File: views/patient/appointments/book_appointment_screen.dart
import 'package:flutter/material.dart';

/// Screen for booking a new appointment with a physiotherapist
class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Selected values
  String? _selectedPhysio;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _appointmentType;
  
  // Mock data
  final List<String> _physiotherapists = [
    'Dr. Sarah Johnson',
    'Dr. Michael Chen',
    'Dr. Emily Patel',
    'Dr. Robert Garcia',
  ];
  
  final List<String> _timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:30 AM - 11:30 AM',
    '12:00 PM - 1:00 PM',
    '2:00 PM - 3:00 PM',
    '3:30 PM - 4:30 PM',
    '5:00 PM - 6:00 PM',
  ];
  
  final List<String> _appointmentTypes = [
    'Initial Consultation',
    'Follow-up Session',
    'Treatment Session',
    'Assessment',
    'Virtual Consultation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Physiotherapist
              const Text(
                'Select Physiotherapist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                value: _selectedPhysio,
                hint: const Text('Select a physiotherapist'),
                isExpanded: true,
                items: _physiotherapists.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPhysio = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a physiotherapist';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Appointment Type
              const Text(
                'Appointment Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                value: _appointmentType,
                hint: const Text('Select appointment type'),
                isExpanded: true,
                items: _appointmentTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _appointmentType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an appointment type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Select Date
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select a date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Select Time Slot
              if (_selectedDate != null) ...[
                const Text(
                  'Select Time Slot',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  value: _selectedTimeSlot,
                  hint: const Text('Select a time slot'),
                  isExpanded: true,
                  items: _timeSlots.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTimeSlot = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a time slot';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              // Reason for Visit
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Visit*',
                  hintText: 'Briefly describe your reason for this appointment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason for your visit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Additional Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  hintText: 'Any other information you would like to provide',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      selectableDayPredicate: (DateTime date) {
        // Disable weekends if needed
        // return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
        return true;
      },
    );
    
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedTimeSlot = null; // Reset time slot when date changes
      });
    }
  }

  void _bookAppointment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }
      
      if (_selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time slot')),
        );
        return;
      }
      
      // Create appointment object
      final appointment = {
        'physiotherapist': _selectedPhysio,
        'appointmentType': _appointmentType,
        'date': _selectedDate,
        'timeSlot': _selectedTimeSlot,
        'reason': _reasonController.text,
        'notes': _notesController.text,
        'status': 'Pending',
      };
      
      // Return to previous screen with appointment data
      Navigator.pop(context, appointment);
    }
  }
  
  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}