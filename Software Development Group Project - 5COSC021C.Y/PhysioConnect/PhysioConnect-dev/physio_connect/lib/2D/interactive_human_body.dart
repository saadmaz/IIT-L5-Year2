import 'package:flutter/material.dart';
import 'muscle_selection_page.dart';

class InteractiveHumanBody extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const InteractiveHumanBody({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<InteractiveHumanBody> createState() => _InteractiveHumanBodyState();
}

class _InteractiveHumanBodyState extends State<InteractiveHumanBody> {
  String currentView = 'front';
  bool isMale = true;
  List<String> selectedParts = [];

  void changeView(String view) {
    setState(() {
      currentView = view;
      selectedParts.clear();
    });
  }

  void toggleGender() {
    setState(() {
      isMale = !isMale;
      selectedParts.clear();
    });
  }

  void proceedToMuscleSelection(String bodyPart) {
    List<String> muscles = _muscles[bodyPart] ?? [];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MuscleSelectionPage(
          bodyPart: bodyPart,
          muscles: muscles,
          isDarkMode: widget.isDarkMode,
          onSelectionComplete: (selectedMuscles) {
            debugPrint("Muscle selection completed for $bodyPart: $selectedMuscles");
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/';
    imagePath += isMale
        ? (currentView == 'front'
            ? 'front.png'
            : currentView == 'back'
                ? 'back.png'
                : 'side_right.png')
        : (currentView == 'front'
            ? 'front_female.png'
            : currentView == 'back'
                ? 'back_female.png'
                : 'side_female.png');

    List<String> bodyParts = _bodyParts[currentView] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF06130D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5F3A),
        title: const Text(
          'PhysioConnect: Human Body',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildModernButton("Front", () => changeView('front')),
                const SizedBox(width: 12),
                _buildModernButton("Back", () => changeView('back')),
                const SizedBox(width: 12),
                _buildModernButton("Side", () => changeView('side_right')),
                const SizedBox(width: 12),
                _buildModernButton(isMale ? "Female View" : "Male View", toggleGender),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Row(
              children: [
                _buildSideBodyPartList(bodyParts),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        imagePath,
                        width: MediaQuery.of(context).size.width * 0.55,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF33724B),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSideBodyPartList(List<String> parts) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: ListView.separated(
          itemCount: parts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildBodyPartButton(parts[index]),
        ),
      ),
    );
  }

  Widget _buildBodyPartButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton(
        onPressed: () => proceedToMuscleSelection(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF33724B),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  final Map<String, List<String>> _bodyParts = {
    'front': ['Head', 'Chest', 'Abdomen', 'Arms', 'Legs'],
    'back': ['Upper Back', 'Lower Back', 'Shoulders', 'Glutes', 'Hamstrings'],
  };

  final Map<String, List<String>> _muscles = {
    'Head': [
      'Clavicular Head of Sternocleidomastoid Muscle',
      'Depressor Anguli Oris Muscle',
      'Depressor Labii Inferioris Muscle',
      'Frontal Belly of Epicranius Muscle (Frontalis Muscle)',
      'Galea Aponeurotica',
      'Levator Labii Superioris Alaeque Nasi Muscle',
      'Levator Labii Superioris Muscle',
      'Masseter Muscle',
      'Mentalis Muscle',
      'Nasalis Muscle',
      'Occipital Belly of Epicranius Muscle (Occipitalis Muscle)',
      'Omohyoid Muscle',
      'Orbicularis Oculi Muscle',
      'Orbicularis Oris Muscle',
      'Platysma Muscle',
      'Risorius Muscle',
      'Scalene Muscles',
      'Semispinalis Capitis Muscle',
      'Splenius Capitis Muscle',
      'Sternal Head of Sternocleidomastoid Muscle',
      'Temporalis Muscle',
      'Zygomaticus Major Muscle',
      'Zygomaticus Minor Muscle',
    ],
  };
}