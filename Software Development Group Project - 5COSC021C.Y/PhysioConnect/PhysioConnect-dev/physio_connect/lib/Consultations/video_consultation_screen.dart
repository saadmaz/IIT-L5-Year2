import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'support_chat_screen.dart';

class VideoConsultationScreen extends StatefulWidget {
  const VideoConsultationScreen({Key? key}) : super(key: key);

  @override
  _VideoConsultationScreenState createState() =>
      _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  bool isPreviewActive = true;
  bool isMicMuted = false;
  bool isCameraOff = false;
  bool isChatOpen = false;
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;

  // Timer variables
  Timer? _timer;
  int _seconds = 0;
  String _timeString = "00:00:00";

  // Chat messages
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      'therapistName': 'Dr. John Doe',
      'specialty': 'Sports Injury',
      'date': DateTime.now().add(Duration(days: 1)),
      'time': '10:00',
      'image': 'assets/doctor_icon.jpg',
    },
    {
      'therapistName': 'Dr. Lisa Wilson',
      'specialty': 'Sports Rehabilitation',
      'date': DateTime.now().add(Duration(days: 3)),
      'time': '14:00',
      'image': 'assets/doctor_icon.jpg',
    },
    {
      'therapistName': 'Dr. Emily Johnson',
      'specialty': 'Pediatric',
      'date': DateTime.now().add(Duration(days: 5)),
      'time': '11:00',
      'image': 'assets/doctor_icon.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _initCameraController(cameras![selectedCameraIndex]);
    }
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: !isMicMuted,
    );

    try {
      await cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _toggleCamera() {
    if (cameras == null || cameras!.isEmpty) return;
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    _initCameraController(cameras![selectedCameraIndex]);
  }

  void _toggleMicrophone() {
    setState(() {
      isMicMuted = !isMicMuted;
      // In a real app, you would also need to mute the actual microphone
      // This is just updating the UI state
    });
  }

  void _toggleCameraStatus() {
    setState(() {
      isCameraOff = !isCameraOff;
    });
  }

  void _toggleChat() {
    setState(() {
      isChatOpen = !isChatOpen;
    });
  }

  void _togglePreviewScreen(bool active) {
    setState(() {
      isPreviewActive = active;
      if (!active) {
        // Starting the call, ensure chat is closed initially
        isChatOpen = false;

        // Start the call timer
        _startTimer();
      } else {
        // Ending the call, stop the timer
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _seconds = 0;
    _updateTimeString();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _updateTimeString();
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
    _updateTimeString();
  }

  void _updateTimeString() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;

    _timeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'text': messageController.text,
          'isMe': true,
          'time': DateTime.now(),
        });
        messageController.clear();
      });

      // Simulate a response from the doctor after a short delay
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            messages.add({
              'text':
                  'Thanks for your message. Let me address that in our call.',
              'isMe': false,
              'time': DateTime.now(),
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    messageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Consultation'),
        backgroundColor: Colors.green.shade700,
      ),
      body: isPreviewActive ? _buildPreviewScreen(context) : _buildCallScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupportChatScreen()),
          );
        },
        backgroundColor: Colors.green.shade700,
        child: Icon(Icons.support_agent),
        tooltip: 'Contact Support',
      ),
    );
  }

  Widget _buildPreviewScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Camera preview section
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          color: Colors.black87,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Actual camera preview
              if (cameraController != null &&
                  cameraController!.value.isInitialized)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.grey.shade800,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              // Controls overlay
              Positioned(
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          isCameraOff ? Colors.red : Colors.grey.shade700,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(
                          isCameraOff ? Icons.videocam_off : Icons.videocam,
                          color: Colors.white,
                        ),
                        onPressed: _toggleCameraStatus,
                      ),
                    ),
                    SizedBox(width: 24),
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade700,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(Icons.flip_camera_ios, color: Colors.white),
                        onPressed: _toggleCamera,
                      ),
                    ),
                    SizedBox(width: 24),
                    CircleAvatar(
                      backgroundColor:
                          isMicMuted ? Colors.red : Colors.grey.shade700,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(
                          isMicMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: _toggleMicrophone,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Upcoming appointments section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Upcoming Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: upcomingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = upcomingAppointments[index];
              final formattedDate =
                  DateFormat('EEEE, MMMM d, yyyy').format(appointment['date']);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(appointment['image']),
                  ),
                  title: Text(appointment['therapistName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment['specialty']),
                      Text('$formattedDate at ${appointment['time']}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _togglePreviewScreen(false),
                    child: Text('Join'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              );
            },
          ),
        ),
      ],
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

        // Self video small overlay
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
            child: isCameraOff
                ? Center(
                    child: Icon(
                      Icons.videocam_off,
                      size: 40,
                      color: Colors.white70,
                    ),
                  )
                : (cameraController != null &&
                        cameraController!.value.isInitialized)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white70,
                        ),
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
                isCameraOff ? Icons.videocam_off : Icons.videocam,
                isCameraOff ? Colors.red : Colors.grey.shade800,
                onPressed: _toggleCameraStatus,
              ),
              _buildCallControlButton(
                isMicMuted ? Icons.mic_off : Icons.mic,
                isMicMuted ? Colors.red : Colors.grey.shade800,
                onPressed: _toggleMicrophone,
              ),
              _buildCallControlButton(
                Icons.chat,
                isChatOpen ? Colors.green.shade600 : Colors.grey.shade800,
                onPressed: _toggleChat,
              ),
              _buildCallControlButton(
                Icons.call_end,
                Colors.red,
                onPressed: () => _togglePreviewScreen(true),
              ),
            ],
          ),
        ),

        // Session time and info - Now with real-time timer
        Positioned(
          top: 16,
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
                  _timeString,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Chat overlay when active
        if (isChatOpen)
          Positioned(
            bottom: 100,
            right: 20,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: _toggleChat,
                        ),
                      ],
                    ),
                  ),
                  // Chat messages
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return Align(
                                alignment: message['isMe']
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: 12,
                                    left: message['isMe'] ? 50 : 0,
                                    right: message['isMe'] ? 0 : 50,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: message['isMe']
                                        ? Colors.green.shade100
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(message['text']),
                                      SizedBox(height: 4),
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(message['time']),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  // Message input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
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
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.green.shade700),
                          onPressed: _sendMessage,
                        ),
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
