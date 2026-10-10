import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'support_chat_screen.dart';
import 'dart:async';

class EmergencySessionScreen extends StatefulWidget {
  @override
  _EmergencySessionScreenState createState() => _EmergencySessionScreenState();
}

class _EmergencySessionScreenState extends State<EmergencySessionScreen> {
  bool isConnecting = true;
  bool isVideoOff = false;
  bool isMicMuted = false;
  bool isChatOpen = false;
  late Timer sessionTimer;
  int secondsElapsed = 0;
  String sessionTime = "00:00:00";

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  String chatMessage = "";
  List<Map<String, dynamic>> chatMessages = [];
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize camera right away
    initCamera();

    // Simulate connection delay
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isConnecting = false;
        });
        // Start session timer when connected
        startSessionTimer();
      }
    });
  }

  void startSessionTimer() {
    sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          secondsElapsed++;
          int hours = secondsElapsed ~/ 3600;
          int minutes = (secondsElapsed % 3600) ~/ 60;
          int seconds = secondsElapsed % 60;
          sessionTime =
              "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        // Try to get front camera, but fall back to first camera if not available
        final frontCameras = cameras!
            .where(
                (camera) => camera.lensDirection == CameraLensDirection.front)
            .toList();

        final CameraDescription selectedCamera =
            frontCameras.isNotEmpty ? frontCameras.first : cameras!.first;

        cameraController = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          enableAudio: true,
        );

        await cameraController!.initialize();

        if (mounted) {
          setState(() {
            isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void toggleMic() {
    setState(() {
      isMicMuted = !isMicMuted;
    });
    // In a real app, you would implement actual mic muting here
    if (cameraController != null && cameraController!.value.isInitialized) {
      cameraController!.setAudioMode(!isMicMuted);
    }
  }

  void toggleVideo() {
    setState(() {
      isVideoOff = !isVideoOff;
    });
    // In a real app, you would implement actual video toggling here
    if (cameraController != null && cameraController!.value.isInitialized) {
      if (isVideoOff) {
        cameraController!.pausePreview();
      } else {
        cameraController!.resumePreview();
      }
    }
  }

  void toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  void sendMessage() {
    if (chatMessage.trim().isNotEmpty) {
      setState(() {
        chatMessages.add({
          'isUser': true,
          'message': chatMessage,
          'time': DateTime.now(),
        });
        chatMessage = "";
      });

      // Simulate therapist response after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            chatMessages.add({
              'isUser': false,
              'message':
                  "I understand you're going through a difficult time. Let's focus on your immediate feelings.",
              'time': DateTime.now(),
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (secondsElapsed > 0) {
      sessionTimer.cancel();
    }
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Session'),
        backgroundColor: Colors.red.shade700,
      ),
      body: isConnecting ? _buildConnectingScreen() : _buildCallScreen(),
      floatingActionButton: isConnecting
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportChatScreen()),
                );
              },
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.support_agent),
              tooltip: 'Contact Support',
            )
          : null,
    );
  }

  Widget _buildConnectingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade600),
          ),
          SizedBox(height: 24),
          Text(
            'Connecting to Emergency Therapist...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Priority connection in progress',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.priority_high,
                  color: Colors.red.shade700,
                  size: 36,
                ),
                SizedBox(height: 8),
                Text(
                  'Emergency Protocol Activated',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You will be connected to the next available emergency therapist',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallScreen() {
    return Stack(
      children: [
        // Full screen "other person" video
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: Center(
            child: Icon(
              Icons.person,
              size: 150,
              color: Colors.white38,
            ),
          ),
        ),

        // Self video small overlay - this is where we show our camera feed
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isCameraInitialized && !isVideoOff
                  ? CameraPreview(cameraController!)
                  : Center(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
            ),
          ),
        ),

        // Emergency indicator
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'EMERGENCY SESSION',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Connected to info
        Positioned(
          top: 70,
          left: 16,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                  radius: 16,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Emily Johnson',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Emergency Specialist',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Session time
        Positioned(
          top: 120,
          left: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  sessionTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Chat panel if open
        if (isChatOpen)
          Positioned(
            bottom: 100,
            right: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Emergency Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: toggleChat,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: chatMessages.isEmpty
                        ? Center(
                            child: Text(
                              'Your messages will appear here',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: chatMessages.length,
                            itemBuilder: (context, index) {
                              final message = chatMessages[index];
                              return Align(
                                alignment: message['isUser']
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 8,
                                    left: message['isUser'] ? 50 : 0,
                                    right: message['isUser'] ? 0 : 50,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: message['isUser']
                                        ? Colors.blue.shade100
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['message'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${message['time'].hour.toString().padLeft(2, '0')}:${message['time'].minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              chatMessage = value;
                            },
                            onSubmitted: (value) {
                              sendMessage();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.red.shade700,
                          child: IconButton(
                            icon:
                                Icon(Icons.send, color: Colors.white, size: 18),
                            onPressed: sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Call controls
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCallControlButton(
                isVideoOff ? Icons.videocam : Icons.videocam_off,
                isVideoOff ? Colors.grey.shade800 : Colors.red.shade700,
                onPressed: toggleVideo,
              ),
              _buildCallControlButton(
                isMicMuted ? Icons.mic : Icons.mic_off,
                isMicMuted ? Colors.grey.shade800 : Colors.red.shade700,
                onPressed: toggleMic,
              ),
              _buildCallControlButton(
                Icons.chat,
                isChatOpen ? Colors.green.shade700 : Colors.grey.shade800,
                onPressed: toggleChat,
              ),
              _buildCallControlButton(
                Icons.call_end,
                Colors.red.shade700,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCallControlButton(IconData icon, Color color,
      {VoidCallback? onPressed}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 28,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed ?? () {},
      ),
    );
  }
}

extension on CameraController {
  void setAudioMode(bool bool) {}
}
