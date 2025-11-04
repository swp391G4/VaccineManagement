package util;
import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String password) {
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());
        System.out.println("Pass Duoc Gen: " + hash);
        return hash;
    }

    public static boolean verifyPassword(String password, String storedPassword) {
        if (password == null || storedPassword == null) {
            return false;
        }
        System.out.println("Plain password: " + password);
        System.out.println("Stored hash: " + storedPassword);
        System.out.println("Match result: " + BCrypt.checkpw(password, storedPassword));
        return BCrypt.checkpw(password, storedPassword);
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        StringBuilder password = new StringBuilder();
        java.util.Random random = new java.util.Random();

        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }

        return password.toString();
    }
}