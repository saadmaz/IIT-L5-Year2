import 'package:flutter/material.dart';
import '../../../config/theme.dart';
//import '../../../config/routes.dart';
import '../../../widgets/app_bar.dart';
// import '../../../widgets/navigation_drawer.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key? key}) : super(key: key);

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _isLoading = false;
  
  // Mock permission data
  final List<Map<String, dynamic>> _permissions = [
    {
      'id': '1',
      'provider': 'Dr. Sarah Johnson',
      'role': 'Primary Physiotherapist',
      'access': ['Medical History', 'Physiotherapy Records', 'Pain Tracking'],
      'grantedOn': DateTime.now().subtract(const Duration(days: 45)),
      'expires': DateTime.now().add(const Duration(days: 365)),
      'status': 'Active',
    },
    {
      'id': '2',
      'provider': 'Dr. Michael Chen',
      'role': 'Orthopedic Specialist',
      'access': ['Medical History', 'Test Results'],
      'grantedOn': DateTime.now().subtract(const Duration(days: 60)),
      'expires': DateTime.now().add(const Duration(days: 90)),
      'status': 'Active',
    },
    {
      'id': '3',
      'provider': 'City General Hospital',
      'role': 'Healthcare Institution',
      'access': ['Emergency Information'],
      'grantedOn': DateTime.now().subtract(const Duration(days: 180)),
      'expires': null,
      'status': 'Active',
    },
    {
      'id': '4',
      'provider': 'Dr. Jennifer Lee',
      'role': 'Previous Therapist',
      'access': ['Physiotherapy Records'],
      'grantedOn': DateTime.now().subtract(const Duration(days: 300)),
      'expires': DateTime.now().subtract(const Duration(days: 30)),
      'status': 'Expired',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Consent & Permissions'),
      drawer: NavigationDrawer(
        children: [], // Add an empty list of children 
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info card
                  Card(
                    color: AppTheme.aliceBlue,
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
                              Icon(Icons.info, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              Text(
                                'About Consent Management',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This section allows you to manage who has access to your health information. You can grant or revoke access to healthcare providers at any time.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Active permissions
                  const Text(
                    'Active Permissions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ..._permissions
                      .where((permission) => permission['status'] == 'Active')
                      .map((permission) => _buildPermissionCard(permission)),
                  
                  const SizedBox(height: 24),
                  
                  // Expired permissions
                  const Text(
                    'Expired Permissions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ..._permissions
                      .where((permission) => permission['status'] == 'Expired')
                      .map((permission) => _buildPermissionCard(permission)),
                  
                  const SizedBox(height: 24),
                  
                  // Grant new access button
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Grant New Access'),
                      onPressed: () {
                        _showGrantAccessDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // View access log button
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.history),
                      label: const Text('View Access Log'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Access log not implemented')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
  
  Widget _buildPermissionCard(Map<String, dynamic> permission) {
    final bool isActive = permission['status'] == 'Active';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        permission['provider'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        permission['role'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    permission['status'],
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Access information
            const Text(
              'Access to:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (permission['access'] as List<String>).map((access) {
                return Chip(
                  label: Text(access),
                  backgroundColor: AppTheme.aliceBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            
            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Granted on:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDate(permission['grantedOn']),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expires:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        permission['expires'] != null
                            ? _formatDate(permission['expires'])
                            : 'Never',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (isActive) ...[
              const SizedBox(height: 16),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Modify'),
                    onPressed: () {
                      _showModifyAccessDialog(permission);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                    label: const Text('Revoke', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      _showRevokeAccessDialog(permission);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showGrantAccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Grant New Access'),
          content: const Text('This feature is not implemented in the demo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  void _showModifyAccessDialog(Map<String, dynamic> permission) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modify Access'),
          content: const Text('This feature is not implemented in the demo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  void _showRevokeAccessDialog(Map<String, dynamic> permission) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Revoke Access'),
          content: Text('Are you sure you want to revoke access for ${permission['provider']}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  permission['status'] = 'Expired';
                  permission['expires'] = DateTime.now();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Access revoked successfully')),
                );
              },
              child: const Text('Revoke', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}