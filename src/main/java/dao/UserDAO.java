package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.User;
import util.DatabaseConnection;
import util.PasswordUtil;

public class UserDAO {

    // Existing method - Validate user credentials
    public boolean validateUser(String email, String password) {
        String sql = "SELECT password FROM users WHERE email = ? AND deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("Validating user with email: " + email);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                System.out.println("Found stored hash in database: " + storedHash);
                
                // Use the existing PasswordUtil to verify
                boolean isValid = PasswordUtil.verifyPassword(password, storedHash);
                System.out.println("Password validation result: " + isValid);
                return isValid;
            }
            System.out.println("No user found with email: " + email);
            return false;
        } catch (SQLException e) {
            System.out.println("SQL Error during validation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean isDummyData(String email) {
        return email != null && (email.equals("user1@example.com") || email.equals("user2@example.com"));
    }
    
    // Existing method - Register user
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)";
        System.out.println("\n=== Starting User Registration ===");
        System.out.println("Registering user with email: " + user.getEmail());
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Hash the password before storing
            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            System.out.println("Password hashed successfully");
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, hashedPassword);
            
            int result = stmt.executeUpdate();
            boolean success = result > 0;
            System.out.println("Registration " + (success ? "successful" : "failed"));
            return success;
            
        } catch (Exception e) {
            System.out.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Existing method - Check Email
    public boolean isEmailRegistered(String email) {
        String sql = "SELECT email FROM users WHERE email = ? AND deleted_at IS NULL";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.out.println("Error checking email registration: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Existing method - Get all users
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users WHERE deleted_at IS NULL";
        List<User> users = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    // Existing method - Get user ID by email
    public int getUserIdByEmail(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ? AND deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("user_id");
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // New method - Get user by ID
	public User getUserById(int id) throws SQLException {
	    System.out.println("UserDAO: Getting user with ID: " + id);
	    
	    String sql = "SELECT user_id, name, email, phone FROM users WHERE user_id = ?";
	    try (Connection conn = DatabaseConnection.getConnection()) {
	        System.out.println("UserDAO: Database connection established");
	        
	        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	            stmt.setInt(1, id);
	            System.out.println("UserDAO: Executing query: " + sql + " with ID: " + id);
	            
	            try (ResultSet rs = stmt.executeQuery()) {
	                if (rs.next()) {
	                    User user = new User();
	                    user.setId(rs.getInt("user_id"));
	                    user.setName(rs.getString("name"));
	                    user.setEmail(rs.getString("email"));
	                    user.setPhone(rs.getString("phone"));
	                    
	                    System.out.println("UserDAO: Found user: " + user.getName());
	                    return user;
	                }
	                System.out.println("UserDAO: No user found with ID: " + id);
	            }
	        }
	    } catch (SQLException e) {
	        System.out.println("UserDAO Error: " + e.getMessage());
	        throw e;
	    }
	    return null;
	}

    // New method - Update user profile
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, phone = ? WHERE user_id = ? AND deleted_at IS NULL";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    // New method - Update user password
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE user_id = ? AND deleted_at IS NULL";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        return user;
    }
    

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}