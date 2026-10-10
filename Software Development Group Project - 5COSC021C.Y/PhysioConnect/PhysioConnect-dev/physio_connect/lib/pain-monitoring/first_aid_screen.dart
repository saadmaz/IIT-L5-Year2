// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'tutorial_list_screen.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen>
    with TickerProviderStateMixin {
  final List<String> categories = [
    'Arms',
    'Legs',
    'Chest',
    'Abdomen',
    'Shoulders',
    'Upper Back',
    'Lower Back',
    'Glutes',
    'Hamstrings'
  ];

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollToCenter(_tabController.index);
        setState(() {}); // Refresh chips
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCenter(int index) {
    final double chipWidth = 100;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        (index * (chipWidth + 12)) - (screenWidth - chipWidth) / 2;

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F6662), Color(0xFF0E3F3F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'First Aid Tutorials',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1.5),
                        blurRadius: 2,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _tabController.index == index;
                      final category = categories[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            _tabController.animateTo(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.tealAccent.shade100
                                  : Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.25),
                                width: 1.2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      size: 16, color: Colors.teal),
                                if (isSelected) const SizedBox(width: 6),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isSelected
                                        ? const Color(0xFF0E3F3F)
                                        : Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: TutorialListScreen(
              key: ValueKey(category),
              category: category,
            ),
          );
        }).toList(),
      ),
    );
  }
}
