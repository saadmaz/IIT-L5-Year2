import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show immutable;

// Placeholder AppTheme
class AppTheme {
  static const Color midnightTeal = Color(0xFF006064);
  static const Color aliceBlue = Color(0xFFE6F2F3);
}

// Placeholder AppRoutes
class AppRoutes {
  static const String emergencyInfo = '/emergency-info';
}

// Placeholder EPHRAppBar
class EPHRAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const EPHRAppBar({
    Key? key, 
    required this.title, 
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showBackButton,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Placeholder EPHRCard
@immutable
class EPHRCard extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget content;
  final EdgeInsets padding;

  const EPHRCard({
    Key? key,
    required this.title,
    required this.leading,
    required this.content,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                leading,
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}

class EmergencyInfoScreen extends StatefulWidget {
  const EmergencyInfoScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyInfoScreen> createState() => _EmergencyInfoScreenState();
}

class _EmergencyInfoScreenState extends State<EmergencyInfoScreen> {
  bool _isLoading = false;

  // Mock emergency data
  final Map<String, dynamic> _emergencyData = {
    'bloodGroup': 'O+',
    'allergies': ['Penicillin', 'Peanuts'],
    'medications': ['Lisinopril 10mg', 'Ibuprofen (as needed)'],
    'conditions': ['Hypertension', 'Lower back pain'],
    'contacts': [
      {
        'name': 'Jane Smith',
        'relationship': 'Spouse',
        'phone': '(555) 123-4567',
      },
      {
        'name': 'John Smith',
        'relationship': 'Brother',
        'phone': '(555) 987-6543',
      },
    ],
    'primaryPhysician': {
      'name': 'Dr. Sarah Johnson',
      'phone': '(555) 333-2222',
      'address': '123 Medical Center Dr, Anytown',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Emergency Information'),
      drawer: NavigationDrawer(
        children: [
          NavigationDrawerDestination(
            icon: Icon(Icons.emergency),
            label: Text('Emergency Info'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit functionality not implemented')),
          );
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.edit),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emergency badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emergency,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'EMERGENCY INFORMATION',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Blood Type: ${_emergencyData['bloodGroup']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Medical conditions
                  _buildSection(
                    title: 'Critical Medical Conditions',
                    icon: Icons.medical_information,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildListItems(_emergencyData['conditions']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Allergies
                  _buildSection(
                    title: 'Allergies',
                    icon: Icons.coronavirus,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildListItems(_emergencyData['allergies']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Medications
                  _buildSection(
                    title: 'Current Medications',
                    icon: Icons.medication,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildListItems(_emergencyData['medications']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Emergency contacts
                  _buildSection(
                    title: 'Emergency Contacts',
                    icon: Icons.contact_phone,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._emergencyData['contacts'].map<Widget>((contact) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppTheme.aliceBlue,
                                  child: Icon(
                                    Icons.person,
                                    color: AppTheme.midnightTeal,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contact['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${contact['relationship']} • ${contact['phone']}',
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: AppTheme.midnightTeal,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Call functionality not implemented',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary physician
                  _buildSection(
                    title: 'Primary Physician',
                    icon: Icons.medical_services,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _emergencyData['primaryPhysician']['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(_emergencyData['primaryPhysician']['phone']),
                        const SizedBox(height: 4),
                        Text(_emergencyData['primaryPhysician']['address']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Print button
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Print Emergency Information'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Print functionality not implemented',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return EPHRCard(
      title: title,
      leading: Icon(icon, color: AppTheme.midnightTeal),
      content: child,
      padding: const EdgeInsets.all(16),
    );
  }

  List<Widget> _buildListItems(List<String> items) {
    return items.map<Widget>((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 8, color: AppTheme.midnightTeal),
            const SizedBox(width: 8),
            Expanded(child: Text(item)),
          ],
        ),
      );
    }).toList();
  }
}