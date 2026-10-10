// routes/storageRoutes.js
const express = require('express');
const {
  uploadProfileImage,
  uploadDocument,
  deleteFile,
} = require('../controllers/storageController');
const { protect } = require('../middleware/auth');
const { uploadProfile, uploadDocument: uploadDoc } = require('../middleware/upload');

const router = express.Router();

// Protect all routes
router.use(protect);

router.post('/upload/profile', uploadProfile, uploadProfileImage);
router.post('/upload/document', uploadDoc, uploadDocument);
router.delete('/delete', deleteFile);

module.exports = router;