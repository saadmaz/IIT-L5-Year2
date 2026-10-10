const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');

// PostgreSQL Connection Pool
const pool = new Pool({
  connectionString: process.env.POSTGRESQL_URI,
  ssl: {
    rejectUnauthorized: false // Only for development. Use proper SSL in production.
  }
});

// Express App Setup
const app = express();
app.use(express.json());

// Middleware for JWT Authentication
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) return res.sendStatus(401);

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

// Registration Route
app.post('/register', [
  body('email').isEmail(),
  body('password').isLength({ min: 6 }),
], async (req, res) => {
  // Validate input
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { name, email, password, role } = req.body;

    // Check if user already exists
    const existingUserQuery = 'SELECT * FROM users WHERE email = $1';
    const existingUserResult = await pool.query(existingUserQuery, [email]);
    
    if (existingUserResult.rows.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create new user
    const insertUserQuery = `
      INSERT INTO users (name, email, password, role) 
      VALUES ($1, $2, $3, $4) 
      RETURNING id
    `;
    const result = await pool.query(insertUserQuery, [name, email, hashedPassword, role]);

    res.status(201).json({ 
      message: 'User registered successfully', 
      userId: result.rows[0].id 
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Login Route
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const userQuery = 'SELECT * FROM users WHERE email = $1';
    const userResult = await pool.query(userQuery, [email]);
    
    const user = userResult.rows[0];
    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Generate JWT
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({ 
      token, 
      user: { 
        id: user.id, 
        name: user.name, 
        email: user.email, 
        role: user.role 
      } 
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// Book Appointment Route
app.post('/book-appointment', authenticateToken, async (req, res) => {
  try {
    const { therapistId, specialty, date, time } = req.body;

    // Create new appointment
    const insertAppointmentQuery = `
      INSERT INTO appointments (patient_id, therapist_id, specialty, date, time, status, consultation_type)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id
    `;
    const result = await pool.query(insertAppointmentQuery, [
      req.user.id, 
      therapistId, 
      specialty, 
      new Date(date), 
      time, 
      'scheduled', 
      'video'
    ]);

    res.status(201).json({ 
      message: 'Appointment booked successfully', 
      appointmentId: result.rows[0].id 
    });
  } catch (error) {
    res.status(500).json({ message: 'Error booking appointment', error: error.message });
  }
});

// Upcoming Appointments Route
app.get('/upcoming-appointments', authenticateToken, async (req, res) => {
  try {
    const appointmentsQuery = `
      SELECT a.*, u.name as therapist_name 
      FROM appointments a
      JOIN users u ON a.therapist_id = u.id
      WHERE a.patient_id = $1 
      AND a.date >= CURRENT_TIMESTAMP 
      AND a.status = 'scheduled'
      ORDER BY a.date ASC
    `;
    const result = await pool.query(appointmentsQuery, [req.user.id]);

    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching appointments', error: error.message });
  }
});

// Video Call Route
app.post('/start-video-call', authenticateToken, async (req, res) => {
  try {
    const { appointmentId } = req.body;

    // Update appointment status
    const updateAppointmentQuery = `
      UPDATE appointments 
      SET status = 'in-progress' 
      WHERE id = $1 AND patient_id = $2
      RETURNING id
    `;
    const result = await pool.query(updateAppointmentQuery, [appointmentId, req.user.id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    res.json({ 
      message: 'Video call started', 
      appointmentId: result.rows[0].id,
      callToken: jwt.sign(
        { appointmentId: result.rows[0].id }, 
        process.env.JWT_SECRET, 
        { expiresIn: '1h' }
      )
    });
  } catch (error) {
    res.status(500).json({ message: 'Error starting video call', error: error.message });
  }
});

// Server Setup
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;