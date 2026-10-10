import 'package:flutter/material.dart';
import 'rehabilitation_workouts.dart';
import 'strength_training.dart';
import 'flexibility_mobility.dart';
import 'balance_stability.dart';
import 'cardio_recovery.dart';

class CustomExercisePlansScreen extends StatefulWidget {
  const CustomExercisePlansScreen({super.key});

  @override
  _CustomExercisePlansScreenState createState() =>
      _CustomExercisePlansScreenState();
}

class _CustomExercisePlansScreenState extends State<CustomExercisePlansScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = -1; // Stores the selected category index

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              "Customized Exercise Plans",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33724B)),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF33724B)),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // ignore: deprecated_member_use
                  Colors.white.withOpacity(0.1),
                  // ignore: deprecated_member_use
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      "Generate personalized workout plans based on your injury history and recovery needs. Improve strength, flexibility, and prevent future injuries.",
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildPlanCard(
                          context,
                          index: 0,
                          title: "Rehabilitation Workouts",
                          description:
                              "Targeted exercises to aid recovery and prevent re-injury.",
                          icon: Icons.healing,
                          screen: const RehabilitationWorkoutsScreen(),
                        ),
                        _buildPlanCard(
                          context,
                          index: 1,
                          title: "Strength Training for Recovery",
                          description:
                              "Gradual strength-building exercises suited for injury recovery.",
                          icon: Icons.fitness_center,
                          screen: const StrengthTrainingScreen(),
                        ),
                        _buildPlanCard(
                          context,
                          index: 2,
                          title: "Flexibility & Mobility",
                          description:
                              "Custom stretching routines to regain full mobility and prevent stiffness.",
                          icon: Icons.self_improvement,
                          screen: const FlexibilityMobilityScreen(),
                        ),
                        _buildPlanCard(
                          context,
                          index: 3,
                          title: "Balance & Stability Training",
                          description:
                              "Exercises to enhance coordination and prevent falls.",
                          icon: Icons.accessibility_new,
                          screen: const BalanceStabilityScreen(),
                        ),
                        _buildPlanCard(
                          context,
                          index: 4,
                          title: "Cardio for Safe Recovery",
                          description:
                              "Low-impact cardiovascular routines that promote endurance without strain.",
                          icon: Icons.directions_run,
                          screen: const CardioRecoveryScreen(),
                        ),
                      ],
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

  Widget _buildPlanCard(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required IconData icon,
    required Widget screen,
  }) {
    return TweenAnimationBuilder(
      duration:
          Duration(milliseconds: 500 + (index * 100)), // Staggered animation
      curve: Curves.easeOut,
      tween: Tween<double>(begin: -30, end: 0),
      builder: (context, double offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index; // Update selected category
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => screen));
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? const Color(0xFF33724B)
                      : Colors.white, // Change color when selected
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        transform: Matrix4.diagonal3Values(
                          _selectedIndex == index ? 1.2 : 1.0,
                          _selectedIndex == index ? 1.2 : 1.0,
                          1.0,
                        ),
                        child: Icon(
                          icon,
                          size: 40,
                          color: _selectedIndex == index
                              ? Colors.white
                              : const Color(0xFF33724B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedIndex == index
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: _selectedIndex == index
                            ? Colors.white
                            : const Color(0xFF33724B),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
