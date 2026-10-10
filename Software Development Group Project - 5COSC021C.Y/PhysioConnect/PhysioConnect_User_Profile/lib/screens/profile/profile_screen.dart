// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/user_model.dart';
// import '../../models/user_stats.dart';
// import '../../services/user_service.dart';
// import '../../theme/app_theme.dart';
// import '../../widgets/profile_section.dart';
// import '../../widgets/achievement_card.dart';
// import '../../widgets/stats_card.dart';
// import 'edit_profile_screen.dart';
// import 'settings_screen.dart';
// import 'activity_history_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   final SharedPreferences prefs;

//   const ProfileScreen({Key? key, required this.prefs}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   final UserService _userService = UserService();
//   late TabController _tabController;
//   bool _isLoading = true;
//   User? _user;
//   UserStats? _userStats;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadUserProfile();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserProfile() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final user = await _userService.getCurrentUser();
//       final userStats = await _userService.getUserStats();

//       setState(() {
//         _user = user;
//         _userStats = userStats;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _errorMessage != null
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Error loading profile',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(_errorMessage!),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _loadUserProfile,
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               )
//               : _buildProfileContent(),
//     );
//   }

//   Widget _buildProfileContent() {
//     return CustomScrollView(
//       slivers: [
//         // App Bar
//         SliverAppBar(
//           expandedHeight: 200.0,
//           floating: false,
//           pinned: true,
//           backgroundColor: AppTheme.primaryColor,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.settings),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsScreen(prefs: widget.prefs),
//                   ),
//                 ).then((_) => _loadUserProfile());
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditProfileScreen(user: _user!),
//                   ),
//                 ).then((_) => _loadUserProfile());
//               },
//             ),
//           ],
//           flexibleSpace: FlexibleSpaceBar(
//             title: Text(_user?.name ?? ''),
//             background: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Container(color: AppTheme.primaryColor),
//                 Positioned(
//                   top: 50,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: AppTheme.white,
//                       backgroundImage:
//                           _user?.profilePicture != null
//                               ? NetworkImage(_user!.profilePicture!)
//                               : null,
//                       child:
//                           _user?.profilePicture == null
//                               ? const Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: AppTheme.darkGreen,
//                               )
//                               : null,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Credentials and Specializations
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Credentials
//                 Center(
//                   child: Text(
//                     _user?.professionalCredentials ?? '',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: AppTheme.darkGreen,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Years of Experience
//                 Center(
//                   child: Text(
//                     '${_user?.yearsOfExperience ?? 0} years of experience',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppTheme.darkGrey,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Specializations
//                 if (_user?.specializations != null &&
//                     _user!.specializations!.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Specializations',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: AppTheme.darkGreen,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children:
//                             _user!.specializations!.map((specialization) {
//                               return Chip(
//                                 label: Text(specialization),
//                                 backgroundColor: AppTheme.accentGreen,
//                                 labelStyle: const TextStyle(
//                                   color: AppTheme.darkGreen,
//                                 ),
//                               );
//                             }).toList(),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),

//         // Tab Bar
//         SliverPersistentHeader(
//           delegate: _SliverAppBarDelegate(
//             TabBar(
//               controller: _tabController,
//               labelColor: AppTheme.primaryColor,
//               unselectedLabelColor: AppTheme.darkGrey,
//               indicatorColor: AppTheme.primaryColor,
//               tabs: const [
//                 Tab(text: 'About'),
//                 Tab(text: 'Achievements'),
//                 Tab(text: 'Professional Development'),
//               ],
//             ),
//           ),
//           pinned: true,
//         ),

//         // Tab View
//         SliverFillRemaining(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               // About Tab
//               _buildAboutTab(),

//               // Achievements Tab
//               _buildAchievementsTab(),

