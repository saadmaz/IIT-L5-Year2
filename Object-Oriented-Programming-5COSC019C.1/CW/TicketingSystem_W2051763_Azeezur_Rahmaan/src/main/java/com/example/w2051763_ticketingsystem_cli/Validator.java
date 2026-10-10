package com.example.w2051763_ticketingsystem_cli;

import java.util.Scanner;
import java.util.regex.Pattern;

/**
 * Reads and validates console input. All input goes through this one Scanner and is read
 * line by line, so names with spaces work and bad input never leaves junk for the next prompt.
 */
public final class Validator {
    private static final Scanner scanner = new Scanner(System.in);
    private static final Pattern EMAIL = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");

    private Validator() {
    }

    /** Reads a whole number that is at least {@code min}. */
    public static int validInt(String prompt, int min) {
        while (true) {
            String input = readLine(prompt);
            try {
                int value = Integer.parseInt(input);
                if (value >= min) {
                    return value;
                }
                System.out.println(">> Invalid - enter a number of at least " + min + ".");
            } catch (NumberFormatException e) {
                System.out.println(">> Invalid - value must be a whole number.");
            }
        }
    }

    /** Reads text whose length is between {@code min} and {@code max}. */
    public static String validSize(String prompt, int min, int max, String errMsg) {
        while (true) {
            String input = readLine(prompt);
            if (input.length() >= min && input.length() <= max) {
                return input;
            }
            System.out.println(">> Invalid - " + errMsg);
        }
    }

    public static String validEmail(String prompt) {
        while (true) {
            String input = readLine(prompt);
            if (EMAIL.matcher(input).matches()) {
                return input;
            }
            System.out.println(">> Invalid - enter a valid email address.");
        }
    }

    /** Asks a yes/no question; returns true for yes. */
    public static boolean yesNo(String prompt) {
        while (true) {
            String input = readLine(prompt + " (y/n): ").toLowerCase();
            if (input.equals("y") || input.equals("yes")) {
                return true;
            }
            if (input.equals("n") || input.equals("no")) {
                return false;
            }
            System.out.println(">> Please answer y or n.");
        }
    }

    private static String readLine(String prompt) {
        System.out.print(prompt);
        if (!scanner.hasNextLine()) {
            System.out.println();
            System.exit(0); // input closed
        }
        return scanner.nextLine().trim();
    }
}
