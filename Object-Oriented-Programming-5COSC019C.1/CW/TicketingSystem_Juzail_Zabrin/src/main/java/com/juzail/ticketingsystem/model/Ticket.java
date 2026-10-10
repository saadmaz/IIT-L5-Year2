package com.juzail.ticketingsystem.model;

import java.math.BigDecimal;

/**
 * An immutable ticket released by a vendor and bought by a customer.
 */
public class Ticket {
    private final int ticketId;
    private final String eventName;
    private final BigDecimal ticketPrice;

    public Ticket(int ticketId, String eventName, BigDecimal ticketPrice) {
        if (eventName == null || eventName.isBlank()) {
            throw new IllegalArgumentException("Event name cannot be null or empty.");
        }
        if (ticketPrice == null || ticketPrice.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Ticket price cannot be negative.");
        }
        this.ticketId = ticketId;
        this.eventName = eventName;
        this.ticketPrice = ticketPrice;
    }

    public int getTicketId() {
        return ticketId;
    }

    public String getEventName() {
        return eventName;
    }

    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }

    @Override
    public String toString() {
        return "Ticket{ticketId=" + ticketId + ", eventName='" + eventName + "', ticketPrice=" + ticketPrice + '}';
    }
}
