package com.example.w2051763_ticketingsystem_be.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.annotation.Id;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * Tickets for one event. Vendors add tickets and consumers remove them.
 * Not yet exposed through the REST API.
 */
@Slf4j
@Getter
@Setter
@NoArgsConstructor
public class TicketPool {
    @Id
    private String id;
    private String eventId;
    private Configuration ticketPoolConfig;
    private int totalTicketsSold = 0;
    private BlockingQueue<Ticket> ticketQueue = new LinkedBlockingQueue<>();
    private Status status = Status.ACTIVE;

    public enum Status {
        ACTIVE,
        SOLD_OUT,
        EXPIRED
    }

    /** Vendor adds {@code quantity} tickets, unless that would go over the pool's maximum capacity. */
    public synchronized void addTickets(int quantity, double price) {
        int canAddUpTo = ticketPoolConfig.getMaxTicketCapacity()
                - (ticketPoolConfig.getTotalTickets() + totalTicketsSold);
        if (quantity > canAddUpTo) {
            log.warn("Vendor cannot add {} tickets: only {} more fit within the maximum capacity.", quantity, canAddUpTo);
            return;
        }
        for (int i = 0; i < quantity; i++) {
            ticketQueue.add(new Ticket(id, price, "GA"));
        }
        ticketPoolConfig.setTotalTickets(ticketPoolConfig.getTotalTickets() + quantity);
        log.info("Vendor added {} tickets to the pool.", quantity);
    }

    /** Consumer buys {@code quantity} tickets, if that many are available. */
    public synchronized void removeTickets(int quantity) {
        if (ticketQueue.size() < quantity) {
            log.warn("Not enough tickets to remove: only {} remain.", ticketQueue.size());
            return;
        }
        for (int i = 0; i < quantity; i++) {
            ticketQueue.poll();
        }
        totalTicketsSold += quantity;
        ticketPoolConfig.setTotalTickets(ticketPoolConfig.getTotalTickets() - quantity);
        if (totalTicketsSold >= ticketPoolConfig.getMaxTicketCapacity()) {
            status = Status.SOLD_OUT;
        }
    }
}
