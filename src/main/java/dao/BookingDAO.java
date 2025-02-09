package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import models.Booking;
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
	                
	                // Calculate total cost with GST
	                float price = rs.getFloat("price");
	                float timeLength = rs.getFloat("time_length");
	                float basePrice = price * timeLength;
	                booking.setTotalCost(basePrice * 1.09f); // Add 9% GST
	                
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
	            
	            // Calculate total cost with GST
	            float price = rs.getFloat("price");
	            float timeLength = rs.getFloat("time_length");
	            float basePrice = price * timeLength;
	            booking.setTotalCost(basePrice * 1.09f); // Add 9% GST
	            
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

    public int getTotalBookingsCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public List<Booking> getBookingsPaginated(int userId, int page, int itemsPerPage) throws SQLException {
        int offset = (page - 1) * itemsPerPage;
        String sql = "SELECT * FROM bookings WHERE user_id = ? ORDER BY booking_time DESC LIMIT ? OFFSET ?";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, itemsPerPage);
            stmt.setInt(3, offset);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }
        }
        return bookings;
    }

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setBookingTime(rs.getTimestamp("booking_time"));
        booking.setTimeLength(rs.getFloat("time_length"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        
        // Join with other tables to get additional information
        String sql = "SELECT bs.status_name, s.service_name, s.price, " +
                     "a.address, a.postal_code, u.name as user_name " +
                     "FROM bookings b " +
                     "JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                     "JOIN services s ON b.service_id = s.service_id " +
                     "JOIN addresses a ON b.address_id = a.address_id " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "WHERE b.booking_id = ?";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, booking.getId());
            ResultSet detailsRs = pstmt.executeQuery();
            
            if (detailsRs.next()) {
                booking.setStatus(detailsRs.getString("status_name"));
                booking.setServiceName(detailsRs.getString("service_name"));
                booking.setUserName(detailsRs.getString("user_name"));
                
                // Calculate total cost with GST
                float price = detailsRs.getFloat("price");
                float timeLength = booking.getTimeLength();
                float basePrice = price * timeLength;
                booking.setTotalCost(basePrice * 1.09f); // Add 9% GST
                
                // Set full address
                String fullAddress = detailsRs.getString("address");
                if (detailsRs.getString("postal_code") != null && !detailsRs.getString("postal_code").isEmpty()) {
                    fullAddress += " (" + detailsRs.getString("postal_code") + ")";
                }
                booking.setAddress(fullAddress);
            }
        }
        
        return booking;
    }

    public int getTotalBookingsCountByStatus(int userId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings b JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "WHERE b.user_id = ? AND LOWER(bs.status_name) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public List<Booking> getBookingsPaginatedByStatus(int userId, String status, int page, int itemsPerPage) throws SQLException {
        int offset = (page - 1) * itemsPerPage;
        String sql = "SELECT b.*, bs.status_name FROM bookings b " +
                    "JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "WHERE b.user_id = ? AND LOWER(bs.status_name) = LOWER(?) " +
                    "ORDER BY b.booking_time DESC LIMIT ? OFFSET ?";
        
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, status);
            stmt.setInt(3, itemsPerPage);
            stmt.setInt(4, offset);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
        return bookings;
    }

    public int getBookingsCountByStatus(int userId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings b JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "WHERE b.user_id = ? AND bs.status_name = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    public List<Booking> getBookingsByDateRange(Date startDate, Date endDate) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.name as user_name, s.service_name, s.price, " +
                    "bs.status_name as status, a.address, a.postal_code " +
                    "FROM bookings b " +
                    "JOIN users u ON b.user_id = u.user_id " +
                    "JOIN services s ON b.service_id = s.service_id " +
                    "JOIN booking_statuses bs ON b.status_id = bs.status_id " +
                    "JOIN addresses a ON b.address_id = a.address_id " +
                    "WHERE b.booking_time BETWEEN ? AND ? " +
                    "ORDER BY b.booking_time DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, new java.sql.Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new java.sql.Timestamp(endDate.getTime()));
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                bookings.add(mapBookingFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Map<String, Object>> getTopCustomersByValue(int limit) {
        List<Map<String, Object>> customers = new ArrayList<>();
        String sql = "SELECT u.user_id, u.name, u.email, " +
                    "COUNT(b.booking_id) as booking_count, " +
                    "SUM(s.price * b.time_length * 1.09) as total_spent " +
                    "FROM users u " +
                    "JOIN bookings b ON u.user_id = b.user_id " +
                    "JOIN services s ON b.service_id = s.service_id " +
                    "GROUP BY u.user_id, u.name, u.email " +
                    "ORDER BY total_spent DESC " +
                    "LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("userId", rs.getInt("user_id"));
                customer.put("name", rs.getString("name"));
                customer.put("email", rs.getString("email"));
                customer.put("bookingCount", rs.getInt("booking_count"));
                customer.put("totalSpent", rs.getDouble("total_spent"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public List<Map<String, Object>> getCustomersByService(int serviceId) {
        List<Map<String, Object>> customers = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.name, u.email, " +
                    "COUNT(b.booking_id) as booking_count " +
                    "FROM users u " +
                    "JOIN bookings b ON u.user_id = b.user_id " +
                    "WHERE b.service_id = ? " +
                    "GROUP BY u.user_id, u.name, u.email " +
                    "ORDER BY booking_count DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("userId", rs.getInt("user_id"));
                customer.put("name", rs.getString("name"));
                customer.put("email", rs.getString("email"));
                customer.put("bookingCount", rs.getInt("booking_count"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    private Booking mapBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setBookingTime(rs.getTimestamp("booking_time"));
        booking.setTimeLength(rs.getFloat("time_length"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setStatus(rs.getString("status")); // Getting status_name from booking_statuses
        booking.setUserName(rs.getString("user_name"));
        booking.setServiceName(rs.getString("service_name"));
        
        // Calculate total cost with GST
        float price = rs.getFloat("price");
        float timeLength = rs.getFloat("time_length");
        float basePrice = price * timeLength;
        booking.setTotalCost(basePrice * 1.09f); // Add 9% GST
        
        // Set address with postal code
        String fullAddress = rs.getString("address") + " (" + rs.getString("postal_code") + ")";
        booking.setAddress(fullAddress);
        
        return booking;
    }
}