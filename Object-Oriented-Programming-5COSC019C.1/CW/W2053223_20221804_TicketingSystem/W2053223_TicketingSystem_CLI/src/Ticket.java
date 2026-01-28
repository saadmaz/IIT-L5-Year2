public class Ticket {
    private Event event; // The event that this ticket belongs to

    // Constructor initializes the ticket with an event
    public Ticket(Event event) {
        this.event = event;
    }

    // Getter for event
    public Event getEvent() {
        return event;
    }

    // Setter for event
    public void setEvent(Event event) {
        this.event = event;
    }
}

//public class Ticket {
//    //private int ticketId;
//    //private boolean available; // false if the ticket has been sold
//    private Event event; // event that the ticket belongs to
//
//    public Ticket(Event event) {
//        this.event = event;
//        //this.available = true;
//    }
//
//    //public boolean isAvailable() {return available;}
//    //public void setAvailable(boolean available) {this.available = available;}
//
//    public Event getEvent() {return event;}
//    public void setEvent(Event event) {this.event = event;}
//}