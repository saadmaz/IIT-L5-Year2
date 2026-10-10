package com.juzail.ticketingsystem.cli;

import com.juzail.ticketingsystem.service.TicketService;

import java.util.Scanner;

/**
 * Runs the command-line interface on its own, without starting the Spring web server.
 */
public class Main {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            new TicketingCli(new TicketService(), scanner).run();
        }
    }
}
