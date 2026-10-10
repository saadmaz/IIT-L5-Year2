import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedMode = 'Taping'; // Default selection

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context).currentTheme.brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        elevation: 3,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // 🌙 Dark Mode Toggle
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: const Text("Dark Mode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: const Text("Toggle between Light and Dark Theme"),
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: Colors.teal.shade600,
              ),
              value: isDark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),

          const SizedBox(height: 24),

          // 🧠 Mode Selector (Taping / Exercise)
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tutorial Mode",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["Taping", "Exercise"].map((mode) {
                      final isSelected = _selectedMode == mode;
                      return ChoiceChip(
                        label: Text(mode),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedMode = mode;
                          });
                          // Optional: trigger a provider or state change
                        },
                        selectedColor: Colors.teal.shade600,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 🧼 Reset or more settings could go here
        ],
      ),
    );
  }
}
