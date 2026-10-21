import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/navigation_drawer.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({Key? key}) : super(key: key);

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  int _selectedIndex = 0;
  
  // Mock data
  final List<Map<String, dynamic>> _conversations = [
    {
      'patientId': '1',
      'name': 'John Smith',
      'lastMessage': 'Thank you for the exercises, they\'re helping a lot',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unread': 2,
      'avatar': null,
      'messages': [
        {
          'id': '1',
          'sender': 'patient',
          'text': 'Hi Dr. Johnson, I have a question about the exercises you prescribed',
          'timestamp': DateTime.now().subtract(const Duration(hours: 48)),
        },
        {
          'id': '2',
          'sender': 'therapist',
          'text': 'Hello John, what questions do you have?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 47)),
        },
        {
          'id': '3',
          'sender': 'patient',
          'text': 'I\'m finding the second exercise quite difficult. Is there an alternative?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 24)),
        },
        {
          'id': '4',
          'sender': 'therapist',
          'text': 'Yes, you can try this modification instead. [Exercise description]',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        },
        {
          'id': '5',
          'sender': 'patient',
          'text': 'Thank you for the exercises, they\'re helping a lot',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
      ],
    },
    {
      'patientId': '2',
      'name': 'Emily Johnson',
      'lastMessage': 'I\'ll see you at my appointment tomorrow',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unread': 0,
      'avatar': null,
      'messages': [
        {
          'id': '1',
          'sender': 'therapist',
          'text': 'Hi Emily, just checking in on your progress',
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          'id': '2',
          'sender': 'patient',
          'text': 'Doing much better, thank you!',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': '3',
          'sender': 'therapist',
          'text': 'Great to hear! Don\'t forget your appointment on Thursday',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        },
        {
          'id': '4',
          'sender': 'patient',
          'text': 'I\'ll see you at my appointment tomorrow',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        },
      ],
    },
    {
      'patientId': '3',
      'name': 'Michael Chen',
      'lastMessage': 'Should I ice or heat my knee?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'unread': 1,
      'avatar': null,
      'messages': [
        {
          'id': '1',
          'sender': 'patient',
          'text': 'Should I ice or heat my knee?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        },
      ],
    },
  ];
  
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  List<Map<String, dynamic>> _getFilteredConversations() {
    if (_searchQuery.isEmpty) return _conversations;
    
    return _conversations.where((conversation) {
      final name = conversation['name'].toString().toLowerCase();
      final messages = conversation['messages'] as List<Map<String, dynamic>>;
      final messagesText = messages.map((m) => m['text'].toString().toLowerCase()).join(' ');
      
      return name.contains(_searchQuery.toLowerCase()) || 
             messagesText.contains(_searchQuery.toLowerCase());
    }).toList();
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final message = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'therapist',
      'text': _messageController.text,
      'timestamp': DateTime.now(),
    };
    
    setState(() {
      _conversations[_selectedIndex]['messages'].add(message);
      _conversations[_selectedIndex]['lastMessage'] = _messageController.text;
      _conversations[_selectedIndex]['timestamp'] = DateTime.now();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredConversations = _getFilteredConversations();
    
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Communication Hub'),
      drawer: NavigationDrawer(currentRoute: AppRoutes.physioCommunication),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Conversations list
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      // Search box
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search conversations...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: AppTheme.aliceBlue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      
                      // Conversation list
                      Expanded(
                        child: filteredConversations.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.forum, size: 48, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'No conversations yet'
                                          : 'No matching conversations',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredConversations.length,
                                itemBuilder: (context, index) {
                                  return _buildConversationItem(filteredConversations[index], index);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                
                // Vertical divider
                VerticalDivider(color: Colors.grey[300], width: 1),
                
                // Chat area
                Expanded(
                  child: _selectedIndex < filteredConversations.length
                      ? _buildChatArea(filteredConversations[_selectedIndex])
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Select a conversation to start chatting',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildConversationItem(Map<String, dynamic> conversation, int index) {
    final isSelected = index == _selectedIndex;
    final unreadCount = conversation['unread'] as int;
    
    return Container(
      color: isSelected ? AppTheme.aliceBlue : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? AppTheme.midnightTeal : Colors.grey[300],
          child: Text(
            conversation['name'].toString().substring(0, 1),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
        title: Text(
          conversation['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          conversation['lastMessage'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(conversation['timestamp']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppTheme.midnightTeal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
            // Clear unread count when opening conversation
            _conversations[index]['unread'] = 0;
          });
        },
      ),
    );
  }
  
  Widget _buildChatArea(Map<String, dynamic> conversation) {
    final messages = conversation['messages'] as List<Map<String, dynamic>>;
    
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.aliceBlue,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.midnightTeal,
                child: Text(
                  conversation['name'].toString().substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Patient ID: ${conversation['patientId']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call feature not implemented')),
                  );
                },
                tooltip: 'Call',
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video call feature not implemented')),
                  );
                },
                tooltip: 'Video Call',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('More options not implemented')),
                  );
                },
                tooltip: 'More Options',
              ),
            ],
          ),
        ),
        
        // Messages list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(messages[index]);
            },
          ),
        ),
        
        // Message input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attachment feature not implemented')),
                  );
                },
                tooltip: 'Attach File',
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: AppTheme.aliceBlue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppTheme.midnightTeal,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: _sendMessage,
                  tooltip: 'Send',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isTherapist = message['sender'] == 'therapist';
    
    return Align(
      alignment: isTherapist ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isTherapist ? AppTheme.midnightTeal : AppTheme.aliceBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isTherapist ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message['timestamp']),
              style: TextStyle(
                fontSize: 10,
                color: isTherapist ? Colors.white.withOpacity(0.7) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      // Today
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.day == now.day - 1 && time.month == now.month && time.year == now.year) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Other days
      return '${time.day}/${time.month}';
    }
  }
}