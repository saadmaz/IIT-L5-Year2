import java.util.ArrayList;
import java.util.List;

public class Main {
    private static final int VENDORS = 2;
    private static final int CONSUMERS = 3;

    public static void main(String[] args) {
        System.out.println("************************************");
        System.out.println("Welcome to the Ticketing System CLI!");
        System.out.println("************************************");

        while (true) {
            System.out.println();
            System.out.println("1. Guide to configuration");
            System.out.println("2. Register as a vendor");
            System.out.println("3. Test system (default configuration)");
            System.out.println("4. Navigate to website");
            System.out.println("5. Exit");

            switch (Validator.validInt("Enter an option number: ", 1)) {
                case 1 -> printGuide();
                case 2 -> {
                    registerVendor();
                    simulation(setupConfiguration()); // run the simulation with the vendor's settings
                }
                case 3 -> simulation(new Configuration(6, 5, 6, 20));
                case 4 -> System.out.println("The website is not available yet.");
                case 5 -> {
                    System.out.println("Goodbye!");
                    return;
                }
                default -> System.out.println(">> Enter a valid option number!");
            }
        }
    }

    private static void printGuide() {
        System.out.println("------ GUIDE TO CONFIGURATION ------");
        System.out.println("Maximum ticket capacity : total tickets the event will sell.");
        System.out.println("Total tickets           : tickets already in the pool when sales start (up to the maximum).");
        System.out.println("Ticket release rate     : tickets each vendor adds per second.");
        System.out.println("Customer retrieval rate : tickets each customer buys per second.");
    }

    // Collects and validates vendor details (not saved anywhere yet)
    public static void registerVendor() {
        String fullName = Validator.validSize("Enter your full name: ", 2, 100, "Full name must be between 2 and 100 characters.");
        String username = Validator.validSize("Enter your username: ", 3, 30, "Username must be between 3 and 30 characters.");
        Validator.validEmail("Enter your email: ");
        Validator.validSize("Enter your password: ", 8, 30, "Password must be between 8 and 30 characters.");
        System.out.println("Welcome, " + fullName + " (" + username + ")! Now set up your ticket pool.");
    }

    public static Configuration setupConfiguration() {
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

    // Runs vendors and customers against one event until it sells out
    public static void simulation(Configuration config) {
        Event concert = new Event("CONCERT", "Example date", "Example venue");
        TicketPool pool = new TicketPool(concert, config);
        System.out.println("Simulating " + concert + " with " + VENDORS + " vendors and "
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
