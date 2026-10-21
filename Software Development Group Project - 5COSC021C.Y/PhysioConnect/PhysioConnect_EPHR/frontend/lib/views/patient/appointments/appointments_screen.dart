import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../models/appointment.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart' as app_drawer;
import '../../../widgets/ephr_card.dart';

/// Appointments Screen
/// Displays calendar with upcoming and past appointments
/// Allows booking new appointments and managing existing ones

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool _isLoading = true;
  List<Appointment> _appointments = [];
  String? _error;
  
  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }
  
  /// Load appointments from API
  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      final userId = authService.userState.currentUser?.id ?? '';
      
      // Load appointments
      _appointments = await ephrService.getAppointments(userId);
      
      // Set selected day to today by default
      _selectedDay = _focusedDay;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading appointments: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  /// Get appointments for a specific day
  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointments.where((appointment) {
      final appointmentDate = appointment.appointmentDate;
      return appointmentDate.year == day.year && 
             appointmentDate.month == day.month && 
             appointmentDate.day == day.day;
    }).toList();
  }
  
  /// Check if a day has appointments
  // bool _hasAppointments(DateTime day) {
  //   return _getAppointmentsForDay(day).isNotEmpty;
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Appointments',
      ),
      drawer: app_drawer.AppNavigationDrawer(currentRoute: AppRoutes.appointments),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.bookAppointment)
              .then((_) => _loadAppointments());
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : _error != null
              ? _buildErrorView()
              : _appointments.isEmpty
                  ? _buildEmptyView()
                  : _buildAppointmentsCalendar(),
    );
  }
  
  /// Build the error view
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $_error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAppointments,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  /// Build empty view
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'No Appointments Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your appointments will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.bookAppointment)
                  .then((_) => _loadAppointments());
            },
            icon: const Icon(Icons.add),
            label: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
  
  /// Build appointments calendar view
  Widget _buildAppointmentsCalendar() {
    // Get appointments for selected day
    final selectedDayAppointments = _selectedDay != null 
        ? _getAppointmentsForDay(_selectedDay!) 
        : <Appointment>[];
    
    // Split into upcoming and past appointments
    final now = DateTime.now();
    final upcomingAppointments = _appointments
        .where((appointment) => appointment.appointmentDate.isAfter(now))
        .toList();
    final pastAppointments = _appointments
        .where((appointment) => appointment.appointmentDate.isBefore(now))
        .toList();
    
    // Sort appointments
    upcomingAppointments.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    pastAppointments.sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
    
    return Column(
      children: [
        // Calendar
        _buildCalendar(),
        
        // Selected day appointments (if any)
        if (_selectedDay != null && selectedDayAppointments.isNotEmpty)
          Expanded(
            child: _buildSelectedDayAppointments(selectedDayAppointments),
          )
        else
          // Upcoming and past appointments tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // Tab bar
                  const TabBar(
                    labelColor: AppTheme.midnightTeal,
                    indicatorColor: AppTheme.midnightTeal,
                    tabs: [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                  
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Upcoming appointments tab
                        upcomingAppointments.isEmpty
                            ? _buildNoAppointmentsMessage('No upcoming appointments')
                            : _buildAppointmentsList(upcomingAppointments),
                        
                        // Past appointments tab
                        pastAppointments.isEmpty
                            ? _buildNoAppointmentsMessage('No past appointments')
                            : _buildAppointmentsList(pastAppointments),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  /// Build calendar widget
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      eventLoader: (day) {
        // Return appointments for the day as "events"
        return _getAppointmentsForDay(day);
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 3,
        markersAlignment: Alignment.bottomCenter,
        markerDecoration: const BoxDecoration(
          color: AppTheme.midnightTeal,
          shape: BoxShape.circle,
        ),
        todayDecoration: const BoxDecoration(
          color: AppTheme.aliceBlue,
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: AppTheme.midnightTeal,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppTheme.midnightTeal,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              bottom: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.midnightTeal,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
  
  /// Build selected day appointments list
  Widget _buildSelectedDayAppointments(List<Appointment> appointments) {
    return Column(
      children: [
        // Selected day header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: AppTheme.aliceBlue,
          child: Row(
            children: [
              Text(
                'Appointments on ${_formatDate(_selectedDay!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.midnightTeal,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDay = null;
                  });
                },
                child: const Text('Show All'),
              ),
            ],
          ),
        ),
        
        // Appointments list
        Expanded(
          child: _buildAppointmentsList(appointments),
        ),
      ],
    );
  }
  
  /// Build appointments list
  Widget _buildAppointmentsList(List<Appointment> appointments) {
    return RefreshIndicator(
      onRefresh: _loadAppointments,
      color: AppTheme.midnightTeal,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return _buildAppointmentCard(appointments[index]);
        },
      ),
    );
  }
  
  /// Build no appointments message
  Widget _buildNoAppointmentsMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.bookAppointment)
                  .then((_) => _loadAppointments());
            },
            icon: const Icon(Icons.add),
            label: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
  
  /// Build an appointment card
  Widget _buildAppointmentCard(Appointment appointment) {
    final isPast = appointment.isPast;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: EPHRCard(
        title: 'Appointment with ${appointment.therapistName}',
        subtitle: '${_formatDate(appointment.appointmentDate)} at ${_formatTime(appointment.appointmentDate)}',
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey[200] : AppTheme.aliceBlue,
          child: Icon(
            appointment.isVirtual ? Icons.videocam : Icons.person,
            color: isPast ? Colors.grey : AppTheme.midnightTeal,
            size: 20,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration
            Row(
              children: [
                const Icon(
                  Icons.timer,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  'Duration: ${appointment.durationMinutes} minutes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Location or virtual link
            Row(
              children: [
                Icon(
                  appointment.isVirtual ? Icons.link : Icons.location_on,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    appointment.isVirtual
                        ? 'Virtual appointment (link will be provided)'
                        : appointment.location ?? 'Location not specified',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            
            // Status badge
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(appointment.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getFormattedStatus(appointment.status),
                style: TextStyle(
                  color: _getStatusColor(appointment.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // View details button
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.appointmentDetail,
                arguments: appointment.toJson(),
              );
            },
            child: const Text('View Details'),
          ),
          
          // Quick action button
          if (!isPast && appointment.status == 'scheduled')
            IconButton(
              onPressed: () {
                // Cancel functionality would be implemented in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cancel functionality not implemented'),
                  ),
                );
              },
              icon: const Icon(
                Icons.cancel,
                size: 20,
                color: Colors.red,
              ),
              tooltip: 'Cancel',
            ),
        ],
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.appointmentDetail,
            arguments: appointment.toJson(),
          );
        },
      ),
    );
  }
  
  /// Get color for appointment status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'missed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  /// Get formatted status text
  String _getFormattedStatus(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }
  
  /// Format date to display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Format time to display
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}