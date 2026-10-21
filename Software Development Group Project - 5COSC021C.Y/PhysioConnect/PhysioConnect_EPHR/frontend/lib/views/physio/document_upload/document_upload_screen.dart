import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navigation_drawer.dart';
import '../../widgets/form_widgets.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({Key? key}) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Form state
  String? _selectedPatient;
  final _titleController = TextEditingController();
  String? _selectedCategory;
  final _notesController = TextEditingController();
  
  // File selection state
  bool _fileSelected = false;
  String _fileName = '';
  
  // Mock data
  final List<String> _patients = [
    'John Smith',
    'Emily Johnson',
    'Michael Chen',
    'Sarah Wilson',
  ];
  
  final List<String> _categories = [
    'Assessment',
    'Treatment Plan',
    'Progress Note',
    'Exercise Prescription',
    'Lab Result',
    'Referral',
    'Discharge Summary',
    'Other',
  ];
  
  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _selectFile() async {
    // In a real app, we would use a file picker
    // For now, just simulate file selection
    setState(() {
      _fileSelected = true;
      _fileName = 'selected_document.pdf';
      
      // Auto-fill title field with file name
      if (_titleController.text.isEmpty) {
        _titleController.text = 'Treatment Plan';
      }
    });
  }
  
  Future<void> _uploadDocument() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_fileSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file')),
      );
      return;
    }
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document category')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document uploaded successfully')),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Upload Document'),
      drawer: NavigationDrawer(currentRoute: AppRoutes.physioDocumentUpload),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Uploading document...'),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient selection
                    const Text('Select Patient', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPatient,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.aliceBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: _patients.map((patient) {
                        return DropdownMenuItem<String>(
                          value: patient,
                          child: Text(patient),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPatient = value;
                        });
                      },
                      hint: const Text('Select a patient'),
                    ),
                    const SizedBox(height: 24),
                    
                    // File selection
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              _fileSelected ? Icons.insert_drive_file : Icons.upload_file,
                              size: 48,
                              color: AppTheme.midnightTeal,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _fileSelected ? 'File Selected: $_fileName' : 'Select a document to upload',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: _fileSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.file_upload),
                              label: Text(_fileSelected ? 'Change File' : 'Select File'),
                              onPressed: _selectFile,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Document details
                    const Text('Document Information', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    // Document title
                    EPHRTextField(
                      label: 'Document Title',
                      hint: 'Enter a title for this document',
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Document category
                    EPHRDropdownField<String>(
                      label: 'Document Category',
                      value: _selectedCategory,
                      hint: 'Select document category',
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Notes
                    EPHRTextField(
                      label: 'Notes (Optional)',
                      hint: 'Add any notes about this document',
                      controller: _notesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    
                    // Upload button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _uploadDocument,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Upload Document', 
                          style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}