import java.util.InputMismatchException;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {
    public static Scanner input = new Scanner(System.in);

    public static void main(String[] args) throws Exception {
        menu();
    }

    public static void menu() throws Exception {
        System.out.println("************************************");
        System.out.println("Welcome to the Ticketing System CLI!");
        System.out.println("************************************");
        boolean exit = false;
        do {
            System.out.println("1. Menu");
            System.out.println("2. Register as a Vendor");
            System.out.println("3. Test System");
            System.out.println("4. Navigate to Website");
            System.out.println("5. Exit");

            System.out.print("\nEnter an option number: ");
            int option;
            try {
                option = input.nextInt();
            } catch (InputMismatchException e) {
                input.nextLine();
                System.out.println("Invalid input. Please enter a number!\n");
                continue;
            }
            switch (option) {
                case 1:
                    menu(); // Recursive call for the menu
                    break;
                case 2:
                    registerVendor();
                    // Passing the configuration to simulation
                    Configuration config = setupConfiguration();
                    simulation(config); // Simulation uses the Configuration object
                    return;
                case 3:
                    // Passing a test configuration to simulation
                    Configuration testConfig = new Configuration(6, 5, 6, 20); // Example values
                    simulation(testConfig);
                    break;
                case 4:
                    System.out.println("Redirecting you to the website...");
                    break;
                case 5:
                    exit = true;
                    break;
                default:
                    System.out.println(">> Enter a Valid Option number! \n");
            }
        } while (!exit);
    }

    public static void registerVendor() {
        String fullName = Validator.validSize("Enter your full name: ", 3, 100, "Invalid Input. Full name must be between 2 and 100 characters.");
        String username = Validator.validSize("Enter your username: ", 5, 30, "Username must be between 3 and 30 characters.");
        String password = Validator.validSize("Enter your password: ", 8, 30, "Password must have at least 8 characters.");
        System.out.println("Vendor registration successful!");
    }

    // Configuration setup that returns a Configuration object
    public static Configuration setupConfiguration() {
        int maxTicketCapacity = Validator.validInt("Enter the maximum ticket capacity the system can hold: ");
        int totalTickets = Validator.validInt("Enter the total tickets available in the system: ");

        // Check if the total tickets are within the max capacity
        while (totalTickets > maxTicketCapacity) {
            System.out.println("The available tickets cannot exceed the maximum capacity of the pool. Please re-enter.");
            totalTickets = Validator.validInt("Enter the total tickets available in the system: ");
        }

        // Get the ticket release and retrieval rates
        int ticketReleaseRate = Validator.validInt("Enter the number of tickets that can be released per second: ");
        int customerRetrievalRate = Validator.validInt("Enter the number of tickets that can be purchased per second: ");

        // Create and return the Configuration object
        return new Configuration(totalTickets, ticketReleaseRate, customerRetrievalRate, maxTicketCapacity);
    }

    public static void simulation(Configuration config) {
        ExecutorService executor = Executors.newFixedThreadPool(5);

        // Using the provided configuration for the event and ticket pool
        Event concertEvent = new Event("CONCERT", 120);  // Example event
        TicketPool concertPool = new TicketPool(concertEvent, config);  // Using the passed config

        // Creating Vendor and Consumer threads
        Vendor concertVendor1 = new Vendor(concertPool);
        Vendor concertVendor2 = new Vendor(concertPool);
        Consumer concertConsumer1 = new Consumer(concertPool);
        Consumer concertConsumer2 = new Consumer(concertPool);
        Consumer concertConsumer3 = new Consumer(concertPool);

        // Executing tasks on the pool
        executor.execute(concertVendor1);
        executor.execute(concertConsumer1);
        executor.execute(concertConsumer2);
        executor.execute(concertVendor2);
        executor.execute(concertConsumer3);

        // Shutdown executor service after tasks are complete
        executor.shutdown();
        System.out.println("Simulation started...");
    }
}
