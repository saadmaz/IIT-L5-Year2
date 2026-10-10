# Real-Time Event Ticketing System

A producer–consumer simulation: vendor threads release tickets into a bounded, thread-safe
pool and customer threads buy them, until every ticket is sold or the user stops the system.
It can be controlled from the console or through a REST API.

## Project structure

```
src/main/java/com/juzail/ticketingsystem
├── TicketingSystemApplication.java   Spring Boot entry point
├── cli/
│   ├── Main.java                     Run the console only (no web server)
│   └── TicketingCli.java             Console: validated config + start/stop/status/config/exit
├── configuration/
│   └── AppConfig.java                Starts the console with Spring (ticketing.cli.enabled)
├── controller/
│   └── TicketController.java         REST API under /api/tickets
├── model/
│   ├── Ticket.java                   Immutable ticket
│   ├── TicketPool.java               Synchronized bounded pool (wait/notifyAll)
│   ├── Vendor.java                   Producer thread
│   ├── Customer.java                 Consumer thread
│   ├── SystemConfiguration.java      Simulation parameters + validation
│   └── SystemStatus.java             Status snapshot
└── service/
    └── TicketService.java            Starts/stops the threads, reports status
```

## Running

Requires Java 21+.

```bash
./mvnw spring-boot:run          # console + REST API on http://localhost:8080
./mvnw test                     # run the tests
```

To run only the REST API, set `ticketing.cli.enabled=false` in `application.properties`
(or pass `--ticketing.cli.enabled=false`).

## Configuration

| Field                   | Meaning                                         |
|-------------------------|-------------------------------------------------|
| `totalTickets`          | Total tickets for the event                     |
| `ticketReleaseRate`     | Milliseconds between releases, per vendor       |
| `customerRetrievalRate` | Milliseconds between purchases, per customer    |
| `maxTicketCapacity`     | Maximum tickets held in the pool at once        |
| `numberOfVendors`       | Vendor threads (default 3)                      |
| `numberOfCustomers`     | Customer threads (default 5)                    |

## REST API

| Method | Path                  | Body                         |
|--------|-----------------------|------------------------------|
| POST   | `/api/tickets/start`  | `SystemConfiguration` JSON   |
| POST   | `/api/tickets/stop`   | –                            |
| GET    | `/api/tickets/status` | –                            |

Example:

```bash
curl -X POST localhost:8080/api/tickets/start -H "Content-Type: application/json" \
  -d '{"totalTickets":50,"ticketReleaseRate":500,"customerRetrievalRate":800,"maxTicketCapacity":10}'
```
