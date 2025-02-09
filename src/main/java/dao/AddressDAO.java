package dao;

import models.Address;
import util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {
    private Connection conn;

    public AddressDAO() {
        try {
            this.conn = DatabaseConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all addresses for a specific user
    public List<Address> getUserAddresses(int userId) throws SQLException {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                addresses.add(mapResultSetToAddress(rs));
            }
        }
        return addresses;
    }

    // Get a specific address by its ID and verify it belongs to the user
    public Address getAddress(int addressId, int userId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE address_id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, addressId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAddress(rs);
            }
        }
        return null;
    }

    // Add a new address for a user
    public int addAddress(Address address) throws SQLException {
        String sql = "INSERT INTO addresses (user_id, address, postal_code) VALUES (?, ?, ?) RETURNING address_id";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, address.getUserId());
            stmt.setString(2, address.getAddress());
            stmt.setString(3, address.getPostalCode());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);  // Return the newly generated address_id
            }
        }
        return -1;
    }

    // Update an existing address
    public boolean updateAddress(Address address) throws SQLException {
        String sql = "UPDATE addresses SET address = ?, postal_code = ? WHERE address_id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, address.getAddress());
            stmt.setString(2, address.getPostalCode());
            stmt.setInt(3, address.getAddressId());
            stmt.setInt(4, address.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete an address
    public boolean deleteAddress(int addressId, int userId) throws SQLException {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, addressId);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setAddressId(rs.getInt("address_id"));
        address.setUserId(rs.getInt("user_id"));
        address.setAddress(rs.getString("address"));
        address.setPostalCode(rs.getString("postal_code"));
        return address;
    }
}