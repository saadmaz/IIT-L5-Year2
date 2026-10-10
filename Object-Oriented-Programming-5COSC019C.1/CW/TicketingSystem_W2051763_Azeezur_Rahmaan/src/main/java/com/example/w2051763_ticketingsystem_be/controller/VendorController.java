package com.example.w2051763_ticketingsystem_be.controller;

import com.example.w2051763_ticketingsystem_be.model.Vendor;
import com.example.w2051763_ticketingsystem_be.service.VendorService;
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
 * CRUD endpoints for vendors under {@code /api/vendors}.
 */
@RestController
@RequestMapping("/api/vendors")
public class VendorController {

    private final VendorService vendorService;

    public VendorController(VendorService vendorService) {
        this.vendorService = vendorService;
    }

    @GetMapping
    public List<Vendor> getAllVendors() {
        return vendorService.getAllVendors();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getVendorById(@PathVariable String id) {
        Vendor vendor = vendorService.getVendorById(id);
        if (vendor == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Vendor with ID " + id + " not found");
        }
        return ResponseEntity.ok(Map.of("message", "Vendor with ID " + id + " found", "vendor", vendor));
    }

    @PostMapping
    public ResponseEntity<Vendor> createVendor(@Valid @RequestBody Vendor vendor) {
        return ResponseEntity.status(HttpStatus.CREATED).body(vendorService.createVendor(vendor));
    }

    // No @Valid: a partial update leaves the other fields null
    @PatchMapping("/{id}")
    public ResponseEntity<String> updateVendor(@PathVariable String id, @RequestBody Vendor changes) {
        if (vendorService.updateVendor(id, changes) == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Vendor with ID " + id + " not found");
        }
        return ResponseEntity.ok("Vendor with ID " + id + " was updated");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteVendor(@PathVariable String id) {
        if (!vendorService.deleteVendorById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Vendor with ID " + id + " not found");
        }
        return ResponseEntity.ok("Vendor with ID " + id + " deleted");
    }
}
