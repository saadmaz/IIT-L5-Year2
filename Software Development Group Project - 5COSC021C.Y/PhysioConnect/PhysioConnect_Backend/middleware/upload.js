// middleware/upload.js
const multer = require('multer');
const path = require('path');

// Set storage for profile images
const profileStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/profiles/');
  },
  filename: function (req, file, cb) {
    cb(
      null,
      `profile_${req.user.id}_${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

// Set storage for documents
const documentStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/documents/');
  },
  filename: function (req, file, cb) {
    cb(
      null,
      `document_${req.user.id}_${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

// Check file type
const fileFilter = (req, file, cb) => {
  // Allowed extensions
  const filetypes = /jpeg|jpg|png|gif|pdf|doc|docx/;
  // Check extension
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  // Check mime type
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Images (jpeg, jpg, png, gif) and documents (pdf, doc, docx) only!');
  }
};

// Create upload instances
exports.uploadProfile = multer({
  storage: profileStorage,
  limits: { fileSize: 1000000 }, // 1MB
  fileFilter: fileFilter,
}).single('image');

exports.uploadDocument = multer({
  storage: documentStorage,
  limits: { fileSize: 2000000 }, // 2MB
  fileFilter: fileFilter,
}).single('document');