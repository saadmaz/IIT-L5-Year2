// 4) Modify code to validate user input and handle non-integer input errors.
import java.util.Scanner;

public class Question04 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int value = 0;
        System.out.println("Please enter an integer:");

        // Try-catch to handle incorrect input types
        try {
            value = input.nextInt();
            System.out.println("Value: " + value);
        } catch (java.util.InputMismatchException e) {
            // If the input is not an integer, this block will execute
            System.out.println("Error: Please enter a valid integer.");
        }
        input.close();
    }
}