import java.util.Scanner;

public class PasswordValidator {

    static boolean hasUpperCase(String password) {
        for (int i = 0; i < password.length(); i++) {
            if (Character.isUpperCase(password.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    static boolean hasDigit(String password) {
        for (int i = 0; i < password.length(); i++) {
            if (Character.isDigit(password.charAt(i))) {
                return true;
            }
        }
        return false;
    }

    static boolean validate(String password) {
        boolean valid = true;

        if (password.length() < 8) {
            System.out.println("  [FAIL] Too short. Minimum 8 characters required.");
            valid = false;
        }

        if (!hasUpperCase(password)) {
            System.out.println("  [FAIL] Missing an uppercase letter.");
            valid = false;
        }

        if (!hasDigit(password)) {
            System.out.println("  [FAIL] Missing a digit.");
            valid = false;
        }

        return valid;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        boolean passwordAccepted = false;

        System.out.println("--------------------------------------");
        System.out.println("   SafeLog - Employee Portal");
        System.out.println("   Password Validator v1.0");
        System.out.println("--------------------------------------");
        System.out.println("Password Policy:");
        System.out.println("  - At least 8 characters");
        System.out.println("  - At least one uppercase letter");
        System.out.println("  - At least one digit (0-9)");
        System.out.println("------------------------------------\n");

        while (!passwordAccepted) {
            System.out.print("Enter a new password: ");
            String password = scanner.nextLine();

            System.out.println("\nChecking password...");
            passwordAccepted = validate(password);

            if (passwordAccepted) {
                System.out.println("Password accepted! Your account is secured.");
            } else {
                System.out.println("\nPassword rejected. Please try again.\n");
            }
        }

        System.out.println("\n--------------------------------------");
        System.out.println("  Access granted. Welcome to SafeLog.");
        System.out.println("----------------------------------------");

        scanner.close();
    }
}