//               // Professional Development Tab
//               _buildProfessionalDevelopmentTab(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAboutTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ProfileSection(
//             title: 'Bio',
//             content: _user?.bio ?? 'No bio available',
//           ),
//           const SizedBox(height: 16),
//           ProfileSection(
//             title: 'Contact Information',
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.email, color: AppTheme.darkGreen),
//                     const SizedBox(width: 8),
//                     Text(_user?.email ?? ''),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.phone, color: AppTheme.darkGreen),
//                     const SizedBox(width: 8),
//                     Text(_user?.phoneNumber ?? ''),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           ProfileSection(
//             title: 'License Information',
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'License Number: ${_user?.licenseNumber ?? 'Not provided'}',
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ActivityHistoryScreen(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.history),
//             label: const Text('View Activity History'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAchievementsTab() {
//     if (_userStats == null || _userStats!.achievements.isEmpty) {
//       return const Center(child: Text('No achievements yet'));
//     }

//     return ListView(
//       padding: const EdgeInsets.all(16.0),
//       children: [
//         // Statistics Summary
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             StatsCard(
//               title: 'Appointments',
//               value: _userStats!.completedAppointments.toString(),
//               icon: Icons.calendar_today,
//             ),
//             StatsCard(
//               title: 'Patients',
//               value: _userStats!.totalPatients.toString(),
//               icon: Icons.people,
//             ),
//             StatsCard(
//               title: 'Connections',
//               value: _userStats!.connectionCount.toString(),
//               icon: Icons.link,
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           'Your Achievements',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: AppTheme.darkGreen,
//           ),
//         ),
//         const SizedBox(height: 16),
//         // Achievements list
//         ...List.generate(
//           _userStats!.achievements.length,
//           (index) => Padding(
//             padding: const EdgeInsets.only(bottom: 16.0),
//             child: AchievementCard(
//               achievement: _userStats!.achievements[index],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProfessionalDevelopmentTab() {
//     if (_userStats == null || _userStats!.professionalDevelopments.isEmpty) {
//       return const Center(
//         child: Text('No professional development records yet'),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(16.0),
//       children: [
//         // Add new development button
//         ElevatedButton.icon(
//           onPressed: () {
//             // TODO: Navigate to add professional development screen
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('Add New Entry'),
//           style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkGreen),
//         ),
//         const SizedBox(height: 24),
//         // Professional development list
//         ...List.generate(_userStats!.professionalDevelopments.length, (index) {
//           final development = _userStats!.professionalDevelopments[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppTheme.accentGreen,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           development.type.toUpperCase(),
//                           style: const TextStyle(
//                             color: AppTheme.darkGreen,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Completed ${_formatDate(development.completionDate)}',
//                         style: const TextStyle(
//                           color: AppTheme.darkGrey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     development.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (development.provider != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       'Provider: ${development.provider}',
//                       style: const TextStyle(color: AppTheme.darkGrey),
//                     ),
//                   ],
//                   if (development.creditHours != null) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       'Credit Hours: ${development.creditHours}',
//                       style: const TextStyle(
//                         color: AppTheme.darkGreen,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                   if (development.description != null) ...[
//                     const SizedBox(height: 8),
//                     Text(development.description!),
//                   ],
//                   if (development.certificateUrl != null) ...[
//                     const SizedBox(height: 12),
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         // TODO: View certificate
//                       },
//                       icon: const Icon(Icons.description),
//                       label: const Text('View Certificate'),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;

//   _SliverAppBarDelegate(this._tabBar);

//   @override
//   double get minExtent => _tabBar.preferredSize.height;

//   @override
//   double get maxExtent => _tabBar.preferredSize.height;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: _tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../models/user_stats.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profile_section.dart';
import '../../widgets/achievement_card.dart';
import '../../widgets/stats_card.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'activity_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  final SharedPreferences prefs;
  
  const ProfileScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  late TabController _tabController;
  bool _isLoading = true;
  User? _user;
  UserStats? _userStats;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _userService.getCurrentUser();
      final userStats = await _userService.getUserStats();
      
      setState(() {
        _user = user;
        _userStats = userStats;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading profile',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(prefs: widget.prefs),
                  ),
                ).then((_) => _loadUserProfile());
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: _user!),
                  ),
                ).then((_) => _loadUserProfile());
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_user?.name ?? ''),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: AppTheme.primaryColor,
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.white,
                      backgroundImage: _user?.profilePicture != null
                          ? NetworkImage(_user!.profilePicture!)
                          : null,
                      child: _user?.profilePicture == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: AppTheme.darkGreen,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Credentials and Specializations
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Credentials
                Center(
                  child: Text(
                    _user?.professionalCredentials ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Years of Experience
                Center(
                  child: Text(
                    '${_user?.yearsOfExperience ?? 0} years of experience',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Specializations
                if (_user?.specializations != null && _user!.specializations!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specializations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _user!.specializations!.map((specialization) {
                          return Chip(
                            label: Text(specialization),
                            backgroundColor: AppTheme.accentGreen,
                            labelStyle: const TextStyle(color: AppTheme.darkGreen),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // Tab Bar
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.darkGrey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Achievements'),
                Tab(text: 'Professional Development'),
              ],
            ),
          ),
          pinned: true,
        ),

        // Tab View
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              // About Tab
              _buildAboutTab(),
              
              // Achievements Tab
              _buildAchievementsTab(),
              
              // Professional Development Tab
              _buildProfessionalDevelopmentTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSection(
            title: 'Bio',
            content: _user?.bio ?? 'No bio available',
          ),
          const SizedBox(height: 16),
          ProfileSection(
            title: 'Contact Information',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.email, color: AppTheme.darkGreen),
                    const SizedBox(width: 8),
                    Text(_user?.email ?? ''),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: AppTheme.darkGreen),
                    const SizedBox(width: 8),
                    Text(_user?.phoneNumber ?? ''),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProfileSection(
            title: 'License Information',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('License Number: ${_user?.licenseNumber ?? 'Not provided'}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('View Activity History'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    if (_userStats == null || _userStats!.achievements.isEmpty) {
      return const Center(
        child: Text('No achievements yet'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Statistics Summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsCard(
              title: 'Appointments',
              value: _userStats!.completedAppointments.toString(),
              icon: Icons.calendar_today,
            ),
            StatsCard(
              title: 'Patients',
              value: _userStats!.totalPatients.toString(),
              icon: Icons.people,
            ),
            StatsCard(
              title: 'Connections',
              value: _userStats!.connectionCount.toString(),
              icon: Icons.link,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Your Achievements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGreen,
          ),
        ),
        const SizedBox(height: 16),
        // Achievements list
        ...List.generate(
          _userStats!.achievements.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AchievementCard(
              achievement: _userStats!.achievements[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalDevelopmentTab() {
    if (_userStats == null || _userStats!.professionalDevelopments.isEmpty) {
      return const Center(
        child: Text('No professional development records yet'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Add new development button
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to add professional development screen
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Entry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkGreen,
          ),
        ),
        const SizedBox(height: 24),
        // Professional development list
        ...List.generate(
          _userStats!.professionalDevelopments.length,
          (index) {
            final development = _userStats!.professionalDevelopments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            development.type.toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Completed ${_formatDate(development.completionDate)}',
                          style: const TextStyle(
                            color: AppTheme.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      development.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (development.provider != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Provider: ${development.provider}',
                        style: const TextStyle(
                          color: AppTheme.darkGrey,
                        ),
                      ),
                    ],
                    if (development.creditHours != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Credit Hours: ${development.creditHours}',
                        style: const TextStyle(
                          color: AppTheme.darkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    if (development.description != null) ...[
                      const SizedBox(height: 8),
                      Text(development.description!),
                    ],
                    if (development.certificateUrl != null) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: View certificate
                        },
                        icon: const Icon(Icons.description),
                        label: const Text('View Certificate'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}