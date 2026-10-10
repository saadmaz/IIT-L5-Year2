package com.example.w2051763_ticketingsystem_be.service;

import com.example.w2051763_ticketingsystem_be.model.Event;
import com.example.w2051763_ticketingsystem_be.repository.EventRepo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EventService {
    private final EventRepo eventRepo;

    public EventService(EventRepo eventRepo) {
        this.eventRepo = eventRepo;
    }

    public List<Event> getAllEvents() {
        return eventRepo.findAll();
    }

    public Event getEventById(String eventId) {
        return eventRepo.findById(eventId).orElse(null);
    }

    /** @throws IllegalArgumentException if the event ends before it starts */
    public Event createEvent(Event event) {
        if (event.getEndTime().isBefore(event.getStartTime())) {
            throw new IllegalArgumentException("Event end time must be after its start time.");
        }
        return eventRepo.save(event);
    }

    public List<Event> getEventsByVendorId(String vendorId) {
        return eventRepo.findByVendorId(vendorId);
    }
}
