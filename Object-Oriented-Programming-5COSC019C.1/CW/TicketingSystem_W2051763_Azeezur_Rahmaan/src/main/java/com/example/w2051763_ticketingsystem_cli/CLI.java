package com.example.w2051763_ticketingsystem_cli;

import com.mongodb.MongoException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CLI {
    private static final int VENDORS = 2;
    private static final int CONSUMERS = 3;
    private static final String WEBSITE_URL = "http://localhost:8080";

    private final DatabaseConnection dbConnection;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public CLI(DatabaseConnection dbConnection) {
        this.dbConnection = dbConnection;
    }

    public void menu() {
        System.out.println("Welcome to the Ticketing System CLI!");
        while (true) {
            System.out.println();
            System.out.println("1. Guide to configuration");
            System.out.println("2. Register as a vendor");
            System.out.println("3. Test system (run a simulation)");
            System.out.println("4. Navigate to website");
            System.out.println("5. Exit");

            switch (Validator.validInt("Enter an option number: ", 1)) {
                case 1 -> printGuide();
                case 2 -> registerVendor();
                case 3 -> simulation();
                case 4 -> System.out.println("Start the backend and open " + WEBSITE_URL + " in your browser.");
                case 5 -> {
                    System.out.println("Goodbye!");
                    return;
                }
                default -> System.out.println(">> Enter a valid option number!");
            }
        }
    }

    private void printGuide() {
        System.out.println("------ GUIDE TO CONFIGURATION ------");
        System.out.println("Maximum ticket capacity : total tickets the event will sell.");
        System.out.println("Total tickets           : tickets already in the pool when sales start (up to the maximum).");
        System.out.println("Ticket release rate     : tickets each vendor adds per second.");
        System.out.println("Customer retrieval rate : tickets each customer buys per second.");
    }

    public void registerVendor() {
        String fullName = Validator.validSize("Enter your full name: ", 2, 100, "Full name must be between 2 and 100 characters");
        String username = Validator.validSize("Enter your username: ", 3, 30, "Username must be between 3 and 30 characters");
        String email = Validator.validEmail("Enter your email: ");
        String password = Validator.validSize("Enter your password: ", 8, 30, "Password must be between 8 and 30 characters");

        try {
            if (dbConnection.checkVendorExists(username)) {
                System.out.println("Vendor with username " + username + " already exists.");
                return;
            }
            Configuration config = setupConfiguration();
            dbConnection.saveVendor(fullName, username, email, passwordEncoder.encode(password),
                    config, LocalDateTime.now());
            System.out.println("Vendor " + username + " registered.");
        } catch (MongoException e) {
            System.out.println(">> Could not reach the database: " + e.getMessage());
            System.out.println(">> Check that MongoDB is running or that MONGODB_URI is set.");
        }
    }

    public Configuration setupConfiguration() {
        int maxTicketCapacity = Validator.validInt("Enter the maximum ticket capacity: ", 1);
        int totalTickets = Validator.validInt("Enter the tickets available at the start: ", 0);
        while (totalTickets > maxTicketCapacity) {
            System.out.println(">> Starting tickets cannot exceed the maximum capacity (" + maxTicketCapacity + ").");
            totalTickets = Validator.validInt("Enter the tickets available at the start: ", 0);
        }
        int ticketReleaseRate = Validator.validInt("Enter the tickets each vendor releases per second: ", 1);
        int customerRetrievalRate = Validator.validInt("Enter the tickets each customer buys per second: ", 1);
        return new Configuration(totalTickets, ticketReleaseRate, customerRetrievalRate, maxTicketCapacity);
    }

    /** Runs vendors and consumers against one event until it sells out. */
    public void simulation() {
        Configuration config = Validator.yesNo("Use the default configuration?")
                ? new Configuration(0, 5, 6, 20)
                : setupConfiguration();
        Event concert = new Event("CONCERT", 120);
        TicketPool pool = new TicketPool(concert, config);
        System.out.println("Simulating " + concert.getEventName() + " with " + VENDORS + " vendors and "
                + CONSUMERS + " customers (" + config + ")");

        List<Thread> threads = new ArrayList<>();
        for (int i = 1; i <= VENDORS; i++) {
            threads.add(new Thread(new Vendor(pool), "Vendor-" + i));
        }
        for (int i = 1; i <= CONSUMERS; i++) {
            threads.add(new Thread(new Consumer(pool), "Customer-" + i));
        }
        threads.forEach(Thread::start);

        // Wait for the simulation to finish before showing the menu again
        try {
            for (Thread thread : threads) {
                thread.join();
            }
        } catch (InterruptedException e) {
            threads.forEach(Thread::interrupt);
            Thread.currentThread().interrupt();
        }
        System.out.println("Simulation finished: " + pool.getTotalTicketsSold() + " tickets sold.");
    }
}
