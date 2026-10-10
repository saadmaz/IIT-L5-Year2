// lib/screens/profile_screen.dart
// User profile screen

import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/user_model.dart';

/// ProfileScreen displays and allows editing of user profile information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data - in production, this would come from a service
  late User _user;
  bool _isEditing = false;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initControllers();
  }

  /// Load mock user data
  void _loadUserData() {
    _user = User(
      id: 'Saaadmaz',
      email: 'saad@physioconnect.online',
      firstName: 'Saad',
      lastName: 'Mazhar',
      profileImageUrl: null,
      dateJoined: DateTime(2024, 2, 15),
      profile: UserProfile(
        bio: 'Fitness enthusiast looking to improve posture.',
        ageYears: 21,
        heightCm: 170.0,
        weightKg: 70.0,
        gender: 'Male',
        fitnessGoals: ['Improve posture', 'Reduce back pain', 'Build strength'],
        postureIssues: ['Forward head posture', 'Rounded shoulders'],
        medicalConditions: [],
        experienceLevel: 2,
        lastPostureCheck: DateTime.now().subtract(const Duration(days: 1)),
      ),
      settings: UserSettings(
        notificationsEnabled: true,
        notificationTypes: ['Reminders', 'Progress updates'],
        darkModeEnabled: false,
        preferredLanguage: 'en',
        reminderIntervalMinutes: 60,
        hapticFeedbackEnabled: true,
        soundFeedbackEnabled: true,
        autoPostureCheckEnabled: true,
        shareActivityData: false,
        featureToggles: {'experimental_features': false},
      ),
    );
  }

  /// Initialize text controllers with user data
  void _initControllers() {
    _firstNameController = TextEditingController(text: _user.firstName);
    _lastNameController = TextEditingController(text: _user.lastName);
    _ageController = TextEditingController(
      text: _user.profile.ageYears?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: _user.profile.heightCm?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: _user.profile.weightKg?.toString() ?? '',
    );
    _bioController = TextEditingController(text: _user.profile.bio ?? '');
  }

  /// Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form if canceling edit
        _initControllers();
      }
    });
  }

  /// Save user profile changes
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _user = _user.copyWith(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          profile: _user.profile.copyWith(
            bio: _bioController.text,
            ageYears: int.tryParse(_ageController.text),
            heightCm: double.tryParse(_heightController.text),
            weightKg: double.tryParse(_weightController.text),
          ),
        );
        _isEditing = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.midnightTeal,
        elevation: 0,
        actions: [
          // Edit/Save button
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: AppColors.white,
            ),
            onPressed: _isEditing ? _saveProfile : _toggleEditMode,
            tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _isEditing ? _buildEditForm() : _buildProfileView(),
        ),
      ),
    );
  }

  /// Build the profile view (non-editing mode)
  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileHeader(),
        const SizedBox(height: 24),
        _buildInfoSection('Personal Information', [
          _buildInfoItem(
            'Age',
            '${_user.profile.ageYears ?? "Not specified"} years',
          ),
          _buildInfoItem(
            'Height',
            '${_user.profile.heightCm ?? "Not specified"} cm',
          ),
          _buildInfoItem(
            'Weight',
            '${_user.profile.weightKg ?? "Not specified"} kg',
          ),
          _buildInfoItem('Gender', _user.profile.gender ?? 'Not specified'),
        ]),
        const SizedBox(height: 16),
        _buildInfoSection(
          'Fitness Goals',
          _user.profile.fitnessGoals
              .map((goal) => _buildTagItem(goal))
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildInfoSection(
          'Posture Issues',
          _user.profile.postureIssues
              .map((issue) => _buildTagItem(issue))
              .toList(),
        ),
        const SizedBox(height: 16),
        if (_user.profile.medicalConditions.isNotEmpty)
          _buildInfoSection(
            'Medical Conditions',
            _user.profile.medicalConditions
                .map((condition) => _buildTagItem(condition))
                .toList(),
          ),
        const SizedBox(height: 16),
        _buildInfoSection('Account Information', [
          _buildInfoItem('Email', _user.email),
          _buildInfoItem('Member Since', _formatDate(_user.dateJoined)),
          _buildInfoItem(
            'Last Posture Check',
            _user.profile.lastPostureCheck != null
                ? _formatDate(_user.profile.lastPostureCheck!)
                : 'Never',
          ),
        ]),
        const SizedBox(height: 24),
        _buildLogoutButton(),
      ],
    );
  }

  /// Build the edit form
  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarEdit(),
          const SizedBox(height: 24),
          _buildFormSection('Personal Information', [
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _ageController,
              label: 'Age (years)',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 120) {
                    return 'Please enter a valid age';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _heightController,
              label: 'Height (cm)',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Please enter a valid height';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _weightController,
              label: 'Weight (kg)',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 500) {
                    return 'Please enter a valid weight';
                  }
                }
                return null;
              },
            ),
          ]),
          const SizedBox(height: 16),
          _buildFormSection('Bio', [
            _buildTextField(
              controller: _bioController,
              label: 'About You',
              maxLines: 3,
            ),
          ]),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _toggleEditMode,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.midnightTeal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build profile header with avatar and name
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            _user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (_user.profile.bio != null && _user.profile.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _user.profile.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build avatar display
  Widget _buildAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.aliceBlue,
        border: Border.all(color: AppColors.midnightTeal, width: 3),
        image:
            _user.profileImageUrl != null
                ? DecorationImage(
                  image: NetworkImage(_user.profileImageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          _user.profileImageUrl == null
              ? Center(
                child: Text(
                  _getInitials(_user.fullName),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.midnightTeal,
                  ),
                ),
              )
              : null,
    );
  }

  /// Build avatar edit widget
  Widget _buildAvatarEdit() {
    return Center(
      child: Stack(
        children: [
          _buildAvatar(),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.midnightTeal,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an information section
  Widget _buildInfoSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  /// Build a single info item
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a tag item for goals, issues, etc.
  Widget _buildTagItem(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.aliceBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.midnightTeal.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: AppColors.midnightTeal),
      ),
    );
  }

  /// Build a form section
  Widget _buildFormSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  /// Build a text field for the form
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  /// Build logout button
  Widget _buildLogoutButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Implement logout functionality
        },
        style: TextButton.styleFrom(foregroundColor: AppColors.error),
        child: const Text('Logout', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  /// Get initials from name
  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}';
    } else if (names.isNotEmpty) {
      return names[0][0];
    }
    return '';
  }

  /// Format date as string
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
