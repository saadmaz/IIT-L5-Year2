public class Event {
    private String eventName;
    private String eventDate;
    private String eventLocation;

    public Event(String eventName, String eventDate, String eventLocation) {
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.eventLocation = eventLocation;
    }

    public Event(String concert, int i) {
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public String getEventLocation() {
        return eventLocation;
    }

    public void setEventLocation(String eventLocation) {
        this.eventLocation = eventLocation;
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventName='" + eventName + '\'' +
                ", eventDate='" + eventDate + '\'' +
                ", eventLocation='" + eventLocation + '\'' +
                '}';
    }
}

////// Event.java
////// This class represents an event associated with tickets
////public class Event {
////    private String eventName; // Name of the event
////    private double ticketPrice; // Price of the ticket
////
////    // Constructor to initialize event details
////    public Event(String eventName, double ticketPrice) {
////        this.eventName = eventName;
////        this.ticketPrice = ticketPrice;
////    }
////
////    // Getter and setter methods
////    public String getEventName() { return eventName; }
////    public void setEventName(String eventName) { this.eventName = eventName; }
////
////    public double getTicketPrice() { return ticketPrice; }
////    public void setTicketPrice(double ticketPrice) { this.ticketPrice = ticketPrice; }
////}
//
//public class Event {
//
//    // The name of the event
//    private String eventName;
//
//    // The price of a single ticket for the event
//    private double ticketPrice;
//
//    /**
//     * Constructor to initialize the details of the event.
//     *
//     * @param eventName   The name of the event.
//     * @param ticketPrice The price of a single ticket for the event.
//     */
//    public Event(String eventName, double ticketPrice) {
//        this.eventName = eventName; // Set the name of the event
//        this.ticketPrice = ticketPrice; // Set the ticket price
//    }
//
//    /**
//     * Gets the name of the event.
//     *
//     * @return The name of the event as a String.
//     */
//    public String getEventName() {
//        return eventName;
//    }
//
//    /**
//     * Sets the name of the event
//     * @param eventName The name of the event to be set.
//     */
//    public void setEventName(String eventName) {
//        this.eventName = eventName;
//    }
//
//    /**
//     * Gets the price of a single ticket for the event.
//     *
//     * @return The ticket price as a double.
//     */
//    public double getTicketPrice() {
//        return ticketPrice;
//    }
//
//    /**
//     * Sets the price of a single ticket for the event.
//     *
//     * @param ticketPrice The ticket price to be set.
//     */
//    public void setTicketPrice(double ticketPrice) {
//        this.ticketPrice = ticketPrice;
//    }
//}
