import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public interface Validator {
    Scanner scanner = new Scanner(System.in);

    // Validates user type input (either 'buyer' or 'vendor')
    static String validUserType(String prompt) {
        System.out.print(prompt);
        String userInput = scanner.next().toLowerCase();
        while (true) {
            if (userInput.equals("buyer") || userInput.equals("vendor")) {
                return userInput;
            }
            System.out.println(">> Input must be 'buyer' or 'vendor'. Try again!");
            System.out.print(prompt);
            userInput = scanner.next().toLowerCase();
        }
    }

    // Validates integer input
    static int validInt(String prompt) {
        while (true) {
            System.out.print(prompt);
            if (scanner.hasNextInt()) {
                int userInput = scanner.nextInt();
                if (userInput < 0) {
                    System.out.println(">> Invalid - cannot be a negative value. Enter a number larger than 0.");
                } else {
                    return userInput;
                }
            } else {
                System.out.println(">> Invalid - value must be a positive integer");
                scanner.next(); // Clear invalid input
            }
        }
    }

    // Validates string input for not being null
    static String notNull(String prompt, String errMsg) {
        while (true) {
            System.out.print(prompt);
            if (scanner.hasNext()) {
                String input = scanner.next();
                if (input == null) {
                    System.out.println(errMsg);
                } else {
                    return input;
                }
            } else {
                System.out.println(">> Invalid - " + errMsg);
                scanner.next(); // Clear invalid input
            }
        }
    }

    // Validates the size of the input string
    static String validSize(String prompt, int min, int max, String errMsg) {
        while (true) {
            System.out.print(prompt);
            if (scanner.hasNext()) {
                String input = scanner.next();
                if (input.length() >= min && input.length() <= max) {
                    return input;
                } else {
                    System.out.println(">> Invalid - " + errMsg);
                }
            } else {
                System.out.println(">> Invalid - " + errMsg);
                scanner.next(); // Clear invalid input
            }
        }
    }

    // Validates email format
    static String validEmail(String prompt, String errMsg) {
        while (true) {
            System.out.print(prompt);
            if (scanner.hasNext()) {
                String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
                Pattern emailPattern = Pattern.compile(emailRegex);

                String input = scanner.next();
                Matcher emailMatcher = emailPattern.matcher(input);
                if (emailMatcher.matches()) {
                    return input;
                } else {
                    System.out.println(">> Invalid - " + errMsg);
                }
            } else {
                System.out.println(">> Invalid - " + errMsg);
                scanner.next(); // Clear invalid input
            }
        }
    }
}

//import java.util.Scanner;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;
//
//public interface Validator {
//    Scanner scanner = new Scanner(System.in);
//
//    static String validUserType(String prompt) {
//        System.out.print(prompt);
//        String userInput  = scanner.next().toLowerCase();
//        while(true) {
//            if(userInput.equals("buyer") || userInput.equals("vendor")) {
//                return userInput;
//            }
//            System.out.println(">> Input must be 'buyer' or 'vendor'. Try again!");
//            System.out.print(prompt);
//            userInput  = scanner.next().toLowerCase();
//        }
//    }
//
//    static int validInt(String prompt) {
//        while(true) {
//            System.out.print(prompt);
//            if(scanner.hasNextInt()) {
//                int userInput  = scanner.nextInt();
//                if(userInput < 0) {
//                    System.out.println(">> Invalid - cannot be a negative value. Enter a number larger than 0.");
//                } else {
//                    return userInput;
//                }
//            } else {
//                System.out.println(">> Invalid - value must be a positive integer");
//                scanner.next();
//            }
//        }
//    }
//
////    static int validDouble(String prompt) {
////        while(true) {
////            System.out.print(prompt);
////            if(scanner.hasNextDouble()) {
////                double userInput  = scanner.nextDouble();
////                if(!(userInput > 0)) {
////                    System.out.println(">> Invalid - cannot be a negative value. Enter a number larger than 0.");
////                } else {
////                    return userInput;
////                }
////            } else {
////                System.out.println(">> Invalid - value must be a positive integer");
////                scanner.next();
////            }
////        }
////    }
//
//    static String notNull(String prompt, String errMsg) {
//        while (true) {
//            System.out.print(prompt);
//            if(scanner.hasNext()) {
//                String input = scanner.next();
//                if(input == null) {
//                    System.out.println(errMsg);
//                    //return false;
//                } return input;
//            } else {
//                System.out.println(">> Invalid - " + errMsg);
//                scanner.next();
//            }
//        }
//    }
//
//    static String validSize(String prompt, int min, int max, String errMsg) {
//        while (true) {
//            System.out.print(prompt);
//            if(scanner.hasNext()) {
//                String input = scanner.next();
//                if(input.length() >= min && input.length() <= max) {
//                    return input;
//                } else {
//                    System.out.println(">> Invalid - " + errMsg);
//                }
//            } else {
//                System.out.println(">> Invalid - " + errMsg);
//                scanner.next();
//            }
//        }
//    }
//
//    static String validEmail(String prompt, String errMsg) {
//        while (true) {
//            System.out.print(prompt);
//            if(scanner.hasNext()) {
//                String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
//                Pattern emailPattern = Pattern.compile(emailRegex);
//
//                String input = scanner.next();
//                Matcher emailMatcher = emailPattern.matcher(input);
//                if(emailMatcher.matches()) {
//                    return input;
//                } else {
//                    System.out.println(">> Invalid - " + errMsg);
//                }
//            } else {
//                System.out.println(">> Invalid - " + errMsg);
//                scanner.next();
//            }
//        }
//    }
//}