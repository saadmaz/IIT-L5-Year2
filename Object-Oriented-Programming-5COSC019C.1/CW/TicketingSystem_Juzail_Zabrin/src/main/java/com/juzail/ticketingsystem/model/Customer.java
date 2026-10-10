package com.juzail.ticketingsystem.model;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Consumer: buys tickets from the pool at a fixed interval until they are sold out.
 */
public class Customer implements Runnable {
    private static final Logger log = LoggerFactory.getLogger(Customer.class);

    private final TicketPool ticketPool;
    private final int retrievalIntervalMs;

    public Customer(TicketPool ticketPool, int retrievalIntervalMs) {
        this.ticketPool = ticketPool;
        this.retrievalIntervalMs = retrievalIntervalMs;
    }

    @Override
    public void run() {
        String name = Thread.currentThread().getName();
        try {
            Ticket ticket;
            while ((ticket = ticketPool.buyTicket()) != null) {
                log.info("{} bought {} (pool size: {})", name, ticket, ticketPool.getAvailableTickets());
                Thread.sleep(retrievalIntervalMs);
            }
            log.info(ticketPool.isSoldOut() ? "{} finished: tickets are sold out." : "{} was stopped.", name);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.info("{} was stopped.", name);
        }
    }
}
