import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _credentialsController;
  late TextEditingController _licenseController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _experienceController;
  
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  
  bool _isLoading = false;
  String? _errorMessage;
  File? _profileImage;
  List<String> _selectedSpecializations = [];
  String? _profileImageUrl;
  
  final List<String> _specializations = [
    'Sports Rehabilitation',
    'Orthopedic',
    'Neurological',
    'Pediatric',
    'Geriatric',
    'Cardiopulmonary',
    'Women\'s Health',
    'Manual Therapy',
    'Vestibular Rehabilitation',
    'Pain Management',
    'Post-surgical Rehabilitation',
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.user.name);
    _credentialsController = TextEditingController(text: widget.user.professionalCredentials ?? '');
    _licenseController = TextEditingController(text: widget.user.licenseNumber ?? '');
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _experienceController = TextEditingController(text: (widget.user.yearsOfExperience ?? 0).toString());
    
    if (widget.user.specializations != null) {
      _selectedSpecializations = List.from(widget.user.specializations!);
    }
    
    _profileImageUrl = widget.user.profilePicture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _credentialsController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _profileImageUrl = null;  // Clear existing URL since we have a new image
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        String? profileImageUrl = _profileImageUrl;
        
        // Upload new profile image if selected
        if (_profileImage != null) {
          profileImageUrl = await _storageService.uploadProfileImage(_profileImage!);
        }
        
        // Update user profile
        await _userService.setupProfile(
          name: _nameController.text.trim(),
          professionalCredentials: _credentialsController.text.trim(),
          licenseNumber: _licenseController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          bio: _bioController.text.trim(),
          specializations: _selectedSpecializations,
          yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 0,
          profilePicture: profileImageUrl,
        );
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _updateProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppTheme.lightGreen,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (_profileImageUrl != null
                                    ? NetworkImage(_profileImageUrl!)
                                    : null) as ImageProvider<Object>?,
                            child: (_profileImage == null && _profileImageUrl == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppTheme.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Error message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade800),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Full Name
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Professional Credentials
                    CustomTextField(
                      controller: _credentialsController,
                      label: 'Professional Credentials',
                      hint: 'E.g. PT, DPT, CSCS',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your credentials';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // License Number
                    CustomTextField(
                      controller: _licenseController,
                      label: 'License Number',
                      hint: 'Enter your professional license number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your license number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Years of Experience
                    CustomTextField(
                      controller: _experienceController,
                      label: 'Years of Experience',
                      hint: 'Enter years of professional experience',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your experience';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Specializations
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Areas of Specialization',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _specializations.map((specialization) {
                            final isSelected = _selectedSpecializations.contains(specialization);
                            return FilterChip(
                              label: Text(specialization),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSpecializations.add(specialization);
                                  } else {
                                    _selectedSpecializations.remove(specialization);
                                  }
                                });
                              },
                              selectedColor: AppTheme.lightGreen,
                              checkmarkColor: AppTheme.darkGreen,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bio
                    CustomTextField(
                      controller: _bioController,
                      label: 'Professional Bio',
                      hint: 'Tell us about your professional background and approach',
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}