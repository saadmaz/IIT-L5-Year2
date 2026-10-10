package com.example.w2051763_ticketingsystem_be.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Ticket pool settings, embedded in a vendor document.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Configuration {
    private int totalTickets;          // tickets currently available in the pool
    private int maxTicketCapacity;     // most tickets the pool can ever hold
    private double ticketReleaseRate;  // tickets released per second
    private double customerRetrievalRate; // tickets bought per second
}
