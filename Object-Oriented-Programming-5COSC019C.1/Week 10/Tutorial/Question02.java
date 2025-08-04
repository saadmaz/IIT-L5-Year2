    // 2) Add code to show a custom message when an out-of-bounds error occurs.
public class Question02 {
    public static void main(String[] args) {
        try {
            int myArray[] = new int[5];
            // Attempting to access index 5 (which doesn't exist)
            System.out.println(myArray[5]);
        } catch (ArrayIndexOutOfBoundsException e) {
            // Custom error message using the exception's message (the index attempted)
            System.out.println("The element " + e.getMessage() + " does not exist!");
        }
    }
}