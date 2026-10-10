package com.example.w2051763_ticketingsystem_cli;

/**
 * Entry point for the command-line app (runs without the Spring backend).
 */
public class Main {
    public static void main(String[] args) {
        try (DatabaseConnection dbConnection = new DatabaseConnection()) {
            new CLI(dbConnection).menu();
        }
    }
}
