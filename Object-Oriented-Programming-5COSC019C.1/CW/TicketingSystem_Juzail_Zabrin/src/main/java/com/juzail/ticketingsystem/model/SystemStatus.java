package com.juzail.ticketingsystem.model;

/**
 * Snapshot of the simulation, returned by the CLI "status" command and the REST API.
 */
public record SystemStatus(
        boolean running,
        int totalTickets,
        int ticketsReleased,
        int ticketsSold,
        int availableTickets,
        int maxTicketCapacity) {

    public static SystemStatus idle() {
        return new SystemStatus(false, 0, 0, 0, 0, 0);
    }
}
