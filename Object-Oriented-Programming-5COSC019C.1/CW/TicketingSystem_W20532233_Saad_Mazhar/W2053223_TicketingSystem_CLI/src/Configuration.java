// Settings for one event's ticket pool
public class Configuration {
    private final int totalTickets;          // tickets already in the pool when sales start
    private final int ticketReleaseRate;     // tickets each vendor releases per second
    private final int customerRetrievalRate; // tickets each customer buys per second
    private final int maxTicketCapacity;     // total tickets the event will ever sell

    public Configuration(int totalTickets, int ticketReleaseRate, int customerRetrievalRate, int maxTicketCapacity) {
        this.totalTickets = totalTickets;
        this.ticketReleaseRate = ticketReleaseRate;
        this.customerRetrievalRate = customerRetrievalRate;
        this.maxTicketCapacity = maxTicketCapacity;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public int getTicketReleaseRate() {
        return ticketReleaseRate;
    }

    public int getCustomerRetrievalRate() {
        return customerRetrievalRate;
    }

    public int getMaxTicketCapacity() {
        return maxTicketCapacity;
    }

    @Override
    public String toString() {
        return "starting tickets=" + totalTickets + ", max capacity=" + maxTicketCapacity
                + ", release rate=" + ticketReleaseRate + "/s, retrieval rate=" + customerRetrievalRate + "/s";
    }
}
