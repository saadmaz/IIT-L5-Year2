// File: frontend/lib/features/ehpr/widgets/document_preview.dart

import 'package:flutter/material.dart';
import '../../../config/constants.dart';

class DocumentPreview extends StatelessWidget {
  final String documentUrl;
  final String documentType;
  final String? documentTitle;
  final VoidCallback? onClose;

  const DocumentPreview({
    Key? key,
    required this.documentUrl,
    required this.documentType,
    this.documentTitle,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.aliceBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadius),
                topRight: Radius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(),
                  color: AppColors.midnightTeal,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: Text(
                    documentTitle ?? _getFileName(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    splashRadius: 20,
                  ),
              ],
            ),
          ),

          // Document preview
          SizedBox(
            height: 200,
            child: Center(
              child: _buildPreviewContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    // In a real app, you would implement actual document preview
    // For images, PDFs, etc. using appropriate packages

    // This is a placeholder implementation
    switch (documentType.toLowerCase()) {
      case 'pdf':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: AppColors.midnightTeal.withOpacity(0.7),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'PDF Preview',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            ElevatedButton(
              onPressed: () {
                // In a real app, this would open the full document
              },
              child: const Text('Open Document'),
            ),
          ],
        );
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // In a real app, this would be an actual image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.aliceBlue,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Icon(
                Icons.image,
                size: 64,
                color: AppColors.midnightTeal.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'Image Preview',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      case 'doc':
      case 'docx':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 64,
              color: AppColors.midnightTeal.withOpacity(0.7),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'Word Document',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            ElevatedButton(
              onPressed: () {
                // In a real app, this would open the document
              },
              child: const Text('Open Document'),
            ),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_drive_file,
              size: 64,
              color: AppColors.midnightTeal.withOpacity(0.7),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'Document Preview',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            ElevatedButton(
              onPressed: () {
                // In a real app, this would open the document
              },
              child: const Text('Open Document'),
            ),
          ],
        );
    }
  }

  IconData _getFileIcon() {
    switch (documentType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileName() {
    // Extract filename from URL
    final parts = documentUrl.split('/');
    return parts.isNotEmpty ? parts.last : 'Document';
  }
}
