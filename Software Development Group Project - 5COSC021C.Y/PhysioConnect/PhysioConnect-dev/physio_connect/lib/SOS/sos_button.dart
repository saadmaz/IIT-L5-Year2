// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SOSFloatingButton extends StatefulWidget {
  final List<EmergencyContact> contacts;

  const SOSFloatingButton({
    Key? key,
    required this.contacts,
  }) : super(key: key);

  @override
  _SOSFloatingButtonState createState() => _SOSFloatingButtonState();
}

class _SOSFloatingButtonState extends State<SOSFloatingButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } catch (e) {
      _showErrorSnackBar('Error getting location: $e');
      return null;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _callEmergencyService() async {
    final Uri phoneUri = Uri(
        scheme: 'tel', path: '911'); // Change to appropriate emergency number
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorSnackBar('Could not launch emergency call');
    }
  }

  Future<void> _contactWithLocation(EmergencyContact contact) async {
    Position? position = await _getCurrentLocation();
    if (position != null) {
      final String locationMessage =
          'I need help! My current location is: https://maps.google.com/?q=${position.latitude},${position.longitude}';

      // For SMS option
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {'body': locationMessage},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback to sharing options
        await Share.share(
          'Emergency: Please contact me at my location: https://maps.google.com/?q=${position.latitude},${position.longitude}',
          subject: 'Emergency SOS from PhysioConnect',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expanded contacts list
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.local_hospital, color: Colors.red),
                        title: const Text('Call Emergency Services'),
                        onTap: _callEmergencyService,
                      ),
                      const Divider(height: 1),
                      ...widget.contacts.map((contact) => ListTile(
                            leading: Icon(
                              contact.contactType == ContactType.hospital
                                  ? Icons.local_hospital
                                  : Icons.person,
                              color: contact.contactType == ContactType.hospital
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            title: Text(contact.name),
                            subtitle: Text(contact.phoneNumber),
                            onTap: () => _contactWithLocation(contact),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main SOS button
          FloatingActionButton(
            heroTag: 'sosButton',
            backgroundColor: _isExpanded ? Colors.grey : Colors.red,
            onPressed: _toggleExpanded,
            child: Icon(
              _isExpanded ? Icons.close : Icons.warning_amber_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final ContactType contactType;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.contactType = ContactType.personal,
  });
}

enum ContactType { personal, hospital, police }

// Usage example in your main app
class EmergencyContactsProvider extends StatelessWidget {
  const EmergencyContactsProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample contacts - in a real app, these would come from your user's profile or database
    final List<EmergencyContact> contacts = [
      EmergencyContact(
        id: '1',
        name: 'John Doe (Family)',
        phoneNumber: '+1234567890',
      ),
      EmergencyContact(
        id: '2',
        name: 'Dr. Smith',
        phoneNumber: '+1987654321',
        contactType: ContactType.hospital,
      ),
      EmergencyContact(
        id: '3',
        name: 'Local Hospital',
        phoneNumber: '+1122334455',
        contactType: ContactType.hospital,
      ),
    ];

    return Scaffold(
      // Your normal page content here
      body: Center(
        child: Text('PhysioConnect App Content'),
      ),
      // The SOS button will be displayed as an overlay
      floatingActionButton: Stack(
        children: [
          // Your other floating action buttons could go here
          SOSFloatingButton(contacts: contacts),
        ],
      ),
    );
  }
}
