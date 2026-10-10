package com.example.w2051763_ticketingsystem_be.controller;

import com.example.w2051763_ticketingsystem_be.model.Event;
import com.example.w2051763_ticketingsystem_be.service.EventService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Endpoints for events under {@code /api/events}.
 */
@RestController
@RequestMapping("/api/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping
    public List<Event> getAllEvents() {
        return eventService.getAllEvents();
    }

    // Returns an empty list (200) when the vendor has no events
    @GetMapping("/vendor/{vendorId}")
    public List<Event> getEventsByVendorId(@PathVariable String vendorId) {
        return eventService.getEventsByVendorId(vendorId);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable String id) {
        Event event = eventService.getEventById(id);
        if (event == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Event with ID " + id + " not found");
        }
        return ResponseEntity.ok(Map.of("message", "Event with ID " + id + " found", "event", event));
    }

    @PostMapping
    public ResponseEntity<Event> createEvent(@Valid @RequestBody Event event) {
        return ResponseEntity.status(HttpStatus.CREATED).body(eventService.createEvent(event));
    }
}
