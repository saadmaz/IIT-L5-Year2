// File: frontend/lib/features/ehpr/screens/assessment/assessment_form_screen.dart

import 'package:flutter/material.dart';
import '../../../../config/constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class AssessmentFormScreen extends StatefulWidget {
  const AssessmentFormScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentFormScreen> createState() => _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends State<AssessmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _patientNameController = TextEditingController();
  final _chiefComplaintController = TextEditingController();
  final _historyController = TextEditingController();
  final _objectiveFindingsController = TextEditingController();
  final _assessmentController = TextEditingController();
  final _planController = TextEditingController();

  // Form values
  int _painLevel = 0;
  final List<String> _selectedBodyParts = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    _chiefComplaintController.dispose();
    _historyController.dispose();
    _objectiveFindingsController.dispose();
    _assessmentController.dispose();
    _planController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // In a real app, this would send data to an API
        final assessmentData = {
          'patientName': _patientNameController.text,
          'chiefComplaint': _chiefComplaintController.text,
          'history': _historyController.text,
          'objectiveFindings': _objectiveFindingsController.text,
          'assessment': _assessmentController.text,
          'plan': _planController.text,
          'painLevel': _painLevel,
          'bodyParts': _selectedBodyParts,
        };

        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assessment saved successfully'),
              backgroundColor: AppColors.midnightTeal,
            ),
          );

          // Navigate back
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving assessment: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildBodyPartChip(String bodyPart) {
    final isSelected = _selectedBodyParts.contains(bodyPart);
    return FilterChip(
      label: Text(bodyPart),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedBodyParts.add(bodyPart);
          } else {
            _selectedBodyParts.remove(bodyPart);
          }
        });
      },
      backgroundColor: AppColors.aliceBlue,
      selectedColor: AppColors.midnightTeal.withOpacity(0.2),
      checkmarkColor: AppColors.midnightTeal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Assessment'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Information
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Patient Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _patientNameController,
                              label: 'Patient Name',
                              hint: 'Enter patient name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter patient name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.search),
                              label: const Text('Search Patient'),
                              onPressed: () {
                                // Show patient search dialog
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Chief Complaint
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chief Complaint',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),

                            CustomTextField(
                              controller: _chiefComplaintController,
                              label: 'Chief Complaint',
                              hint: 'Enter chief complaint',
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter chief complaint';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: AppDimensions.paddingMedium),

                            const Text(
                              'Pain Level',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Pain level slider
                            Slider(
                              min: 0,
                              max: 10,
                              divisions: 10,
                              value: _painLevel.toDouble(),
                              label: _painLevel.toString(),
                              activeColor: AppColors.midnightTeal,
                              onChanged: (value) {
                                setState(() {
                                  _painLevel = value.toInt();
                                });
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('No Pain'),
                                Text('Level: $_painLevel'),
                                const Text('Severe'),
                              ],
                            ),

                            const SizedBox(height: AppDimensions.paddingMedium),

                            const Text(
                              'Affected Body Parts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildBodyPartChip('Neck'),
                                _buildBodyPartChip('Lower Back'),
                                _buildBodyPartChip('Upper Back'),
                                _buildBodyPartChip('Left Shoulder'),
                                _buildBodyPartChip('Right Shoulder'),
                                _buildBodyPartChip('Left Knee'),
                                _buildBodyPartChip('Right Knee'),
                                _buildBodyPartChip('Left Hip'),
                                _buildBodyPartChip('Right Hip'),
                                _buildBodyPartChip('Left Ankle'),
                                _buildBodyPartChip('Right Ankle'),
                              ],
                            ),

                            if (_selectedBodyParts.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Text('Selected:'),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: _selectedBodyParts
                                    .map((part) => Chip(
                                          label: Text(part),
                                          deleteIcon:
                                              const Icon(Icons.close, size: 16),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedBodyParts.remove(part);
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // History
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'History',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _historyController,
                              label: 'History of Present Illness',
                              hint: 'Enter detailed history',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter history';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Objective Findings
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Objective Findings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _objectiveFindingsController,
                              label: 'Objective Findings',
                              hint: 'Enter objective examination findings',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter objective findings';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Assessment
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Assessment',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _assessmentController,
                              label: 'Assessment',
                              hint: 'Enter your assessment',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter assessment';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Plan
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Plan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _planController,
                              label: 'Treatment Plan',
                              hint: 'Enter treatment plan',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter treatment plan';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Save Assessment'),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),
                  ],
                ),
              ),
            ),
    );
  }
}
