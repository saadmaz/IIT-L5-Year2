import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

// Thread-safe pool shared by vendors and customers for one event.
// Vendors can add tickets until maxTicketCapacity have been released in total;
// the event is sold out once that many have been bought.
public class TicketPool {
    private final Queue<Ticket> availableTickets = new LinkedList<>();
    private final Event event;
    private final Configuration config;
    private final Lock poolLock = new ReentrantLock();
    private int totalTicketsAdded = 0;
    private int totalTicketsSold = 0;

    public TicketPool(Event event, Configuration config) {
        this.event = event;
        this.config = config;
        addTickets(config.getTotalTickets()); // tickets available from the start
    }

    // Adds up to numberOfTickets without going over the maximum capacity.
    // Returns how many were added; 0 means every ticket has already been released.
    public int addTickets(int numberOfTickets) {
        poolLock.lock();
        try {
            int ticketsToAdd = Math.min(numberOfTickets, config.getMaxTicketCapacity() - totalTicketsAdded);
            for (int i = 0; i < ticketsToAdd; i++) {
                availableTickets.add(new Ticket(++totalTicketsAdded, event));
            }
            if (ticketsToAdd > 0) {
                System.out.println("ADDED: " + ticketsToAdd + " tickets by " + Thread.currentThread().getName()
                        + " | Available: " + availableTickets.size()
                        + " | Released: " + totalTicketsAdded + "/" + config.getMaxTicketCapacity());
            }
            return ticketsToAdd;
        } finally {
            poolLock.unlock();
        }
    }

    // Returns the next ticket, or null if none are available right now
    public Ticket removeTicket() {
        poolLock.lock();
        try {
            Ticket ticket = availableTickets.poll();
            if (ticket != null) {
                totalTicketsSold++;
                System.out.println("BOUGHT: " + Thread.currentThread().getName() + " purchased " + ticket
                        + " | Available: " + availableTickets.size()
                        + " | Sold: " + totalTicketsSold + "/" + config.getMaxTicketCapacity());
            }
            return ticket;
        } finally {
            poolLock.unlock();
        }
    }

    public boolean isSoldOut() {
        poolLock.lock();
        try {
            return totalTicketsSold >= config.getMaxTicketCapacity();
        } finally {
            poolLock.unlock();
        }
    }

    public int getAvailableTickets() {
        poolLock.lock();
        try {
            return availableTickets.size();
        } finally {
            poolLock.unlock();
        }
    }

    public int getTotalTicketsSold() {
        poolLock.lock();
        try {
            return totalTicketsSold;
        } finally {
            poolLock.unlock();
        }
    }

    public Event getEvent() {
        return event;
    }

    public Configuration getConfig() {
        return config;
    }
}
