// server.js
import express from "express";
import cors from "cors";
import therapists from "./data/therapists.js";
import bookingRoutes from "./routes/bookingRoutes.js";
import availableTimesRoutes from "./routes/availableTimesRoutes.js";

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Therapist routes
app.get('/therapists', (req, res) => {
  res.json(therapists);
});

app.post('/therapists', (req, res) => {
  const newTherapist = req.body;
  therapists.push(newTherapist);
  res.status(201).json({ message: 'Therapist added', therapist: newTherapist });
});

// Get a specific therapist by name
app.get('/therapists/:name', (req, res) => {
  const { name } = req.params;
  const therapist = therapists.find(t => t.name === name);
  
  if (!therapist) {
    return res.status(404).json({ message: 'Therapist not found' });
  }
  
  res.json(therapist);
});

// Mount booking routes
app.use('/bookings', bookingRoutes);

// Mount available times routes
app.use('/available-times', availableTimesRoutes);

// Simple user authentication (placeholder for future implementation)
app.post('/login', (req, res) => {
  // This is just a placeholder - in a real app, you would implement proper authentication
  const { email, password } = req.body;
  
  // Mock successful login for any credentials
  res.json({
    success: true,
    message: 'Login successful',
    user: {
      id: 'user123',
      name: 'Test User',
      email: email || 'test@example.com'
    },
    token: 'mock-jwt-token'
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});