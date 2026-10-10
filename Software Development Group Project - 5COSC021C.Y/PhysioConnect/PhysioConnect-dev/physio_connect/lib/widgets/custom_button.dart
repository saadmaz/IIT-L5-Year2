import 'package:flutter/material.dart';
import '../theme.dart';

/// A customizable button widget that extends ElevatedButton
/// with predefined styling and behavior options
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  /// Creates a customized button with specific styling
  ///
  /// [text] - The text to display on the button
  /// [onPressed] - Callback function when button is pressed
  /// [isFullWidth] - Whether the button should take full available width
  /// [isLoading] - Whether to show a loading indicator instead of the text
  /// [isOutlined] - Whether the button should be outlined style
  /// [icon] - Optional icon to display before the text
  /// [height] - Height of the button (default: 48.0)
  /// [backgroundColor] - Custom background color (defaults to theme primary)
  /// [textColor] - Custom text color (defaults to white or primary based on style)
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.height = 48.0,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine colors based on style and parameters
    final bgColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : AppTheme.midnightTeal);
    final txtColor =
        textColor ?? (isOutlined ? AppTheme.midnightTeal : AppTheme.white);

    // Build the button child (loading indicator or text with optional icon)
    Widget buttonChild =
        isLoading
            ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(txtColor),
              ),
            )
            : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: txtColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.midnightTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: buttonChild,
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: buttonChild,
              ),
    );
  }
}
