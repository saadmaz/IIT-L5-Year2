import 'package:flutter/material.dart';
import '../../models/notification_type.dart';
import '../../theme/app_theme.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({Key? key}) : super(key: key);

  @override
  _ActivityHistoryScreenState createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<UserNotification> _notifications = [];

  final List<String> _activityFilters = [
    'All Activity',
    'Appointments',
    'Connections',
    'Certifications',
    'Messages',
  ];

  String _selectedFilter = 'All Activity';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadActivityHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadActivityHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from API
      await Future.delayed(const Duration(seconds: 1));

      // Mock notifications for development
      final mockNotifications = [
        UserNotification(
          id: 1,
          title: 'New Connection Request',
          message: 'Dr. Michael Chen sent you a connection request',
          type: NotificationType.connectionRequest,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {'user_id': 4, 'user_name': 'Dr. Michael Chen'},
        ),
        UserNotification(
          id: 2,
          title: 'Appointment Reminder',
          message:
              'Upcoming appointment with Patient #123 tomorrow at 10:00 AM',
          type: NotificationType.appointmentReminder,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          metadata: {
            'appointment_id': 123,
            'appointment_time': '2023-09-15T10:00:00Z',
          },
        ),
        UserNotification(
          id: 3,
          title: 'Certificate Expiration',
          message: 'Your Manual Therapy Certification will expire in 30 days',
          type: NotificationType.certificateExpiry,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          metadata: {'certificate_id': 5, 'expiration_date': '2023-10-15'},
        ),
        UserNotification(
          id: 4,
          title: 'New Message',
          message: 'Dr. Sarah Johnson sent you a message',
          type: NotificationType.message,
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          metadata: {'user_id': 3, 'user_name': 'Dr. Sarah Johnson'},
        ),
        UserNotification(
          id: 5,
          title: 'Achievement Unlocked',
          message: 'You earned the "Century Club" achievement',
          type: NotificationType.achievementAwarded,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          metadata: {'achievement_id': 1, 'achievement_name': 'Century Club'},
        ),
        UserNotification(
          id: 6,
          title: 'Connection Accepted',
          message: 'Dr. John Davis accepted your connection request',
          type: NotificationType.connectionAccepted,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          metadata: {'user_id': 2, 'user_name': 'Dr. John Davis'},
        ),
        UserNotification(
          id: 7,
          title: 'Appointment Cancellation',
          message:
              'Appointment with Patient #118 on Sept 12 has been cancelled',
          type: NotificationType.appointmentCancellation,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          metadata: {
            'appointment_id': 118,
            'appointment_time': '2023-09-12T14:30:00Z',
          },
        ),
        UserNotification(
          id: 8,
          title: 'System Update',
          message: 'PhysioConnect has been updated to version 2.3.0',
          type: NotificationType.systemUpdate,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      setState(() {
        _notifications = mockNotifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<UserNotification> _getFilteredNotifications() {
    if (_selectedFilter == 'All Activity') {
      return _notifications;
    } else if (_selectedFilter == 'Appointments') {
      return _notifications
          .where(
            (notification) =>
                notification.type == NotificationType.appointmentReminder ||
                notification.type == NotificationType.appointmentCancellation ||
                notification.type == NotificationType.appointmentRequest,
          )
          .toList();
    } else if (_selectedFilter == 'Connections') {
      return _notifications
          .where(
            (notification) =>
                notification.type == NotificationType.connectionRequest ||
                notification.type == NotificationType.connectionAccepted,
          )
          .toList();
    } else if (_selectedFilter == 'Certifications') {
      return _notifications
          .where(
            (notification) =>
                notification.type == NotificationType.certificateExpiry,
          )
          .toList();
    } else if (_selectedFilter == 'Messages') {
      return _notifications
          .where(
            (notification) => notification.type == NotificationType.message,
          )
          .toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        bottom: TabBar(
          controller: _tabController,
          labelColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.primaryColor,
          unselectedLabelColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [Tab(text: 'Activity'), Tab(text: 'Login History')],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [_buildActivityTab(), _buildLoginHistoryTab()],
              ),
    );
  }

  Widget _buildActivityTab() {
    final filteredNotifications = _getFilteredNotifications();

    return Column(
      children: [
        // Filter dropdown
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedFilter,
            decoration: const InputDecoration(
              labelText: 'Filter Activity',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            items:
                _activityFilters.map((filter) {
                  return DropdownMenuItem<String>(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                });
              }
            },
          ),
        ),

        // Notification list
        Expanded(
          child:
              filteredNotifications.isEmpty
                  ? const Center(
                    child: Text(
                      'No activity found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationItem(notification);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(UserNotification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatDate(notification.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          // TODO: Navigate to relevant screen based on notification type
        },
      ),
    );
  }

  Widget _buildLoginHistoryTab() {
    // Mock login history for development
    final loginHistory = [
      {
        'device': 'iPhone 13',
        'location': 'New York, United States',
        'ip': '192.168.1.1',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'Current Session',
      },
      {
        'device': 'MacBook Pro',
        'location': 'New York, United States',
        'ip': '192.168.1.2',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Successful',
      },
      {
        'device': 'iPad Pro',
        'location': 'Boston, United States',
        'ip': '192.168.1.3',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'Successful',
      },
      {
        'device': 'Unknown Device',
        'location': 'London, United Kingdom',
        'ip': '192.168.1.4',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'Failed',
      },
    ];

    return ListView.builder(
      itemCount: loginHistory.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final login = loginHistory[index];
        final isCurrentSession = login['status'] == 'Current Session';
        final isFailedLogin = login['status'] == 'Failed';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isFailedLogin
                          ? Icons.error_outline
                          : (isCurrentSession
                              ? Icons.check_circle
                              : Icons.check),
                      color:
                          isFailedLogin
                              ? Colors.red
                              : (isCurrentSession
                                  ? AppTheme.primaryColor
                                  : Colors.green),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      login['status'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isFailedLogin
                                ? Colors.red
                                : (isCurrentSession
                                    ? AppTheme.primaryColor
                                    : Colors.green),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(login['date'] as DateTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),
                _buildLoginInfoRow(
                  Icons.devices,
                  'Device',
                  login['device'] as String,
                ),
                const SizedBox(height: 8),
                _buildLoginInfoRow(
                  Icons.location_on_outlined,
                  'Location',
                  login['location'] as String,
                ),
                const SizedBox(height: 8),
                _buildLoginInfoRow(
                  Icons.wifi,
                  'IP Address',
                  login['ip'] as String,
                ),

                if (isCurrentSession) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Log out from all other devices
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out from all other devices'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.connectionRequest:
      case NotificationType.connectionAccepted:
        return Colors.purple;
      case NotificationType.appointmentRequest:
      case NotificationType.appointmentReminder:
        return AppTheme.primaryColor;
      case NotificationType.appointmentCancellation:
        return Colors.red;
      case NotificationType.certificateExpiry:
        return Colors.orange;
      case NotificationType.achievementAwarded:
        return Colors.amber;
      case NotificationType.systemUpdate:
        return Colors.teal;
      case NotificationType.profileView:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.connectionRequest:
        return Icons.person_add;
      case NotificationType.connectionAccepted:
        return Icons.handshake;
      case NotificationType.appointmentRequest:
      case NotificationType.appointmentReminder:
        return Icons.calendar_today;
      case NotificationType.appointmentCancellation:
        return Icons.event_busy;
      case NotificationType.certificateExpiry:
        return Icons.warning;
      case NotificationType.achievementAwarded:
        return Icons.emoji_events;
      case NotificationType.systemUpdate:
        return Icons.system_update;
      case NotificationType.profileView:
        return Icons.visibility;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
