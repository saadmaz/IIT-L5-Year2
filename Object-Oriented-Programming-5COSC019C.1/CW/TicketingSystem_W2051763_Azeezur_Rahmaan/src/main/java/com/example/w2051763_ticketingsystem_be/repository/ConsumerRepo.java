package com.example.w2051763_ticketingsystem_be.repository;

import com.example.w2051763_ticketingsystem_be.model.Consumer;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ConsumerRepo extends MongoRepository<Consumer, String> {
    boolean existsByUsername(String username);
}
