package com.example.w2051763_ticketingsystem_be.controller;

import com.example.w2051763_ticketingsystem_be.model.Consumer;
import com.example.w2051763_ticketingsystem_be.service.ConsumerService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * CRUD endpoints for consumers (ticket buyers) under {@code /api/consumers}.
 */
@RestController
@RequestMapping("/api/consumers")
public class ConsumerController {

    private final ConsumerService consumerService;

    public ConsumerController(ConsumerService consumerService) {
        this.consumerService = consumerService;
    }

    @GetMapping
    public List<Consumer> getAllConsumers() {
        return consumerService.getAllConsumers();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getConsumerById(@PathVariable String id) {
        Consumer consumer = consumerService.getConsumerById(id);
        if (consumer == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Consumer with ID " + id + " not found");
        }
        return ResponseEntity.ok(Map.of("message", "Consumer with ID " + id + " found", "consumer", consumer));
    }

    @PostMapping
    public ResponseEntity<Consumer> createConsumer(@Valid @RequestBody Consumer consumer) {
        return ResponseEntity.status(HttpStatus.CREATED).body(consumerService.createConsumer(consumer));
    }

    // No @Valid: a partial update leaves the other fields null
    @PatchMapping("/{id}")
    public ResponseEntity<String> updateConsumer(@PathVariable String id, @RequestBody Consumer changes) {
        if (consumerService.updateConsumer(id, changes) == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Consumer with ID " + id + " not found");
        }
        return ResponseEntity.ok("Consumer with ID " + id + " was updated");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteConsumer(@PathVariable String id) {
        if (!consumerService.deleteConsumerById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Consumer with ID " + id + " not found");
        }
        return ResponseEntity.ok("Consumer with ID " + id + " deleted");
    }
}
