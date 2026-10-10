import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final dynamic content;

  const ProfileSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            content is String
                ? Text(content)
                : content is Widget
                    ? content
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}