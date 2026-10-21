import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Reusable card widget for displaying EPHR information
/// Used throughout the app for consistent UI elements

class EPHRCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget content;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  
  const EPHRCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.content,
    this.actions,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: elevation ?? theme.cardTheme.elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? 
            theme.cardTheme.shape?.borderRadius as BorderRadius? ?? 
            BorderRadius.circular(12),
      ),
      color: backgroundColor ?? theme.cardTheme.color,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? 
            theme.cardTheme.shape?.borderRadius as BorderRadius? ?? 
            BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card header with title, subtitle, and leading widget
              _buildHeader(theme),
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Card content
              content,
              
              // Card actions if provided
              if (actions != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build the card header with title, subtitle, and leading widget
  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // Leading widget if provided (e.g., icon)
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12),
        ],
        
        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}