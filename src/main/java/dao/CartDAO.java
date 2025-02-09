package dao;

import models.Cart;
import util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    public boolean addToCart(Cart cart) {
        String sql = "INSERT INTO cart (user_id, service_id, booking_time, time_length) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cart.getUserId());
            stmt.setInt(2, cart.getServiceId());
            stmt.setTimestamp(3, cart.getBookingTime());
            stmt.setFloat(4, cart.getTimeLength());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Cart> getCartItems(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, s.service_name, s.price FROM cart c " +
                    "JOIN services s ON c.service_id = s.service_id " +
                    "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Cart item = new Cart();
                item.setCartId(rs.getInt("cart_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setServiceId(rs.getInt("service_id"));
                item.setBookingTime(rs.getTimestamp("booking_time"));
                item.setTimeLength(rs.getFloat("time_length"));
                item.setServiceName(rs.getString("service_name"));
                item.setPrice(rs.getDouble("price"));
                cartItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    public boolean removeFromCart(int cartId, int userId) {
        String sql = "DELETE FROM cart WHERE cart_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCart(Cart cart) {
        String sql = "UPDATE cart SET booking_time = ?, time_length = ? WHERE cart_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, cart.getBookingTime());
            stmt.setFloat(2, cart.getTimeLength());
            stmt.setInt(3, cart.getCartId());
            stmt.setInt(4, cart.getUserId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}