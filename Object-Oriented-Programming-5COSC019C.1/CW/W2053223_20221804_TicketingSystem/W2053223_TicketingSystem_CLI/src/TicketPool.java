import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class TicketPool {
    private List<Ticket> availableTickets = Collections.synchronizedList(new ArrayList<>());
    private Event event;
    private Configuration config;
    private Lock poolLock = new ReentrantLock();
    private int totalTicketsSold = 0;
    private int totalTicketsAdded = 0;

    // Constructor initializes the ticket pool with event and configuration
    public TicketPool(Event event, Configuration config) {
        this.event = event;
        this.config = config;
    }

    // Adds tickets to the pool with respect to the available capacity
    public void addTickets(int numberOfTickets) {
        poolLock.lock(); // Ensure that this section is thread-safe
        try {
            int poolCapacity = config.getMaxTicketCapacity();
            int availableCapacity = poolCapacity - totalTicketsAdded;

            // Check if the pool is already full
            if (availableCapacity <= 0) {
                System.out.println("INTERRUPT: The ticket pool for event " + event.getEventName() +
                        " has reached the maximum number of tickets.");
                Thread.currentThread().interrupt(); // Stop execution if max capacity is reached
                return;
            }

            // Add tickets to the pool, ensuring we don't exceed the capacity
            int ticketsToAdd = Math.min(numberOfTickets, poolCapacity - availableTickets.size());
            for (int i = 0; i < ticketsToAdd; i++) {
                Ticket ticket = new Ticket(event);
                availableTickets.add(ticket);
                totalTicketsAdded++;
            }

            if (ticketsToAdd < numberOfTickets) {
                System.out.println("ADDED: Only " + ticketsToAdd + " tickets added to " + event.getEventName() +
                        " by vendor " + Thread.currentThread().getName());
            } else {
                System.out.println("ADDED: All tickets successfully added by vendor " + Thread.currentThread().getName() +
                        " for event " + event.getEventName());
            }
        } finally {
            poolLock.unlock(); // Release the lock
        }
    }

    // Removes a ticket from the pool if available
    public Ticket removeTicket() {
        poolLock.lock(); // Ensure thread safety
        try {
            if (totalTicketsSold >= config.getMaxTicketCapacity()) {
                System.out.println("INTERRUPT: " + Thread.currentThread().getName() + ": Event " + event.getEventName() + " is SOLD OUT!");
                return null; // Event is sold out
            } else if (availableTickets.isEmpty()) {
                System.out.println(Thread.currentThread().getName() + ": No tickets currently available in " + event.getEventName() + " pool.");
                return null; // No tickets available
            } else {
                Ticket ticket = availableTickets.remove(0);
                totalTicketsSold++;
                System.out.println("REMOVED: by " + Thread.currentThread().getName() + " from " + event.getEventName() +
                        " | Available Tickets: " + availableTickets.size());
                return ticket;
            }
        } finally {
            poolLock.unlock(); // Release the lock
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

    // Getters and setters for the pool's tickets and event
    public List<Ticket> getAvailableTicketsList() {
        return availableTickets;
    }

    public void setAvailableTickets(List<Ticket> availableTickets) {
        this.availableTickets = availableTickets;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public Configuration getConfig() {
        return config;
    }

    public void setConfig(Configuration config) {
        this.config = config;
    }
}

//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.List;
//import java.util.concurrent.Executors;
//import java.util.concurrent.locks.Condition;
//import java.util.concurrent.locks.Lock;
//import java.util.concurrent.locks.ReentrantLock;
//
//public class TicketPool {
//    private List<Ticket> tickets = Collections.synchronizedList(new ArrayList<>());
//    private Event event;
//    private Configuration config;
//    private Lock lock = new ReentrantLock();
//    private int totalTicketsSold = 0;
//    private int totalTicketsAdded = 0;
//
//    public TicketPool(Event event,  Configuration config) {
//        this.event = event;
//        this.config = config;
//    }
//
//    public void addTickets(int noOfTickets) {
//        lock.lock();
//        System.out.println("Current tickets available in pool " + tickets.size());
//
//        try {
//            //int ticketCount = tickets.size(); // current tickets available - should be equal to totalTickets
//            int poolCapacity = config.maxTicketCapacity;
//            int availableCapacity = poolCapacity - totalTicketsAdded;
//
//            //if(ticketCount == poolCapacity) {
//            if(availableCapacity <= 0) {
//                System.out.println("INTERRUPT: The ticket pool for event " + event.getEventName() +" has reached the " +
//                        "maximum " +
//                        "number of tickets");
//                Thread.currentThread().interrupt();
//                return;
//            }
//
//            int ticketsToAdd = Math.min(noOfTickets, poolCapacity - tickets.size());
//            for(int i = 0; i < ticketsToAdd; i++) {
//                Ticket ticket = new Ticket(event);
//                tickets.add(ticket);
//                totalTicketsAdded++;
//                //System.out.println("Ticket added by vendor" + Thread.currentThread().getName());
//            }
//
//            //config.setTotalTickets(ticketCount + ticketsToAdd);
//
//            if(ticketsToAdd < noOfTickets) {
//                System.out.println("ADDED: Only" + ticketsToAdd + " tickets added to" + event.getEventName() + "by " +
//                        "vendor " + Thread.currentThread().getName());
//            } else {
//                System.out.println("ADDED: All Tickets successfully added by vendor " + Thread.currentThread().getName() + "for event " + event.getEventName());
//            }
//        } finally {
//            lock.unlock();
//            //System.out.println("Lock released by vendor" + Thread.currentThread().getName());
//        }
//    }
//
//
//    /*
//    removes an individual ticket from the pool
//     */
//    public Ticket removeTicket() {
//        lock.lock();
//        try {
//            // ticket sales has reached max capacity
//            if(totalTicketsSold >= config.maxTicketCapacity) {
//                System.out.println("INTERRUPT: " + Thread.currentThread().getName() + ": Event " + event.getEventName() + "is SOLD " +
//                        "OUT!");
//                //Thread.currentThread().interrupt(); CHECK
//                return null;
//            }
//            // max capacity has not been reached, but currently not available tickets
//            else if (tickets.isEmpty()) {
//                System.out.println(Thread.currentThread().getName() + ": No tickets currently available in " + event.getEventName() + " " +
//                        "pool.");
//                return null;
//            }
//            // max capacity has not been reached, and there are available tickets
//            Ticket ticket = tickets.remove(0);
//            totalTicketsSold++;
//            System.out.println("REMOVED: by" + Thread.currentThread().getName() + " from " + event.getEventName() + " | " +
//                    "Available " +
//                    "Tickets: " + tickets.size());
//            return ticket;
//
//        } finally {
//            lock.unlock();
//        }
//    }
//
//    public int getAvailableTickets() { lock.lock(); try { return tickets.size(); } finally { lock.unlock();}}
//    public int getTotalTicketsSold() { lock.lock(); try { return totalTicketsSold; } finally { lock.unlock(); }}
//
//    public List<Ticket> getTickets() {return tickets;}
//    public void setTickets(List<Ticket> tickets) {this.tickets = tickets;}
//
//    public Event getEvent() {return event;}
//    public void setEvent(Event event) {this.event = event;}
//
//    public Configuration getConfig() {return config;}
//    public void setConfig(Configuration config) {this.config = config;}
//
//    public Object getConfiguration() {
//        return null;
//    }
//}