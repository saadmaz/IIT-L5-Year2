public class Vendor implements Runnable {
    private TicketPool ticketPool;

    // Constructor initializes the vendor with the ticket pool
    public Vendor(TicketPool ticketPool) {
        this.ticketPool = ticketPool;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            int ticketReleaseRate = ticketPool.getConfig().ticketReleaseRate;
            ticketPool.addTickets(ticketReleaseRate); // Add tickets based on the release rate

            try {
                // Add delay between ticket additions according to the release rate
                Thread.sleep(1000 / ticketReleaseRate);
            } catch (InterruptedException e) {
                System.out.println(Thread.currentThread().getName() + " for event " + ticketPool.getEvent().getEventName() +
                        " was interrupted.");
                Thread.currentThread().interrupt(); // Propagate the interrupt
                break;
            }
        }
        System.out.println(Thread.currentThread().getName() + " stopped for event " + ticketPool.getEvent().getEventName());
    }
}

//import java.util.List;
//
//public class Vendor implements Runnable{
//    private String username;
//    //private String password;
//    //private List<Event> events;
//    private TicketPool ticketPool;
//
//    public Vendor(TicketPool ticketPool) {
//        this.ticketPool = ticketPool;
//    }
//
//    @Override
//    public void run() {
//        while(!Thread.currentThread().isInterrupted()) {
//            int releaseRate = ticketPool.getConfig().ticketReleaseRate;
//            ticketPool.addTickets(releaseRate);
//
//            try {
//                Thread.sleep(1000/releaseRate); // logic needs to be changed
//            }  catch (InterruptedException e) {
//                System.out.println(Thread.currentThread().getName() + " for event" + ticketPool.getEvent().getEventName() + " " +
//                        "was interrupted.");
//                Thread.currentThread().interrupt(); // propagate interrupted state
//                break;
//            }
//        }
//        System.out.println(Thread.currentThread().getName() + " stopped for event" + ticketPool.getEvent().getEventName());
//    }
//}