// routes/userRoutes.js
const express = require('express');
const {
  getCurrentUser,
  updateProfile,
  getUserStats,
  updatePreferences,
  getUserConnections,
  addProfessionalDevelopment,
  searchProfessionals,
} = require('../controllers/userController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// Protect all routes
router.use(protect);

router.get('/me', getCurrentUser);
router.put('/profile', updateProfile);
router.get('/stats', getUserStats);
router.put('/preferences', updatePreferences);
router.get('/connections', getUserConnections);
router.post('/professional-development', addProfessionalDevelopment);
router.get('/search', searchProfessionals);

module.exports = router;