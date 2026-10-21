import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/form_widgets.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Form state
  final _nameController = TextEditingController();
  String? _selectedType;
  final _notesController = TextEditingController();
  bool _isImportant = false;
  
  // File selection state
  bool _fileSelected = false;
  String _fileName = '';
  
  // Document types
  final List<String> _documentTypes = [
    'Insurance',
    'Form',
    'Referral',
    'Prescription',
    'Lab Result',
    'X-Ray',
    'MRI',
    'Other',
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _selectFile() async {
    // In a real app, we would use a file picker
    // For now, just simulate file selection
    setState(() {
      _fileSelected = true;
      _fileName = 'selected_document.pdf';
      
      // Auto-fill name field with file name
      if (_nameController.text.isEmpty) {
        _nameController.text = 'Selected Document';
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
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document type')),
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
                    
                    // Document information
                    const Text('Document Information', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    // Document name
                    EPHRTextField(
                      label: 'Document Name',
                      hint: 'Enter a name for this document',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Document type
                    EPHRDropdownField<String>(
                      label: 'Document Type',
                      value: _selectedType,
                      hint: 'Select document type',
                      items: _documentTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
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
                    const SizedBox(height: 16),
                    
                    // Important flag
                    EPHRCheckboxField(
                      label: 'Mark as Important',
                      value: _isImportant,
                      onChanged: (value) {
                        setState(() {
                          _isImportant = value ?? false;
                        });
                      },
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