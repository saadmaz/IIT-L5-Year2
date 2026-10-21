// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/ephr_service.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/chart_widgets.dart';

/// Add Pain Entry Screen
/// Allows patients to record new pain incidents
/// Includes pain scale, body part selector, and additional details

class AddPainEntryScreen extends StatefulWidget {
  const AddPainEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddPainEntryScreen> createState() => _AddPainEntryScreenState();
}

class _AddPainEntryScreenState extends State<AddPainEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Form fields
  double _painLevel = 5;
  String? _selectedBodyPart;
  String? _selectedPainType;
  List<String> _selectedTriggers = [];
  
  // Controllers
  final _descriptionController = TextEditingController();
  final _medicationTakenController = TextEditingController();
  final _treatmentAppliedController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Predefined options
  final List<String> _bodyParts = [
    'Head',
    'Neck',
    'Shoulder (Right)',
    'Shoulder (Left)',
    'Arm (Right)',
    'Arm (Left)',
    'Elbow (Right)',
    'Elbow (Left)',
    'Wrist (Right)',
    'Wrist (Left)',
    'Hand (Right)',
    'Hand (Left)',
    'Chest',
    'Back (Upper)',
    'Back (Middle)',
    'Back (Lower)',
    'Abdomen',
    'Hip (Right)',
    'Hip (Left)',
    'Leg (Right)',
    'Leg (Left)',
    'Knee (Right)',
    'Knee (Left)',
    'Ankle (Right)',
    'Ankle (Left)',
    'Foot (Right)',
    'Foot (Left)',
  ];
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _medicationTakenController.dispose();
    _treatmentAppliedController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  /// Submit pain entry form
  Future<void> _submitForm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;
    
    // Validate required fields
    if (_selectedBodyPart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a body part'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final ephrService = Provider.of<EPHRService>(context, listen: false);
      
      // Set auth token
      ephrService.setAuthToken(authService.authToken ?? '');
      
      final userId = authService.userState.currentUser?.id ?? '';
      
      // Prepare pain entry data
      final painEntryData = {
        'patientId': userId,
        'recordedAt': DateTime.now().toIso8601String(),
        'painLevel': _painLevel.round(),
        'bodyPart': _selectedBodyPart,
        'painType': _selectedPainType,
        'description': _descriptionController.text,
        'triggers': _selectedTriggers.isNotEmpty ? _selectedTriggers : null,
        'medicationTaken': _medicationTakenController.text.isNotEmpty 
            ? _medicationTakenController.text 
            : null,
        'treatmentApplied': _treatmentAppliedController.text.isNotEmpty 
            ? _treatmentAppliedController.text 
            : null,
        'notes': _notesController.text.isNotEmpty 
            ? _notesController.text 
            : null,
      };
      
      // API call would be implemented here
      // For now, just simulate a delay
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isLoading = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pain entry recorded successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to pain tracker screen
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recording pain entry: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(
        title: 'Add Pain Entry',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pain level section
                    _buildSectionTitle('Pain Level'),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pain scale slider
                            PainScaleWidget(
                              value: _painLevel,
                              onChanged: (value) {
                                setState(() {
                                  _painLevel = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Body part section
                    _buildSectionTitle('Body Part'),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Body part dropdown
                            EPHRDropdownField<String>(
                              label: 'Affected Area',
                              value: _selectedBodyPart,
                              hint: 'Select body part',
                              items: _bodyParts.map((part) {
                                return DropdownMenuItem<String>(
                                  value: part,
                                  child: Text(part),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBodyPart = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Pain details section
                    _buildSectionTitle('Pain Details'),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pain type dropdown
                            EPHRDropdownField<String>(
                              label: 'Pain Type',
                              value: _selectedPainType,
                              hint: 'Select pain type (optional)',
                              items: AppConstants.painCategories.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPainType = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Description field
                            EPHRTextField(
                              label: 'Description',
                              hint: 'Describe the pain (optional)',
                              controller: _descriptionController,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Triggers section
                    _buildSectionTitle('Triggers'),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select any factors that may have triggered or worsened the pain:',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Trigger checkboxes
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _buildTriggerChip('Physical Activity'),
                                _buildTriggerChip('Stress'),
                                _buildTriggerChip('Weather Change'),
                                _buildTriggerChip('Poor Posture'),
                                _buildTriggerChip('Lack of Sleep'),
                                _buildTriggerChip('Food/Diet'),
                                _buildTriggerChip('Sitting/Standing'),
                                _buildTriggerChip('Medication'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Treatment section
                    _buildSectionTitle('Treatment & Notes'),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Medication field
                            EPHRTextField(
                              label: 'Medication Taken',
                              hint: 'Any medication taken for the pain (optional)',
                              controller: _medicationTakenController,
                            ),
                            const SizedBox(height: 16),
                            
                            // Treatment field
                            EPHRTextField(
                              label: 'Treatment Applied',
                              hint: 'Any treatment applied (e.g., ice, heat) (optional)',
                              controller: _treatmentAppliedController,
                            ),
                            const SizedBox(height: 16),
                            
                            // Notes field
                            EPHRTextField(
                              label: 'Additional Notes',
                              hint: 'Any other information (optional)',
                              controller: _notesController,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Save Pain Entry',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
  
  /// Build a section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.midnightTeal,
      ),
    );
  }
  
  /// Build a trigger chip
  Widget _buildTriggerChip(String label) {
    final isSelected = _selectedTriggers.contains(label);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.midnightTeal.withOpacity(0.2),
      checkmarkColor: AppTheme.midnightTeal,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTriggers.add(label);
          } else {
            _selectedTriggers.remove(label);
          }
        });
      },
    );
  }
}