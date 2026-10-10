package com.juzail.ticketingsystem.controller;

import com.juzail.ticketingsystem.model.SystemConfiguration;
import com.juzail.ticketingsystem.model.SystemStatus;
import com.juzail.ticketingsystem.service.TicketService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST API for controlling the simulation:
 * <ul>
 *     <li>{@code POST /api/tickets/start} with a {@link SystemConfiguration} JSON body</li>
 *     <li>{@code POST /api/tickets/stop}</li>
 *     <li>{@code GET  /api/tickets/status}</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/tickets")
public class TicketController {

    private final TicketService ticketService;

    public TicketController(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    @PostMapping("/start")
    public SystemStatus start(@RequestBody SystemConfiguration config) {
        ticketService.start(config);
        return ticketService.getStatus();
    }

    @PostMapping("/stop")
    public SystemStatus stop() {
        ticketService.stop();
        return ticketService.getStatus();
    }

    @GetMapping("/status")
    public SystemStatus status() {
        return ticketService.getStatus();
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleInvalidConfig(IllegalArgumentException e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<String> handleAlreadyRunning(IllegalStateException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
    }
}
