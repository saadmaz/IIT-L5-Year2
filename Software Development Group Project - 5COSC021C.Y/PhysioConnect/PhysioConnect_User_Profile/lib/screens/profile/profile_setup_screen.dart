import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import 'profile_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final SharedPreferences prefs;
  
  const ProfileSetupScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _credentialsController = TextEditingController();
  final _licenseController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();
  
  bool _isLoading = false;
  String? _errorMessage;
  File? _profileImage;
  final List<String> _selectedSpecializations = [];
  
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

  int _currentStep = 0;

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
      });
    }
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        String? profileImageUrl;
        
        // Upload profile image if selected
        if (_profileImage != null) {
          profileImageUrl = await _storageService.uploadProfileImage(_profileImage!);
        }
        
        // Create or update user profile
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
        
        // Navigate to main profile screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(prefs: widget.prefs),
          ),
        );
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
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.darkGreen,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                _submitProfile();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep -= 1;
                });
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : details.onStepContinue,
                        child: Text(
                          _currentStep == 2 ? 'Submit' : 'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ),
                  ],
                ),
              );
            },
            steps: [
              // Step 1: Basic Information
              Step(
                title: const Text('Basic Information'),
                content: Column(
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
                                : null,
                            child: _profileImage == null
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
                  ],
                ),
                isActive: _currentStep >= 0,
              ),
              // Step 2: Professional Information
              Step(
                title: const Text('Professional Details'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 24),
                    // Specializations
                    const Text(
                      'Areas of Specialization',
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
                isActive: _currentStep >= 1,
              ),
              // Step 3: Bio and Additional Information
              Step(
                title: const Text('About You'),
                content: Column(
                  children: [
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
                    const SizedBox(height: 16),
                    // Error message
                    if (_errorMessage != null)
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
                  ],
                ),
                isActive: _currentStep >= 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}