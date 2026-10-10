package com.example.w2051763_ticketingsystem_be.service;

import com.example.w2051763_ticketingsystem_be.model.Consumer;
import com.example.w2051763_ticketingsystem_be.repository.ConsumerRepo;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConsumerService {
    private final ConsumerRepo consumerRepo;
    private final PasswordEncoder passwordEncoder;

    public ConsumerService(ConsumerRepo consumerRepo, PasswordEncoder passwordEncoder) {
        this.consumerRepo = consumerRepo;
        this.passwordEncoder = passwordEncoder;
    }

    public List<Consumer> getAllConsumers() {
        return consumerRepo.findAll();
    }

    public Consumer getConsumerById(String consumerId) {
        return consumerRepo.findById(consumerId).orElse(null);
    }

    /** @throws IllegalArgumentException if the username is already taken */
    public Consumer createConsumer(Consumer consumer) {
        if (consumerRepo.existsByUsername(consumer.getUsername())) {
            throw new IllegalArgumentException("Username " + consumer.getUsername() + " is already taken.");
        }
        consumer.setPassword(passwordEncoder.encode(consumer.getPassword()));
        return consumerRepo.save(consumer);
    }

    /** Updates only the fields that are present; returns null if the consumer does not exist. */
    public Consumer updateConsumer(String consumerId, Consumer changes) {
        return consumerRepo.findById(consumerId).map(existing -> {
            if (changes.getFullName() != null) {
                existing.setFullName(changes.getFullName());
            }
            if (changes.getEmail() != null) {
                existing.setEmail(changes.getEmail());
            }
            if (changes.getUsername() != null) {
                existing.setUsername(changes.getUsername());
            }
            if (changes.getPassword() != null) {
                existing.setPassword(passwordEncoder.encode(changes.getPassword()));
            }
            if (changes.getPriority() != null) {
                existing.setPriority(changes.getPriority());
            }
            return consumerRepo.save(existing);
        }).orElse(null);
    }

    public boolean deleteConsumerById(String consumerId) {
        if (consumerRepo.existsById(consumerId)) {
            consumerRepo.deleteById(consumerId);
            return true;
        }
        return false;
    }
}
