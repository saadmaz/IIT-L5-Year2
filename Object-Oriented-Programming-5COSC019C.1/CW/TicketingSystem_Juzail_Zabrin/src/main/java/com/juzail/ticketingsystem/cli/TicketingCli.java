package com.juzail.ticketingsystem.cli;

import com.juzail.ticketingsystem.model.SystemConfiguration;
import com.juzail.ticketingsystem.model.SystemStatus;
import com.juzail.ticketingsystem.service.TicketService;

import java.util.Scanner;

/**
 * Interactive console: reads a validated configuration, then accepts
 * {@code start}, {@code stop}, {@code status}, {@code config} and {@code exit} commands.
 */
public class TicketingCli {
    private final TicketService ticketService;
    private final Scanner scanner;
    private SystemConfiguration configuration;

    public TicketingCli(TicketService ticketService, Scanner scanner) {
        this.ticketService = ticketService;
        this.scanner = scanner;
    }

    public void run() {
        System.out.println("=== Real-Time Event Ticketing System ===");
        configuration = readConfiguration();
        printHelp();

        while (scanner.hasNextLine()) {
            String command = scanner.nextLine().trim().toLowerCase();
            switch (command) {
                case "start" -> start();
                case "stop" -> ticketService.stop();
                case "status" -> printStatus();
                case "config" -> {
                    if (ticketService.isRunning()) {
                        System.out.println("Stop the system before changing the configuration.");
                    } else {
                        configuration = readConfiguration();
                    }
                }
                case "exit" -> {
                    ticketService.stop();
                    System.out.println("Goodbye!");
                    return;
                }
                case "" -> { }
                default -> printHelp();
            }
        }
        ticketService.stop(); // input closed
    }

    private void start() {
        try {
            ticketService.start(configuration);
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage());
        }
    }

    private SystemConfiguration readConfiguration() {
        while (true) {
            SystemConfiguration config = new SystemConfiguration(
                    readInt("Total number of tickets: ", 1),
                    readInt("Ticket release rate (ms between releases per vendor): ", 0),
                    readInt("Customer retrieval rate (ms between purchases per customer): ", 0),
                    readInt("Maximum ticket pool capacity: ", 1));
            config.setNumberOfVendors(readInt("Number of vendors: ", 1));
            config.setNumberOfCustomers(readInt("Number of customers: ", 1));
            try {
                config.validate();
                return config;
            } catch (IllegalArgumentException e) {
                System.out.println(e.getMessage() + " Please enter the configuration again.");
            }
        }
    }

    private int readInt(String prompt, int min) {
        while (true) {
            System.out.print(prompt);
            if (!scanner.hasNextLine()) {
                throw new IllegalStateException("Input closed before configuration was complete.");
            }
            try {
                int value = Integer.parseInt(scanner.nextLine().trim());
                if (value >= min) {
                    return value;
                }
                System.out.println("The value must be at least " + min + ".");
            } catch (NumberFormatException e) {
                System.out.println("Invalid input. Please enter a whole number.");
            }
        }
    }

    private void printStatus() {
        SystemStatus status = ticketService.getStatus();
        System.out.printf("Running: %s | Released: %d/%d | Sold: %d/%d | In pool: %d/%d%n",
                status.running() ? "yes" : "no",
                status.ticketsReleased(), status.totalTickets(),
                status.ticketsSold(), status.totalTickets(),
                status.availableTickets(), status.maxTicketCapacity());
    }

    private static void printHelp() {
        System.out.println("Commands: start | stop | status | config | exit");
    }
}
