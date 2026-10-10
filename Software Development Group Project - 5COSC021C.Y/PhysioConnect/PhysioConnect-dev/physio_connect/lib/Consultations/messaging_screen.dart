import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagingScreen extends StatelessWidget {
  // Support hotline number
  final String hotlineNumber = '+94 76 648 0202';

  // FAQ items as Map of questions and answers
  final List<Map<String, String>> faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'Go to Profile > Settings > Security > Reset Password and follow the instructions.'
    },
    {
      'question': 'How can I update my profile information?',
      'answer':
          'Navigate to Profile > Edit Profile and update the necessary fields.'
    },
    {
      'question': 'Where can I view my transaction history?',
      'answer':
          'Go to Dashboard > Transactions to view all your past activities.'
    },
    {
      'question': 'The app is running slow. What should I do?',
      'answer':
          'Try clearing the cache in Settings > Apps > Our App > Clear Cache, or restart your device.'
    },
  ];

  // Make a phone call
  void _callHotline() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: hotlineNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  // Send an email
  void _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'physioconnect.co@gmail.com',
      query: 'subject=Help%20Request&body=I%20need%20assistance%20with%20...',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email client')),
      );
    }
  }

  // Open chat support
  void _openLiveChat(BuildContext context) {
    // This would typically connect to your chat support service
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Live Chat'),
        content: Text(
            'This feature is coming soon. Our team is working on implementing live chat support.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support & Chat'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent,
                      size: 48, color: Colors.green.shade700),
                  SizedBox(height: 8),
                  Text(
                    'How can we help you today?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose an option below',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Support options section
            Text(
              'CONTACT US',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 12),

            // Support action cards
            Row(
              children: [
                Expanded(
                  child: _buildSupportCard(
                    context,
                    icon: Icons.phone,
                    title: 'Call Hotline',
                    subtitle: hotlineNumber,
                    onTap: _callHotline,
                    color: Colors.blue.shade100,
                    iconColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildSupportCard(
                    context,
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'physioconnect.co@gmail.com',
                    onTap: () => _sendEmail(context),
                    color: Colors.orange.shade100,
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSupportCard(
                    context,
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Talk to an agent',
                    onTap: () => _openLiveChat(context),
                    color: Colors.purple.shade100,
                    iconColor: Colors.purple,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildSupportCard(
                    context,
                    icon: Icons.forum,
                    title: 'Community',
                    subtitle: 'Ask other users',
                    onTap: () {},
                    color: Colors.teal.shade100,
                    iconColor: Colors.teal,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // FAQ Section
            Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 12),

            // FAQ expansion panels
            ...faqItems.map((faq) => _buildFaqItem(context, faq)),

            SizedBox(height: 24),

            // Additional help section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.amber, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need more help?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Visit our help center for more detailed guides and tutorials',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build support action cards
  Widget _buildSupportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 32),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build FAQ items
  Widget _buildFaqItem(BuildContext context, Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'] ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq['answer'] ?? '',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
