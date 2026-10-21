import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:photo_view/photo_view.dart';
import '../config/theme.dart';

/// File viewer widget for displaying various file types
/// Supports PDF files and images

class FileViewer extends StatefulWidget {
  final String filePath;
  final String? fileName;
  final String? fileType;
  
  const FileViewer({
    Key? key,
    required this.filePath,
    this.fileName,
    this.fileType,
  }) : super(key: key);
  
  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _checkFile();
  }
  
  /// Check if file exists and can be opened
  Future<void> _checkFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final file = File(widget.filePath);
      final exists = await file.exists();
      
      if (!exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'File not found';
        });
        return;
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading file: $e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkFile,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    // Determine file type
    final fileType = widget.fileType ?? _getFileTypeFromExtension(widget.filePath);
    
    // Display file based on type
    if (fileType == 'pdf') {
      return _buildPdfViewer();
    } else if (fileType == 'image') {
      return _buildImageViewer();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_drive_file,
              color: AppTheme.midnightTeal,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Unsupported file type: $fileType',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
  
  /// Build PDF viewer
  Widget _buildPdfViewer() {
    return PDFView(
      filePath: widget.filePath,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: true,
      pageFling: true,
      onError: (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
      onPageError: (page, error) {
        setState(() {
          _errorMessage = 'Error loading page $page: $error';
        });
      },
    );
  }
  
  /// Build image viewer
  Widget _buildImageViewer() {
    return PhotoView(
      imageProvider: FileImage(File(widget.filePath)),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 2,
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          value: event == null
              ? 0
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.midnightTeal),
        ),
      ),
    );
  }
  
  /// Determine file type from extension
  String _getFileTypeFromExtension(String path) {
    final extension = path.split('.').last.toLowerCase();
    
    if (extension == 'pdf') {
      return 'pdf';
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
      return 'image';
    } else {
      return extension;
    }
  }
}