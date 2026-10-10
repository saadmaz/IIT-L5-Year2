// routes/availableTimesRoutes.js
import express from 'express';
import therapists from '../data/therapists.js';
import bookings from '../data/bookings.js';

const router = express.Router();

// Default available time slots
const defaultTimeSlots = [
  { hour: 9, minute: 0 },
  { hour: 10, minute: 0 },
  { hour: 11, minute: 0 },
  { hour: 13, minute: 0 }, // After lunch break
  { hour: 14, minute: 0 },
  { hour: 15, minute: 0 },
  { hour: 16, minute: 0 },
];

// Get available time slots for a therapist on a specific date
router.get('/:therapistName', (req, res) => {
  const { therapistName } = req.params;
  const { date } = req.query;

  if (!date) {
    return res.status(400).json({ message: 'Date parameter is required' });
  }

  // Check if therapist exists
  const therapist = therapists.find(t => t.name === therapistName);
  if (!therapist) {
    return res.status(404).json({ message: 'Therapist not found' });
  }

  // Convert date string to comparable format
  const requestedDate = new Date(date).toDateString();

  // Get all bookings for this therapist on the requested date
  const therapistBookings = bookings.filter(booking => 
    booking.therapistName === therapistName && 
    new Date(booking.date).toDateString() === requestedDate &&
    booking.status === 'confirmed'
  );

  // Get booked time slots
  const bookedTimeSlots = therapistBookings.map(booking => booking.time);

  // Filter out booked slots from available slots
  const availableSlots = defaultTimeSlots.filter(slot => 
    !bookedTimeSlots.some(bookedTime => 
      bookedTime.hour === slot.hour && bookedTime.minute === slot.minute
    )
  );

  res.json(availableSlots);
});

export default router;