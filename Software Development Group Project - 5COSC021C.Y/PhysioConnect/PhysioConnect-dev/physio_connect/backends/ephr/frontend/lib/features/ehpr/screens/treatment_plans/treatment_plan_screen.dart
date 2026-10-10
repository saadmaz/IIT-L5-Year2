// File: frontend/lib/features/ehpr/screens/treatment_plans/treatment_plan_screen.dart

import 'package:flutter/material.dart';
import '../../../../config/constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class TreatmentPlanScreen extends StatefulWidget {
  const TreatmentPlanScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentPlanScreen> createState() => _TreatmentPlanScreenState();
}

class _TreatmentPlanScreenState extends State<TreatmentPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _patientNameController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _goalsController = TextEditingController();
  final _interventionsController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _homeProgramController = TextEditingController();
  final _precautionsController = TextEditingController();

  // Selected exercises
  final List<Map<String, dynamic>> _selectedExercises = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with sample exercises for demo purposes
    _selectedExercises.addAll([
      {
        'name': 'Bird Dog',
        'reps': 10,
        'sets': 3,
        'frequency': 'Daily',
        'notes': 'Focus on maintaining core stability.'
      },
      {
        'name': 'Hamstring Stretch',
        'reps': 5,
        'sets': 2,
        'frequency': 'Daily',
        'notes': 'Hold each stretch for 30 seconds.'
      }
    ]);
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _diagnosisController.dispose();
    _goalsController.dispose();
    _interventionsController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _homeProgramController.dispose();
    _precautionsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // In a real app, this would send data to an API
        final treatmentPlanData = {
          'patientName': _patientNameController.text,
          'diagnosis': _diagnosisController.text,
          'goals': _goalsController.text,
          'interventions': _interventionsController.text,
          'frequency': _frequencyController.text,
          'duration': _durationController.text,
          'homeProgram': _homeProgramController.text,
          'precautions': _precautionsController.text,
          'exercises': _selectedExercises,
        };

        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Treatment plan saved successfully'),
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
              content: Text('Error saving treatment plan: $e'),
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

  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        onSave: (exercise) {
          setState(() {
            _selectedExercises.add(exercise);
          });
        },
      ),
    );
  }

  void _editExercise(int index) {
    showDialog(
      context: context,
      builder: (context) => _ExerciseDialog(
        initialExercise: _selectedExercises[index],
        onSave: (exercise) {
          setState(() {
            _selectedExercises[index] = exercise;
          });
        },
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _selectedExercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Plan'),
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
                            CustomTextField(
                              controller: _diagnosisController,
                              label: 'Diagnosis',
                              hint: 'Enter diagnosis',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter diagnosis';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Treatment Goals
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Treatment Goals',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _goalsController,
                              label: 'Goals',
                              hint: 'Enter treatment goals',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter treatment goals';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Interventions
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Interventions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _interventionsController,
                              label: 'Interventions',
                              hint: 'Enter planned interventions',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter interventions';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Treatment Schedule
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Treatment Schedule',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _frequencyController,
                                    label: 'Frequency',
                                    hint: 'e.g., 2x per week',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                    width: AppDimensions.paddingMedium),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _durationController,
                                    label: 'Duration',
                                    hint: 'e.g., 6 weeks',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Exercise Program
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Exercise Program',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Exercise'),
                                  onPressed: _addExercise,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            if (_selectedExercises.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      AppDimensions.paddingMedium),
                                  child: Text('No exercises added yet'),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _selectedExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = _selectedExercises[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      title: Text(exercise['name']),
                                      subtitle: Text(
                                        '${exercise['sets']} sets × ${exercise['reps']} reps | ${exercise['frequency']}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _editExercise(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () =>
                                                _removeExercise(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Home Program
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Home Program',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _homeProgramController,
                              label: 'Home Program',
                              hint: 'Enter home program instructions',
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter home program';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Precautions
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Precautions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            CustomTextField(
                              controller: _precautionsController,
                              label: 'Precautions',
                              hint: 'Enter precautions and contraindications',
                              maxLines: 3,
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
                            : const Text('Save Treatment Plan'),
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

// Exercise dialog for adding/editing exercises
class _ExerciseDialog extends StatefulWidget {
  final Map<String, dynamic>? initialExercise;
  final Function(Map<String, dynamic>) onSave;

  const _ExerciseDialog({
    Key? key,
    this.initialExercise,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<_ExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-populate with initial values if editing
    if (widget.initialExercise != null) {
      _nameController.text = widget.initialExercise!['name'];
      _repsController.text = widget.initialExercise!['reps'].toString();
      _setsController.text = widget.initialExercise!['sets'].toString();
      _frequencyController.text = widget.initialExercise!['frequency'];
      _notesController.text = widget.initialExercise!['notes'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final exercise = {
        'name': _nameController.text,
        'reps': int.parse(_repsController.text),
        'sets': int.parse(_setsController.text),
        'frequency': _frequencyController.text,
        'notes': _notesController.text,
      };

      widget.onSave(exercise);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialExercise != null ? 'Edit Exercise' : 'Add Exercise'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Exercise Name',
                hint: 'Enter exercise name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _setsController,
                      label: 'Sets',
                      hint: 'e.g., 3',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _repsController,
                      label: 'Reps',
                      hint: 'e.g., 10',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _frequencyController,
                label: 'Frequency',
                hint: 'e.g., Daily, 3x per week',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter frequency';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Enter additional instructions',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveExercise,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
