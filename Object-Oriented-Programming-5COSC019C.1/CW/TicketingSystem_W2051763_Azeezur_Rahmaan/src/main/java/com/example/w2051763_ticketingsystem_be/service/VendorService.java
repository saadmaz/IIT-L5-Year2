package com.example.w2051763_ticketingsystem_be.service;

import com.example.w2051763_ticketingsystem_be.model.Vendor;
import com.example.w2051763_ticketingsystem_be.repository.VendorRepo;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VendorService {
    private final VendorRepo vendorRepo;
    private final PasswordEncoder passwordEncoder;

    public VendorService(VendorRepo vendorRepo, PasswordEncoder passwordEncoder) {
        this.vendorRepo = vendorRepo;
        this.passwordEncoder = passwordEncoder;
    }

    public List<Vendor> getAllVendors() {
        return vendorRepo.findAll();
    }

    public Vendor getVendorById(String vendorId) {
        return vendorRepo.findById(vendorId).orElse(null);
    }

    /** @throws IllegalArgumentException if the username is already taken */
    public Vendor createVendor(Vendor vendor) {
        if (vendorRepo.existsByUsername(vendor.getUsername())) {
            throw new IllegalArgumentException("Username " + vendor.getUsername() + " is already taken.");
        }
        vendor.setPassword(passwordEncoder.encode(vendor.getPassword()));
        return vendorRepo.save(vendor);
    }

    /** Updates only the fields that are present; returns null if the vendor does not exist. */
    public Vendor updateVendor(String vendorId, Vendor changes) {
        return vendorRepo.findById(vendorId).map(existing -> {
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
            if (changes.getDefaultConfig() != null) {
                existing.setDefaultConfig(changes.getDefaultConfig());
            }
            return vendorRepo.save(existing);
        }).orElse(null);
    }

    public boolean deleteVendorById(String vendorId) {
        if (vendorRepo.existsById(vendorId)) {
            vendorRepo.deleteById(vendorId);
            return true;
        }
        return false;
    }
}
