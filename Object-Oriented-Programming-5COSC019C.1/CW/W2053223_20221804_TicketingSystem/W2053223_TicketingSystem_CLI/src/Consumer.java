public class Consumer implements Runnable {
    private TicketPool ticketPool;  // The pool from which the consumer (buyer) will get tickets

    // Constructor initializes the consumer with the ticket pool
    public Consumer(TicketPool ticketPool) {
        this.ticketPool = ticketPool;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            Ticket ticket = ticketPool.removeTicket();  // Try to remove a ticket from the pool
            if (ticket == null) {
                break;  // Stop if no ticket is available or the event is sold out
            }

            // Simulate the buyer taking some time to process the ticket
            try {
                Thread.sleep(500); // Simulate buyer processing time
            } catch (InterruptedException e) {
                System.out.println(Thread.currentThread().getName() + " was interrupted while purchasing a ticket.");
                Thread.currentThread().interrupt(); // Propagate the interrupt
                break;
            }
        }
        System.out.println(Thread.currentThread().getName() + " has finished purchasing tickets.");
    }
}

////// Consumer.java
////// This class represents a consumer in the ticketing system who retrieves tickets
////public class Consumer implements Runnable {
////    private TicketPool ticketPool; // Reference to the shared ticket pool
////
////    // Constructor to initialize the ticket pool for the consumer
////    public Consumer(TicketPool ticketPool) {
////        this.ticketPool = ticketPool;
////    }
////
////    // Main logic for the consumer thread
////    @Override
////    public void run() {
////        while (!Thread.currentThread().isInterrupted()) {
////            // Check if the tickets are sold out
////            boolean isSoldOut = ticketPool.getTotalTicketsSold() >= ticketPool.getConfiguration().getMaxTicketPoolCapacity();
////            System.out.println("!! Sold Out value: " + isSoldOut);
////
////            int retrievalRate = ticketPool.getConfiguration().getCustomerRetrievalRatePerSecond();
////
////            for (int i = 0; i < retrievalRate; i++) {
////                Ticket ticket = ticketPool.removeTicket(); // Attempt to retrieve a ticket
////                if (ticket != null) {
////                    System.out.println(Thread.currentThread().getName() + " successfully purchased a ticket for event: " + ticket.getEvent().getEventName());
////                } else if (isSoldOut) {
////                    System.out.println(Thread.currentThread().getName() + " Event is SOLD OUT! " + ticketPool.getEvent().getEventName());
////                    Thread.currentThread().interrupt(); // Stop the thread if sold out
////                    break;
////                } else if (ticketPool.getTickets().isEmpty() && !isSoldOut) {
////                    System.out.println(Thread.currentThread().getName() + " No tickets currently available. Retrying... " + ticketPool.getEvent().getEventName());
////                    try {
////                        Thread.sleep(500); // Retry after 500ms
////                    } catch (InterruptedException e) {
////                        Thread.currentThread().interrupt(); // Handle interruption
////                        break;
////                    }
////                }
////            }
////
////            // Stop execution if interrupted
////            if (Thread.currentThread().isInterrupted()) {
////                break;
////            }
////
////            try {
////                Thread.sleep(1000 / retrievalRate); // Adjust rate logic if necessary
////            } catch (InterruptedException e) {
////                System.out.println(Thread.currentThread().getName() + " was interrupted");
////                Thread.currentThread().interrupt(); // Propagate the interruption
////                break;
////            }
////
////            System.out.println(Thread.currentThread().getName() + " stopped for event " + ticketPool.getEvent().getEventName());
////        }
////    }
////}
//
//// Consumer.java
//// This class represents a consumer in the ticketing system who retrieves tickets
//public class Consumer implements Runnable {
//
//    // Reference to the shared ticket pool from which tickets are retrieved
//    private TicketPool ticketPool;
//
//    /**
//     * Constructor to initialize the ticket pool for the consumer.
//     *
//     * @param ticketPool The shared ticket pool that the consumer will interact with.
//     */
//    public Consumer(TicketPool ticketPool) {
//        this.ticketPool = ticketPool;
//    }
//
//    /**
//     * Main logic for the consumer thread.
//     * Continuously attempts to retrieve tickets from the ticket pool until tickets are sold out
//     * or the thread is interrupted.
//     */
//    @Override
//    public void run() {
//        while (!Thread.currentThread().isInterrupted()) {
//
//            // Check if tickets are sold out
//            boolean isSoldOut = ticketPool.getTotalTicketsSold() >= ticketPool.getConfiguration().getMaxTicketPoolCapacity();
//            System.out.println("!! Sold Out value: " + isSoldOut);
//
//            // Retrieve the rate at which consumers can attempt to get tickets (tickets per second)
//            int retrievalRate = ticketPool.getConfiguration().getCustomerRetrievalRatePerSecond();
//
//            for (int i = 0; i < retrievalRate; i++) {
//                // Attempt to retrieve a ticket from the ticket pool
//                Ticket ticket = ticketPool.removeTicket();
//
//                if (ticket != null) {
//                    // Successfully retrieved a ticket
//                    System.out.println(Thread.currentThread().getName() + " successfully purchased a ticket for event: " + ticket.getEvent().getEventName());
//                } else if (isSoldOut) {
//                    // Stop the thread if tickets are sold out
//                    System.out.println(Thread.currentThread().getName() + " Event is SOLD OUT! " + ticketPool.getEvent().getEventName());
//                    Thread.currentThread().interrupt(); // Signal the thread to stop
//                    break;
//                } else if (ticketPool.getTickets().isEmpty() && !isSoldOut) {
//                    // No tickets available currently, but not sold out
//                    System.out.println(Thread.currentThread().getName() + " No tickets currently available. Retrying... " + ticketPool.getEvent().getEventName());
//                    try {
//                        Thread.sleep(500); // Retry after a delay of 500ms
//                    } catch (InterruptedException e) {
//                        Thread.currentThread().interrupt(); // Handle interruption and exit
//                        break;
//                    }
//                }
//            }
//
//            // Stop the thread if it has been interrupted
//            if (Thread.currentThread().isInterrupted()) {
//                break;
//            }
//
//            try {
//                // Control the rate of ticket retrieval attempts
//                Thread.sleep(1000 / retrievalRate);
//            } catch (InterruptedException e) {
//                // Handle thread interruption during sleep
//                System.out.println(Thread.currentThread().getName() + " was interrupted");
//                Thread.currentThread().interrupt(); // Propagate the interruption signal
//                break;
//            }
//
//            // Log the stop event for this consumer thread
//            System.out.println(Thread.currentThread().getName() + " stopped for event " + ticketPool.getEvent().getEventName());
//        }
//    }
//}
