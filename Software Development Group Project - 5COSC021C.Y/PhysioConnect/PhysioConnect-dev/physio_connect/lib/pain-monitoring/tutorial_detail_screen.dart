// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/tutorial_model.dart';

class TutorialDetailScreen extends StatefulWidget {
  final TutorialModel tutorial;

  const TutorialDetailScreen({super.key, required this.tutorial});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _fadeController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=${widget.tutorial.videoId}",
        ) ??
        widget.tutorial.videoId;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    )..addListener(() {
        if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
          setState(() {});
        }
      });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    if (_isPlayerReady && !_controller.value.isFullScreen) {
      _controller.dispose();
    }
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        "https://img.youtube.com/vi/${widget.tutorial.videoId}/0.jpg";

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          debugPrint("YouTube Player Ready");
          _isPlayerReady = true;
        },
        progressIndicatorColor: Colors.teal,
        progressColors: const ProgressBarColors(
          playedColor: Colors.teal,
          handleColor: Colors.tealAccent,
        ),
      ),
      builder: (context, player) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            if (!didPop && _controller.value.isFullScreen) {
              _controller.toggleFullScreenMode();
              await Future.delayed(const Duration(milliseconds: 300));
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFEAF7FF),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // 🧠 Header
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () async {
                            if (_controller.value.isFullScreen) {
                              _controller.toggleFullScreenMode();
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tutorial.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (widget.tutorial.muscle != null)
                                  _buildChip(widget.tutorial.muscle!,
                                      Colors.teal.shade600),
                                const SizedBox(width: 6),
                                _buildChip(widget.tutorial.category,
                                    Colors.teal.shade400),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ▶️ Video
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: player,
                    ),
                  ),

                  // ▶️ Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(Icons.play_arrow, "Play", _controller.play),
                      _actionButton(Icons.pause, "Pause", _controller.pause),
                      _actionButton(Icons.fullscreen, "Fullscreen",
                          _controller.toggleFullScreenMode),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildSummaryCard(widget.tutorial.summary),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "🩺 Instructions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...widget.tutorial.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.teal.shade600, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Step ${index + 1}: $step",
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback? onPressed) {
    return ElevatedButton.icon(
      onPressed: _isPlayerReady ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal.shade100, width: 1.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Text(
        summary,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
