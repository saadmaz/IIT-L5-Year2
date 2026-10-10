package com.example.w2051763_ticketingsystem_cli;

import java.util.LinkedList;
import java.util.Queue;

/**
 * Thread-safe pool shared by vendors and consumers for one event.
 * Vendors can add tickets until {@code maxTicketCapacity} have been released in total;
 * the event is sold out once that many have been bought.
 */
public class TicketPool {
    private final Queue<Ticket> tickets = new LinkedList<>();
    private final Event event;
    private final Configuration config;
    private int totalTicketsAdded = 0;
    private int totalTicketsSold = 0;

    public TicketPool(Event event, Configuration config) {
        this.event = event;
        this.config = config;
        addTickets(config.getTotalTickets()); // tickets available from the start
    }

    /**
     * Adds up to {@code noOfTickets}, stopping at the maximum capacity.
     *
     * @return how many tickets were added; 0 means every ticket has already been released
     */
    public synchronized int addTickets(int noOfTickets) {
        int ticketsToAdd = Math.min(noOfTickets, config.getMaxTicketCapacity() - totalTicketsAdded);
        for (int i = 0; i < ticketsToAdd; i++) {
            tickets.add(new Ticket(++totalTicketsAdded, event));
        }
        if (ticketsToAdd > 0) {
            System.out.println("ADDED: " + ticketsToAdd + " tickets by " + Thread.currentThread().getName()
                    + " | Available: " + tickets.size() + " | Released: " + totalTicketsAdded + "/" + config.getMaxTicketCapacity());
        }
        return ticketsToAdd;
    }

    /** @return the next ticket, or null if none are available right now */
    public synchronized Ticket removeTicket() {
        Ticket ticket = tickets.poll();
        if (ticket != null) {
            totalTicketsSold++;
            System.out.println("BOUGHT: " + Thread.currentThread().getName() + " purchased " + ticket
                    + " | Available: " + tickets.size() + " | Sold: " + totalTicketsSold + "/" + config.getMaxTicketCapacity());
        }
        return ticket;
    }

    public synchronized boolean isSoldOut() {
        return totalTicketsSold >= config.getMaxTicketCapacity();
    }

    public synchronized int getAvailableTickets() {
        return tickets.size();
    }

    public synchronized int getTotalTicketsSold() {
        return totalTicketsSold;
    }

    public Event getEvent() {
        return event;
    }

    public Configuration getConfig() {
        return config;
    }
}
