package com.juzail.ticketingsystem.model;

/**
 * Parameters for one run of the ticketing simulation.
 * Rates are the delay in milliseconds between two actions of the same vendor/customer.
 */
public class SystemConfiguration {
    private int totalTickets = 50;
    private int ticketReleaseRate = 500;
    private int customerRetrievalRate = 800;
    private int maxTicketCapacity = 10;
    private int numberOfVendors = 3;
    private int numberOfCustomers = 5;

    public SystemConfiguration() {
    }

    public SystemConfiguration(int totalTickets, int ticketReleaseRate, int customerRetrievalRate, int maxTicketCapacity) {
        this.totalTickets = totalTickets;
        this.ticketReleaseRate = ticketReleaseRate;
        this.customerRetrievalRate = customerRetrievalRate;
        this.maxTicketCapacity = maxTicketCapacity;
    }

    /** @throws IllegalArgumentException if any value is out of range */
    public void validate() {
        requirePositive(totalTickets, "Total tickets");
        requirePositive(maxTicketCapacity, "Maximum ticket capacity");
        requirePositive(numberOfVendors, "Number of vendors");
        requirePositive(numberOfCustomers, "Number of customers");
        if (ticketReleaseRate < 0 || customerRetrievalRate < 0) {
            throw new IllegalArgumentException("Release and retrieval rates cannot be negative.");
        }
    }

    private static void requirePositive(int value, String field) {
        if (value <= 0) {
            throw new IllegalArgumentException(field + " must be greater than zero.");
        }
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

    public int getNumberOfVendors() {
        return numberOfVendors;
    }

    public void setNumberOfVendors(int numberOfVendors) {
        this.numberOfVendors = numberOfVendors;
    }

    public int getNumberOfCustomers() {
        return numberOfCustomers;
    }

    public void setNumberOfCustomers(int numberOfCustomers) {
        this.numberOfCustomers = numberOfCustomers;
    }
}
