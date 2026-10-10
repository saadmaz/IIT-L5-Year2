package com.juzail.ticketingsystem.model;

import java.math.BigDecimal;
import java.util.LinkedList;
import java.util.Queue;

/**
 * Thread-safe, bounded pool shared by vendors (producers) and customers (consumers).
 * <p>
 * Vendors release tickets until {@code totalTickets} have been released; customers buy
 * until all of them are sold. {@link #close()} wakes every waiting thread so the
 * simulation can always be stopped without deadlocking.
 */
public class TicketPool {
    private final Queue<Ticket> tickets = new LinkedList<>();
    private final int totalTickets;
    private final int maxCapacity;
    private int ticketsReleased = 0;
    private int ticketsSold = 0;
    private boolean closed = false;

    public TicketPool(int totalTickets, int maxCapacity) {
        if (totalTickets <= 0 || maxCapacity <= 0) {
            throw new IllegalArgumentException("Total tickets and capacity must be greater than zero.");
        }
        this.totalTickets = totalTickets;
        this.maxCapacity = maxCapacity;
    }

    /**
     * Waits until there is space in the pool, then releases a new ticket with a unique ID.
     *
     * @return the released ticket, or {@code null} once every ticket has been released or the pool is closed
     */
    public synchronized Ticket releaseTicket(String eventName, BigDecimal price) throws InterruptedException {
        while (!closed && ticketsReleased < totalTickets && tickets.size() >= maxCapacity) {
            wait();
        }
        if (closed || ticketsReleased >= totalTickets) {
            return null;
        }

        Ticket ticket = new Ticket(++ticketsReleased, eventName, price);
        tickets.add(ticket);
        notifyAll(); // wake customers waiting for a ticket
        return ticket;
    }

    /**
     * Waits until a ticket is available, then removes it from the pool.
     *
     * @return the bought ticket, or {@code null} once all tickets are sold or the pool is closed
     */
    public synchronized Ticket buyTicket() throws InterruptedException {
        while (!closed && tickets.isEmpty() && ticketsSold < totalTickets) {
            wait();
        }
        if (closed || tickets.isEmpty()) {
            return null;
        }

        Ticket ticket = tickets.poll();
        ticketsSold++;
        notifyAll(); // wake vendors waiting for space, and customers if this sold the last ticket
        return ticket;
    }

    /** Stops the pool and wakes every waiting vendor and customer. */
    public synchronized void close() {
        closed = true;
        notifyAll();
    }

    public synchronized boolean isSoldOut() {
        return ticketsSold >= totalTickets;
    }

    public synchronized int getAvailableTickets() {
        return tickets.size();
    }

    public synchronized int getTicketsReleased() {
        return ticketsReleased;
    }

    public synchronized int getTicketsSold() {
        return ticketsSold;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }
}
