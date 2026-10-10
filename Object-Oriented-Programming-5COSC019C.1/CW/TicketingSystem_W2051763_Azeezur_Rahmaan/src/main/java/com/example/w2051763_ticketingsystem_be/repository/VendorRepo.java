package com.example.w2051763_ticketingsystem_be.repository;

import com.example.w2051763_ticketingsystem_be.model.Vendor;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface VendorRepo extends MongoRepository<Vendor, String> {
    boolean existsByUsername(String username);
}
