package com.example.w2051763_ticketingsystem_cli;

/**
 * Settings for one event's ticket pool.
 */
public class Configuration {
    private int totalTickets;          // tickets already in the pool when sales start
    private int ticketReleaseRate;     // tickets each vendor releases per second
    private int customerRetrievalRate; // tickets each customer buys per second
    private int maxTicketCapacity;     // total tickets the event will ever sell

    public Configuration(int totalTickets, int ticketReleaseRate, int customerRetrievalRate, int maxTicketCapacity) {
        this.totalTickets = totalTickets;
        this.ticketReleaseRate = ticketReleaseRate;
        this.customerRetrievalRate = customerRetrievalRate;
        this.maxTicketCapacity = maxTicketCapacity;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

    public int getTicketReleaseRate() {
        return ticketReleaseRate;
    }

    public void setTicketReleaseRate(int ticketReleaseRate) {
        this.ticketReleaseRate = ticketReleaseRate;
    }

    public int getCustomerRetrievalRate() {
        return customerRetrievalRate;
    }

    public void setCustomerRetrievalRate(int customerRetrievalRate) {
        this.customerRetrievalRate = customerRetrievalRate;
    }

    public int getMaxTicketCapacity() {
        return maxTicketCapacity;
    }

    public void setMaxTicketCapacity(int maxTicketCapacity) {
        this.maxTicketCapacity = maxTicketCapacity;
    }

    @Override
    public String toString() {
        return "starting tickets=" + totalTickets + ", max capacity=" + maxTicketCapacity
                + ", release rate=" + ticketReleaseRate + "/s, retrieval rate=" + customerRetrievalRate + "/s";
    }
}
