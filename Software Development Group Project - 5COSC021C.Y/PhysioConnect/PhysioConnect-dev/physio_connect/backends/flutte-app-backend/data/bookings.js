// data/bookings.js
const bookings = [];

export default bookings;

// routes/bookingRoutes.js
import express from 'express';
import { v4 as uuidv4 } from 'uuid'; // You'll need to install this: npm install uuid

const router = express.Router();

// Get all bookings
router.get('/', (req, res) => {
  res.json(bookings);
});

// Get bookings for a specific therapist
router.get('/therapist/:therapistName', (req, res) => {
  const { therapistName } = req.params;
  const therapistBookings = bookings.filter(booking => booking.therapistName === therapistName);
  res.json(therapistBookings);
});

// Create a new booking
router.post('/', (req, res) => {
  const { 
    therapistName, 
    therapistSpecialty,
    date, 
    time,
    userName = "Guest", // Default if user authentication is not implemented yet
    userEmail = "guest@example.com" // Default
  } = req.body;

  // Validation
  if (!therapistName || !date || !time) {
    return res.status(400).json({ message: 'Missing required booking information' });
  }

  // Check for time slot availability
  const formattedDate = new Date(date).toDateString();
  const timeExists = bookings.some(booking => 
    booking.therapistName === therapistName && 
    new Date(booking.date).toDateString() === formattedDate && 
    booking.time.hour === time.hour && 
    booking.time.minute === time.minute
  );

  if (timeExists) {
    return res.status(400).json({ message: 'This time slot is already booked' });
  }

  // Create new booking
  const newBooking = {
    id: uuidv4(),
    therapistName,
    therapistSpecialty,
    date,
    time,
    userName,
    userEmail,
    duration: 45, // Default duration in minutes
    fee: 2500,    // Default fee
    status: 'confirmed',
    createdAt: new Date().toISOString()
  };

  bookings.push(newBooking);
  res.status(201).json({ 
    message: 'Booking confirmed successfully', 
    booking: newBooking 
  });
});

// Update a booking
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { date, time, status } = req.body;

  const bookingIndex = bookings.findIndex(booking => booking.id === id);
  
  if (bookingIndex === -1) {
    return res.status(404).json({ message: 'Booking not found' });
  }

  // Update booking fields if provided
  if (date) bookings[bookingIndex].date = date;
  if (time) bookings[bookingIndex].time = time;
  if (status) bookings[bookingIndex].status = status;

  res.json({ 
    message: 'Booking updated successfully', 
    booking: bookings[bookingIndex] 
  });
});

// Cancel a booking
router.patch('/:id/cancel', (req, res) => {
  const { id } = req.params;
  
  const bookingIndex = bookings.findIndex(booking => booking.id === id);
  
  if (bookingIndex === -1) {
    return res.status(404).json({ message: 'Booking not found' });
  }

  bookings[bookingIndex].status = 'cancelled';
  
  res.json({ 
    message: 'Booking cancelled successfully', 
    booking: bookings[bookingIndex] 
  });
});

// Delete a booking (admin functionality)
router.delete('/:id', (req, res) => {
  const { id } = req.params;
  
  const bookingIndex = bookings.findIndex(booking => booking.id === id);
  
  if (bookingIndex === -1) {
    return res.status(404).json({ message: 'Booking not found' });
  }

  const deletedBooking = bookings.splice(bookingIndex, 1)[0];
  
  res.json({ 
    message: 'Booking deleted successfully', 
    booking: deletedBooking 
  });
});

