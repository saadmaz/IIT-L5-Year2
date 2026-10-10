// Consumer (buyer): every second, tries to buy customerRetrievalRate tickets
// until the event is sold out
public class Consumer implements Runnable {
    private final TicketPool ticketPool;

    public Consumer(TicketPool ticketPool) {
        this.ticketPool = ticketPool;
    }

    @Override
    public void run() {
        String name = Thread.currentThread().getName();
        int retrievalRate = ticketPool.getConfig().getCustomerRetrievalRate();
        try {
            while (!ticketPool.isSoldOut()) {
                for (int i = 0; i < retrievalRate; i++) {
                    if (ticketPool.removeTicket() == null) {
                        break; // none available right now; try again next second
                    }
                }
                Thread.sleep(1000);
            }
            System.out.println(name + ": " + ticketPool.getEvent().getEventName() + " is SOLD OUT.");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println(name + " was stopped.");
        }
    }
}
