import 'package:flutter/material.dart';
import 'package:fe/data/tutorial_data.dart';
import 'package:fe/widgets/tutorial_card.dart';
import 'tutorial_detail_screen.dart';

class TutorialListScreen extends StatefulWidget {
  final String category;

  const TutorialListScreen({super.key, required this.category});

  @override
  State<TutorialListScreen> createState() => _TutorialListScreenState();
}

class _TutorialListScreenState extends State<TutorialListScreen> {
  String searchQuery = "";
  String sortOption = 'Title A-Z';

  @override
  Widget build(BuildContext context) {
    final lowerQuery = searchQuery.toLowerCase();
    List filteredTutorials = tutorials
        .where((t) =>
            t.category.toLowerCase() == widget.category.toLowerCase() &&
            (searchQuery.isEmpty ||
                t.title.toLowerCase().contains(lowerQuery) ||
                (t.muscle?.toLowerCase().contains(lowerQuery) ?? false)))
        .toList();

    // 🧠 Sorting Logic
    if (sortOption == 'Title A-Z') {
      filteredTutorials.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortOption == 'Title Z-A') {
      filteredTutorials.sort((a, b) => b.title.compareTo(a.title));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      body: Column(
        children: [
          // 🧠 Header: Search + Sorting
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F6662), Color(0xFF0E3F3F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.category} Tutorials",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1.2),
                          blurRadius: 2,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔍 Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.15 * 255).toInt()),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search tutorials...',
                        hintStyle: TextStyle(
                            color: Colors.white.withAlpha((0.5 * 255).toInt())),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ⬇️ Sorting Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: sortOption,
                        dropdownColor: Colors.teal.shade800,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        underline: Container(),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              sortOption = newValue;
                            });
                          }
                        },
                        items: <String>['Title A-Z', 'Title Z-A']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 📋 Tutorial List
          Expanded(
            child: filteredTutorials.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    itemCount: filteredTutorials.length,
                    itemBuilder: (context, index) {
                      final tutorial = filteredTutorials[index];
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 250 + index * 80),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: TutorialCard(
                          tutorial: tutorial,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TutorialDetailScreen(
                                  tutorial: tutorial,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 📭 Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied_rounded,
                size: 80, color: Colors.teal.shade300),
            const SizedBox(height: 20),
            const Text(
              "No tutorials match your search.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
