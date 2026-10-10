import 'package:flutter/material.dart';
import 'chat_message.dart';

class SupportChatScreen extends StatefulWidget {
  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! How can we help you today with PhysioConnect?',
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    )
  ];

  // Predefined categories and their corresponding questions
  final Map<String, String> _categoryQuestions = {
    'Technical Support':
        "I'm having technical issues with the app. Can you help?",
    'App Features':
        "Can you explain how to use the video consultation feature?",
    'Therapy Questions':
        "What kind of physiotherapy is best for lower back pain?",
    'Booking Issues':
        "I'm having trouble booking an appointment. Can you assist?",
    'Payment': "How do I update my payment information?",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Chat'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          // Support categories
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: _categoryQuestions.keys.map((category) {
                return _buildCategoryChip(category);
              }).toList(),
            ),
          ),
          Divider(height: 1),
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          // Input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // Implement file attachment
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.green.shade700,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build category chip
  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(category),
        backgroundColor: Colors.green.shade100,
        onPressed: () {
          // Get the predefined question for this category
          String question = _categoryQuestions[category] ?? '';

          // Add user message
          _addMessage(question, true);

          // Simulate support response
          Future.delayed(Duration(seconds: 1), () {
            _addMessage(
                "Thanks for your question about $category. A support agent will respond shortly.",
                false);
          });
        },
      ),
    );
  }

  // Build message bubble (you might want to create a separate widget for this)
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.green.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message.text),
      ),
    );
  }

  // Send message method
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      // Add user's message
      _addMessage(_messageController.text, true);

      // Simulate support response
      Future.delayed(Duration(seconds: 1), () {
        _addMessage(
            "Thank you for your message. Our support team will get back to you shortly.",
            false);
      });

      // Clear the text field
      _messageController.clear();
    }
  }

  // Add message to the chat
  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
  }
}
