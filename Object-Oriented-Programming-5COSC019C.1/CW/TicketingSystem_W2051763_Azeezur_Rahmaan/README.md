# Event Ticketing System (W2051763)

Original author: Azeezur Rahmaan Azwin (W2051763), December 2024.

Two apps in one Maven project:

- **Backend** (`w2051763_ticketingsystem_be`): a Spring Boot REST API that stores vendors, consumers
  and events in MongoDB.
- **CLI** (`w2051763_ticketingsystem_cli`): a console app that registers vendors in the same database
  and runs a multi-threaded vendor/customer ticket simulation.

## Structure

```
src/main/java/com/example/
├── w2051763_ticketingsystem_be/
│   ├── W2051763TicketingSystemBeApplication.java   Spring Boot entry point
│   ├── config/PasswordConfig.java                  BCrypt password encoder
│   ├── controller/                                 REST endpoints + shared error handler
│   ├── model/                                      MongoDB documents (User, Vendor, Consumer, Event, Ticket, ...)
│   ├── repository/                                 Spring Data repositories
│   └── service/                                    Business logic
└── w2051763_ticketingsystem_cli/
    ├── Main.java                                   CLI entry point
    ├── CLI.java                                    Menu, vendor registration, simulation
    ├── TicketPool.java                             Thread-safe pool shared by vendors and customers
    ├── Vendor.java / Consumer.java                 Producer / consumer threads
    ├── Validator.java                              Console input validation
    └── DatabaseConnection.java                     MongoDB access for the CLI
```

## Database

Both apps read the MongoDB connection string from the `MONGODB_URI` environment variable and use the
`ticketingSystem_be` database. Without it they connect to a local MongoDB at `mongodb://localhost:27017`.
**Never put a real username or password in the code or in `application.properties`.**

```powershell
$env:MONGODB_URI = "mongodb+srv://<user>:<password>@<cluster>/"
```

## Running

Requires Java 17+.

```bash
./mvnw test                  # run the tests
./mvnw spring-boot:run       # backend on http://localhost:8080
```

To run the CLI, run `com.example.w2051763_ticketingsystem_cli.Main` from IntelliJ.
The simulation (menu option 3) does not need a database; registering a vendor (option 2) does.

## REST API

| Method | Path                          | Notes                                   |
|--------|-------------------------------|-----------------------------------------|
| GET    | `/api/vendors`                |                                         |
| GET    | `/api/vendors/{id}`           |                                         |
| POST   | `/api/vendors`                | Validated; password stored as BCrypt    |
| PATCH  | `/api/vendors/{id}`           | Updates only the fields sent            |
| DELETE | `/api/vendors/{id}`           |                                         |
| *same* | `/api/consumers`...           | Same five endpoints as vendors          |
| GET    | `/api/events`                 |                                         |
| GET    | `/api/events/{id}`            |                                         |
| GET    | `/api/events/vendor/{vendorId}` | Events for one vendor                 |
| POST   | `/api/events`                 | Validated; end time must be after start |

Passwords are accepted in requests but never returned in responses.
