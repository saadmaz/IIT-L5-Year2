import 'package:flutter/material.dart';
import 'understanding_muscle_strains.dart';
import 'effective_stretching_techniques.dart';
import 'rehabilitation_exercises.dart';
import 'preventing_common_sports_injuries.dart';

void main() {
  runApp(MaterialApp(
    home: const EducationalResourcesScreen(),
    theme: ThemeData(
      primaryColor: const Color(0xFF33724B), // Midnight Teal
      scaffoldBackgroundColor: Colors.transparent, // Fully Transparent
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class EducationalResourcesScreen extends StatelessWidget {
  const EducationalResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows transparency effect
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65), // Adjusted AppBar height
        child: AppBar(
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Removes shadow
          centerTitle: true,
          title: const Text(
            "Educational Resources",
            style: TextStyle(
              fontSize: 22, // Adjusted font size
              fontWeight: FontWeight.bold,
              color: Color(0xFF33724B), // Green text (Midnight Teal)
            ),
          ),
          iconTheme: const IconThemeData(
              color: Color(0xFF33724B)), // Green back button
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "To help users comprehend their injuries, the healing process, and preventative measures, this section provides extensive educational resources. This includes detailed information on various injuries, their causes, symptoms, and treatment options.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildResourceCard(
                      context,
                      title: "Understanding Muscle Strains",
                      description:
                          "Learn about muscle strains, their symptoms, and the best recovery practices.",
                      icon: Icons.fitness_center,
                      page: const UnderstandingMuscleStrainsScreen(),
                    ),
                    _buildResourceCard(
                      context,
                      title: "Effective Stretching Techniques",
                      description:
                          "Explore proper stretching methods to prevent injuries and improve flexibility.",
                      icon: Icons.directions_run,
                      page: const EffectiveStretchingTechniquesScreen(),
                    ),
                    _buildResourceCard(
                      context,
                      title: "Rehabilitation Exercises",
                      description:
                          "Discover key exercises that aid in the recovery process after an injury.",
                      icon: Icons.healing,
                      page: const RehabilitationExercisesScreen(),
                    ),
                    _buildResourceCard(
                      context,
                      title: "Preventing Common Sports Injuries",
                      description:
                          "Understand common sports injuries and how to avoid them with proper training.",
                      icon: Icons.sports_soccer,
                      page: const PreventingCommonSportsInjuriesScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required Widget page}) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF33724B)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 18, color: Color(0xFF33724B)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
