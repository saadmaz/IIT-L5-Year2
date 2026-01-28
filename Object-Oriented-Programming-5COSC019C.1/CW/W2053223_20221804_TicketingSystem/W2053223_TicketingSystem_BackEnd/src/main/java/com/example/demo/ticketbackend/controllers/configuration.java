package com.example.demo.ticketbackend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


//import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import com.example.w2051763_ticketingsystem_be.Documents.Consumer;
import com.example.w2051763_ticketingsystem_be.Documents.Consumer;
import com.example.w2051763_ticketingsystem_be.Service.ConsumerService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/consumers")
public class ConsumerController {
    private final ConsumerService consumerService;

    @Autowired
    public ConsumerController(ConsumerService consumerService) {
        this.consumerService = consumerService;
    }

    @GetMapping
    public ResponseEntity<List<Consumer>> getAllConsumers() {
        List<Consumer> allConsumers = consumerService.getAllConsumers();
        return new ResponseEntity<>(allConsumers, HttpStatus.OK);
    }

    @GetMapping("{id}")
    public ResponseEntity<?> getConsumerById(@PathVariable String id) {
        Consumer consumer = consumerService.getConsumerById(id);
        if(consumer == null) {
            return new ResponseEntity<>("Consumer with ID not found", HttpStatus.NOT_FOUND);
        } else {
            Map<String, Object> responseBody = new HashMap<>();
            responseBody.put("message", "Consumer with ID " + id + " found");
            responseBody.put("consumer", consumer);
            return new ResponseEntity<>( responseBody, HttpStatus.OK);
        }
    }

    @PostMapping
    public ResponseEntity<Consumer> createConsumer(@RequestBody Consumer consumer) {
        Consumer newConsumer = consumerService.createConsumer(consumer);
        return new ResponseEntity<>(newConsumer, HttpStatus.CREATED);
    }

    @PatchMapping("{id}")
    public ResponseEntity<String> updateConsumer(@PathVariable String id, @RequestBody Consumer updatedConsumer) {
        // validation - cant put @Valid since it expects other values to not be null
        Consumer consumer = consumerService.updateConsumer(id, updatedConsumer);
        if(consumer != null) {
            return new ResponseEntity<>( "Consumer with ID " + id + " was updated!", HttpStatus.OK);
        }
        return new ResponseEntity<>("Consumer with ID not found", HttpStatus.NOT_FOUND);
    }

    /**
     * Deletes a consumer by its ID.
     *
     * @param id the ID of the consumer to delete
     * @return a {@link ResponseEntity} with {@code HttpStatus.NO_CONTENT} if deletion is successful,
     * or {@code HttpStatus.NOT_FOUND} if the consumer is not found
     */
    @DeleteMapping("{id}")
    public ResponseEntity<?> deleteConsumer(@PathVariable String id) {
        boolean deleted =  consumerService.deleteConsumerById(id);

        if(deleted) {
            return new ResponseEntity<>("Consumer with ID " + id + " deleted", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Consumer with ID not found", HttpStatus.NOT_FOUND);
        }
    }
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Map<String, String> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        return errors;
    }
}
