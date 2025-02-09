package dao;

import models.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseConnection;

public class BookingDAO {
    
	public boolean createBooking(int userId, int serviceId, int addressId, Timestamp bookingTime, float timeLength, String specialRequests) {
	    String sql = "INSERT INTO bookings (user_id, service_id, address_id, status_id, booking_time, time_length, special_requests) " +
	                 "VALUES (?, ?, ?, (SELECT status_id FROM booking_statuses WHERE status_name = 'Pending'), ?, ?, ?)";
	                 
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        pstmt.setInt(2, serviceId);
	        pstmt.setInt(3, addressId);
	        pstmt.setTimestamp(4, bookingTime);
	        pstmt.setFloat(5, timeLength);
	        pstmt.setString(6, specialRequests);
	        
	        int affectedRows = pstmt.executeUpdate();
	        return affectedRows > 0;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}
    
    public int getTotalBookings() {
        String sql = "SELECT COUNT(*) FROM bookings";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Booking> getRecentBookings(int limit) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.booking_time, " +
                    "b.status_id, bs.status_name, b.special_requests, b.time_length, " +
                    "u.name AS user_name, s.service_name " +
                    "FROM bookings b " +
                    "INNER JOIN users u ON b.user_id = u.user_id " +
                    "INNER JOIN services s ON b.service_id = s.service_id " +
                    "INNER JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "ORDER BY b.booking_time DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("booking_id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingTime(rs.getTimestamp("booking_time"));
                    booking.setStatus(rs.getString("status_name")); // Using status_name instead of status_id
                    booking.setSpecialRequests(rs.getString("special_requests"));
                    booking.setTimeLength(rs.getFloat("time_length"));
                    booking.setUserName(rs.getString("user_name"));
                    booking.setServiceName(rs.getString("service_name"));
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public boolean updateBookingStatus(int bookingId, int statusId) {
        String sql = "UPDATE bookings SET status_id = ? WHERE booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, statusId);
            stmt.setInt(2, bookingId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Booking> getPendingBookings() {
        return getBookingsByStatus(1); // Assuming 1 is pending status
    }
    
    public List<Booking> getUserBookings(int userId) throws SQLException {
	    List<Booking> bookings = new ArrayList<>();
	    
	    String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.booking_time, b.time_length, " +
	                 "b.special_requests, bs.status_name as status, s.service_name, s.price, " +
	                 "a.address, a.postal_code " +
	                 "FROM bookings b " +
	                 "JOIN booking_statuses bs ON b.status_id = bs.status_id " +
	                 "JOIN services s ON b.service_id = s.service_id " +
	                 "JOIN addresses a ON b.address_id = a.address_id " +
	                 "WHERE b.user_id = ? " +
	                 "ORDER BY b.booking_time DESC";
	
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                Booking booking = new Booking();
	                booking.setId(rs.getInt("booking_id"));
	                booking.setUserId(rs.getInt("user_id"));
	                booking.setServiceId(rs.getInt("service_id"));
	                booking.setBookingTime(rs.getTimestamp("booking_time"));
	                booking.setTimeLength(rs.getFloat("time_length"));
	                booking.setSpecialRequests(rs.getString("special_requests"));
	                booking.setStatus(rs.getString("status")); // Getting status_name from booking_statuses
	                booking.setServiceName(rs.getString("service_name"));
	                
	                // Calculate total cost
	                float price = rs.getFloat("price");
	                float timeLength = rs.getFloat("time_length");
	                booking.setTotalCost(price * timeLength);
	                
	                // Set address with postal code
	                String fullAddress = rs.getString("address") + " (" + rs.getString("postal_code") + ")";
	                booking.setAddress(fullAddress);
	                
	                bookings.add(booking);
	            }
	        }
	    }
	    return bookings;
	}
	
	public List<Booking> getAllBookings() {
	    List<Booking> bookings = new ArrayList<>();
	    String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.booking_time, b.time_length, " +
	                 "b.special_requests, bs.status_name as status, u.name as user_name, " +
	                 "s.service_name, s.price, " +
	                 "a.address, a.postal_code " +
	                 "FROM bookings b " +
	                 "JOIN booking_statuses bs ON b.status_id = bs.status_id " +
	                 "JOIN users u ON b.user_id = u.user_id " +
	                 "JOIN services s ON b.service_id = s.service_id " +
	                 "JOIN addresses a ON b.address_id = a.address_id " +
	                 "ORDER BY b.booking_time DESC";
	
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {
	        
	        while (rs.next()) {
	            Booking booking = new Booking();
	            booking.setId(rs.getInt("booking_id"));
	            booking.setUserId(rs.getInt("user_id"));
	            booking.setServiceId(rs.getInt("service_id"));
	            booking.setBookingTime(rs.getTimestamp("booking_time"));
	            booking.setTimeLength(rs.getFloat("time_length"));
	            booking.setSpecialRequests(rs.getString("special_requests"));
	            booking.setStatus(rs.getString("status"));
	            booking.setUserName(rs.getString("user_name"));
	            booking.setServiceName(rs.getString("service_name"));
	            
	            // Calculate total cost
	            float price = rs.getFloat("price");
	            float timeLength = rs.getFloat("time_length");
	            booking.setTotalCost(price * timeLength);
	            
	            // Set full address
	            String fullAddress = rs.getString("address");
	            if (rs.getString("postal_code") != null && !rs.getString("postal_code").isEmpty()) {
	                fullAddress += " (" + rs.getString("postal_code") + ")";
	            }
	            booking.setAddress(fullAddress);
	            
	            bookings.add(booking);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return bookings;
	}
	    
    private List<Booking> getBookingsByStatus(int statusId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.booking_time, " +
                    "b.status_id, bs.status_name, b.special_requests, b.time_length, " +
                    "u.name AS user_name, s.service_name " +
                    "FROM bookings b " +
                    "INNER JOIN users u ON b.user_id = u.user_id " +
                    "INNER JOIN services s ON b.service_id = s.service_id " +
                    "INNER JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "WHERE b.status_id = ? " +
                    "ORDER BY b.booking_time DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, statusId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("booking_id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setServiceId(rs.getInt("service_id"));
                    booking.setBookingTime(rs.getTimestamp("booking_time"));
                    booking.setStatus(rs.getString("status_name"));
                    booking.setSpecialRequests(rs.getString("special_requests"));
                    booking.setTimeLength(rs.getFloat("time_length"));
                    booking.setUserName(rs.getString("user_name"));
                    booking.setServiceName(rs.getString("service_name"));
                    
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}