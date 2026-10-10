import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.currentTheme.brightness == Brightness.dark;

    return FloatingActionButton(
      tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
      backgroundColor: isDark ? Colors.tealAccent.shade700 : Colors.teal,
      elevation: 6,
      onPressed: () => themeProvider.toggleTheme(),
      shape: const CircleBorder(),
      child: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}
