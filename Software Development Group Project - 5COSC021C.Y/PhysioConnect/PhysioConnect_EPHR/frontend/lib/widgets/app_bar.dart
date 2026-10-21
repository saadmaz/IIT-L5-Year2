import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../services/auth_service.dart';

/// Custom app bar widget for use across the app
/// Features profile icon, title, and optional action buttons

class EPHRAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showProfileIcon;
  final VoidCallback? onProfileTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  
  const EPHRAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.showProfileIcon = true,
    this.onProfileTap,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<AuthService>(context).userState;
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: elevation,
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: foregroundColor ?? theme.appBarTheme.foregroundColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: [
        // Show profile icon if requested
        if (showProfileIcon)
          InkWell(
            onTap: onProfileTap ?? () {
              // Navigate to profile screen
              Navigator.pushNamed(context, '/patient/profile');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CircleAvatar(
                backgroundColor: AppTheme.aliceBlue,
                radius: 18,
                child: ClipOval(
                  child: userState.currentUser?.profileImageUrl != null
                      ? Image.network(
                          userState.currentUser!.profileImageUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: AppTheme.midnightTeal,
                              size: 18,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          color: AppTheme.midnightTeal,
                          size: 18,
                        ),
                ),
              ),
            ),
          ),
        // Add any additional actions
        if (actions != null) ...actions!,
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}