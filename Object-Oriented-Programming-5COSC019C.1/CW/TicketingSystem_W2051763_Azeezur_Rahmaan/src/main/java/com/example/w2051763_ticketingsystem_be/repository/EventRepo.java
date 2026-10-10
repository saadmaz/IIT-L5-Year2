package com.example.w2051763_ticketingsystem_be.repository;

import com.example.w2051763_ticketingsystem_be.model.Event;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface EventRepo extends MongoRepository<Event, String> {
    List<Event> findByVendorId(String vendorId);
}
