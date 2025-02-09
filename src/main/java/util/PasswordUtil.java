package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

public class PasswordUtil {
    private static final int SALT_LENGTH = 16; // Length of salt in bytes
    private static final int HASH_LENGTH = 32; // SHA-256 produces 32 bytes

    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // Hash password with salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());

            // Combine salt and hashed password
            byte[] combined = new byte[SALT_LENGTH + HASH_LENGTH];
            System.arraycopy(salt, 0, combined, 0, SALT_LENGTH);
            System.arraycopy(hashedPassword, 0, combined, SALT_LENGTH, HASH_LENGTH);

            // Convert to Base64 for storage
            String result = Base64.getEncoder().encodeToString(combined);
            System.out.println("Generated hash length: " + combined.length);
            return result;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Decode stored hash
            byte[] combined = Base64.getDecoder().decode(storedHash);
            
            // Verify combined length
            if (combined.length != (SALT_LENGTH + HASH_LENGTH)) {
                System.out.println("Invalid hash length: " + combined.length);
                return false;
            }

            // Extract salt and stored hash
            byte[] salt = Arrays.copyOfRange(combined, 0, SALT_LENGTH);
            byte[] storedHashBytes = Arrays.copyOfRange(combined, SALT_LENGTH, combined.length);

            // Hash input password with same salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());

            // Compare hashes
            return MessageDigest.isEqual(storedHashBytes, hashedPassword);
        } catch (Exception e) {
            System.out.println("Error during password verification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}