// One ticket for an event
public class Ticket {
    private final int ticketId;
    private final Event event; // the event this ticket belongs to

    public Ticket(int ticketId, Event event) {
        this.ticketId = ticketId;
        this.event = event;
    }

    public int getTicketId() {
        return ticketId;
    }

    public Event getEvent() {
        return event;
    }

    @Override
    public String toString() {
        return event.getEventName() + " ticket #" + ticketId;
    }
}
