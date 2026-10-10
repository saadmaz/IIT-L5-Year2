# Ticketing System — Saad Mazhar (20221804 / W20532233)

Real-time event ticketing coursework (December 2024): vendors release tickets into a shared pool
while customers buy them, using multiple threads.

```
W2053223_TicketingSystem_CLI/       Working console app (plain Java, no build tool)
W2053223_TicketingSystem_BackEnd/   Spring Boot + MongoDB project — set up, but no endpoints yet
```

## CLI

```
src/
├── Main.java          Menu, vendor registration, simulation
├── Configuration.java Pool settings (capacity, starting tickets, release/retrieval rates)
├── TicketPool.java    Thread-safe pool shared by vendors and customers (ReentrantLock)
├── Vendor.java        Producer thread: releases tickets every second
├── Consumer.java      Consumer thread: buys tickets every second until sold out
├── Event.java         Event details
├── Ticket.java        One ticket
└── Validator.java     Console input validation
```

Run it from IntelliJ (`Main`), or:

```bash
cd W2053223_TicketingSystem_CLI
javac -d out src/*.java
java -cp out Main
```

## Backend

A Spring Boot application with the MongoDB starter, currently without controllers.
The database connection string is read from the `MONGODB_URI` environment variable
(defaults to a local MongoDB). **Never put a real username or password in `application.properties`.**

```bash
cd W2053223_TicketingSystem_BackEnd
./mvnw test
```
