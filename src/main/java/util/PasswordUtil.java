package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    public static String hashPassword(String password) {
        try {
            System.out.println("Debug - Starting password hashing");
            System.out.println("Debug - Input password length: " + password.length());
            
            // Generate a salt and hash password
            String salt = BCrypt.gensalt(12);
            System.out.println("Debug - Generated salt: " + salt);
            
            String hashedPassword = BCrypt.hashpw(password, salt);
            System.out.println("Debug - Generated hash: " + hashedPassword);
            System.out.println("Debug - Hash length: " + hashedPassword.length());
            
            return hashedPassword;
            
        } catch (Exception e) {
            System.out.println("Error in hashPassword: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String password, String storedHash) {
        try {
            System.out.println("Debug - Starting password verification");
            System.out.println("Debug - Input password length: " + password.length());
            System.out.println("Debug - Stored hash: " + storedHash);
            System.out.println("Debug - Stored hash length: " + storedHash.length());
            
            boolean matches = BCrypt.checkpw(password, storedHash);
            System.out.println("Debug - Password match result: " + matches);
            
            return matches;
            
        } catch (Exception e) {
            System.out.println("Error in verifyPassword: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}