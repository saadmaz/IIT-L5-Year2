package com.example.w2051763_ticketingsystem_cli;

/**
 * Producer: every second, releases {@code ticketReleaseRate} tickets into the pool
 * until all of the event's tickets have been released.
 */
public class Vendor implements Runnable {
    private final TicketPool ticketPool;

    public Vendor(TicketPool ticketPool) {
        this.ticketPool = ticketPool;
    }

    @Override
    public void run() {
        String name = Thread.currentThread().getName();
        int releaseRate = ticketPool.getConfig().getTicketReleaseRate();
        try {
            while (ticketPool.addTickets(releaseRate) > 0) {
                Thread.sleep(1000);
            }
            System.out.println(name + ": all tickets for " + ticketPool.getEvent().getEventName() + " released.");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println(name + " was stopped.");
        }
    }
}
