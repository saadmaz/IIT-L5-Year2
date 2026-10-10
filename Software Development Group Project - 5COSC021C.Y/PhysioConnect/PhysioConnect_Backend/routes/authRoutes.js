// routes/authRoutes.js
const express = require('express');
const {
  register,
  login,
  logout,
  validateToken,
  resetPassword,
  changePassword,
} = require('../controllers/authController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/logout', protect, logout);
router.get('/validate', protect, validateToken);
router.post('/reset-password', resetPassword);
router.post('/change-password', protect, changePassword);

module.exports = router;