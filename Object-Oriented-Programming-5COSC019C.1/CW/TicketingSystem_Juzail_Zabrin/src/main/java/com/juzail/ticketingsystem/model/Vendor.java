package com.juzail.ticketingsystem.model;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;

/**
 * Producer: releases tickets into the pool at a fixed interval until none are left to release.
 */
public class Vendor implements Runnable {
    private static final Logger log = LoggerFactory.getLogger(Vendor.class);

    private final TicketPool ticketPool;
    private final int releaseIntervalMs;
    private final String eventName;
    private final BigDecimal ticketPrice;

    public Vendor(TicketPool ticketPool, int releaseIntervalMs, String eventName, BigDecimal ticketPrice) {
        this.ticketPool = ticketPool;
        this.releaseIntervalMs = releaseIntervalMs;
        this.eventName = eventName;
        this.ticketPrice = ticketPrice;
    }

    @Override
    public void run() {
        String name = Thread.currentThread().getName();
        try {
            Ticket ticket;
            while ((ticket = ticketPool.releaseTicket(eventName, ticketPrice)) != null) {
                log.info("{} released {} (pool size: {})", name, ticket, ticketPool.getAvailableTickets());
                Thread.sleep(releaseIntervalMs);
            }
            log.info(ticketPool.getTicketsReleased() >= ticketPool.getTotalTickets()
                    ? "{} finished: all tickets released." : "{} was stopped.", name);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.info("{} was stopped.", name);
        }
    }
}
