// controllers/storageController.js
const path = require('path');
const fs = require('fs');
const db = require('../config/db');

// @desc    Upload profile image
// @route   POST /api/storage/upload/profile
// @access  Private
exports.uploadProfileImage = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Please upload a file',
      });
    }

    // Create file URL
    const fileUrl = `${req.protocol}://${req.get('host')}/uploads/profiles/${
      req.file.filename
    }`;

    // Update user profile picture
    await db.query(
      'UPDATE users SET profile_picture = ? WHERE id = ?',
      [fileUrl, req.user.id]
    );

    res.status(200).json(fileUrl);
  } catch (error) {
    console.error('Upload profile image error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Upload document
// @route   POST /api/storage/upload/document
// @access  Private
exports.uploadDocument = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Please upload a file',
      });
    }

    // Create file URL
    const fileUrl = `${req.protocol}://${req.get('host')}/uploads/documents/${
      req.file.filename
    }`;

    // If document_type is certificate, update the professional development
    if (req.body.document_type === 'certificate' && req.body.development_id) {
      await db.query(
        'UPDATE professional_developments SET certificate_url = ? WHERE id = ? AND user_id = ?',
        [fileUrl, req.body.development_id, req.user.id]
      );
    }

    res.status(200).json(fileUrl);
  } catch (error) {
    console.error('Upload document error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};

// @desc    Delete file
// @route   DELETE /api/storage/delete
// @access  Private
exports.deleteFile = async (req, res) => {
  try {
    const { file_url } = req.body;

    if (!file_url) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a file URL',
      });
    }

    // Extract filename from URL
    const urlParts = file_url.split('/');
    const filename = urlParts[urlParts.length - 1];
    
    // Determine file type from URL
    let filePath;
    if (file_url.includes('/profiles/')) {
      filePath = path.join(__dirname, '../uploads/profiles', filename);
      
      // If it's a profile picture, update user
      await db.query(
        'UPDATE users SET profile_picture = NULL WHERE id = ? AND profile_picture = ?',
        [req.user.id, file_url]
      );
    } else if (file_url.includes('/documents/')) {
      filePath = path.join(__dirname, '../uploads/documents', filename);
      
      // If it's a certificate, update the professional development
      await db.query(
        'UPDATE professional_developments SET certificate_url = NULL WHERE user_id = ? AND certificate_url = ?',
        [req.user.id, file_url]
      );
    } else {
      return res.status(400).json({
        success: false,
        message: 'Invalid file URL',
      });
    }

    // Check if file exists
    if (fs.existsSync(filePath)) {
      // Delete file
      fs.unlinkSync(filePath);
    }

    res.status(200).json({
      success: true,
      message: 'File deleted successfully',
    });
  } catch (error) {
    console.error('Delete file error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
};