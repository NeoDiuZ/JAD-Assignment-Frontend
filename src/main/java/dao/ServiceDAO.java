package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Review;
import models.Service;
import models.ServiceCategory;
import util.DatabaseConnection;

public class ServiceDAO {
    
    /**
     * Fetch all services with their respective category names and ratings.
     */
    public List<Service> getServicesWithCategory() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.service_id, s.service_name, s.description AS service_description, " +
                    "s.price, s.image_path, sc.category_id, sc.category_name, sc.description as category_description, " +
                    "COALESCE(AVG(r.rating), 0) as average_rating, " +
                    "COUNT(r.review_id) as review_count " +
                    "FROM services s " +
                    "INNER JOIN service_categories sc ON s.category_id = sc.category_id " +
                    "LEFT JOIN reviews r ON s.service_id = r.service_id " +
                    "GROUP BY s.service_id, sc.category_id " +
                    "ORDER BY sc.category_name, s.service_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                service.setName(rs.getString("service_name"));
                service.setDescription(rs.getString("service_description"));
                service.setPrice(rs.getDouble("price"));
                service.setImagePath(rs.getString("image_path"));
                service.setCategoryId(rs.getInt("category_id"));
                service.setCategoryName(rs.getString("category_name"));
                service.setCategoryDescription(rs.getString("category_description"));
                service.setAverageRating(rs.getDouble("average_rating"));
                service.setReviewCount(rs.getInt("review_count"));

                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    /**
     * Get a single service by ID with all details including ratings.
     */
    public Service getServiceById(int serviceId) {
        Service service = null;
        String sql = "SELECT s.service_id, s.service_name, s.description AS service_description, " +
                    "s.price, s.image_path, sc.category_id, sc.category_name, sc.description as category_description, " +
                    "COALESCE(AVG(r.rating), 0) as average_rating, " +
                    "COUNT(r.review_id) as review_count " +
                    "FROM services s " +
                    "INNER JOIN service_categories sc ON s.category_id = sc.category_id " +
                    "LEFT JOIN reviews r ON s.service_id = r.service_id " +
                    "WHERE s.service_id = ? " +
                    "GROUP BY s.service_id, sc.category_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setName(rs.getString("service_name"));
                    service.setDescription(rs.getString("service_description"));
                    service.setPrice(rs.getDouble("price"));
                    service.setImagePath(rs.getString("image_path"));
                    service.setCategoryId(rs.getInt("category_id"));
                    service.setCategoryName(rs.getString("category_name"));
                    service.setCategoryDescription(rs.getString("category_description"));
                    service.setAverageRating(rs.getDouble("average_rating"));
                    service.setReviewCount(rs.getInt("review_count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return service;
    }

    /**
     * Get all reviews for a specific service.
     */
    public List<Review> getServiceReviews(int serviceId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.user_id, u.name as user_name, r.service_id, " +
                    "r.rating, r.comments, r.created_at " +
                    "FROM reviews r " +
                    "JOIN users u ON r.user_id = u.user_id " +
                    "WHERE r.service_id = ? " +
                    "ORDER BY r.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("review_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setServiceId(rs.getInt("service_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comments"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    /**
     * Add a new review for a service.
     */
    public boolean addReview(int userId, int serviceId, int rating, String comment) {
        String sql = "INSERT INTO reviews (user_id, service_id, rating, comments, created_at) " +
                    "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, serviceId);
            stmt.setInt(3, rating);
            stmt.setString(4, comment);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a user has already reviewed a service.
     */
    public boolean hasUserReviewed(int userId, int serviceId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND service_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get all service categories.
     */
    public List<ServiceCategory> getAllCategories() {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description FROM service_categories ORDER BY category_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ServiceCategory category = new ServiceCategory();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Add a new service.
     */
    public boolean addService(Service service) {
        String sql = "INSERT INTO services (service_name, description, price, image_path, category_id) " +
                    "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getImagePath());
            stmt.setInt(5, service.getCategoryId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing service.
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE services SET service_name = ?, description = ?, " +
                    "price = ?, image_path = ?, category_id = ? " +
                    "WHERE service_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getImagePath());
            stmt.setInt(5, service.getCategoryId());
            stmt.setInt(6, service.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a service.
     */
    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM services WHERE service_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total number of services.
     */
    public int getTotalServices() {
        String sql = "SELECT COUNT(*) FROM services";
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

    /**
     * Get services by category.
     */
    public List<Service> getServicesByCategory(int categoryId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, COALESCE(AVG(r.rating), 0) as average_rating, " +
                    "COUNT(r.review_id) as review_count " +
                    "FROM services s " +
                    "LEFT JOIN reviews r ON s.service_id = r.service_id " +
                    "WHERE s.category_id = ? " +
                    "GROUP BY s.service_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setName(rs.getString("service_name"));
                    service.setDescription(rs.getString("description"));
                    service.setPrice(rs.getDouble("price"));
                    service.setImagePath(rs.getString("image_path"));
                    service.setCategoryId(rs.getInt("category_id"));
                    service.setAverageRating(rs.getDouble("average_rating"));
                    service.setReviewCount(rs.getInt("review_count"));
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    /**
     * Search services by name or description.
     */
    public List<Service> searchServices(String query) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.category_name, COALESCE(AVG(r.rating), 0) as average_rating, " +
                    "COUNT(r.review_id) as review_count " +
                    "FROM services s " +
                    "INNER JOIN service_categories sc ON s.category_id = sc.category_id " +
                    "LEFT JOIN reviews r ON s.service_id = r.service_id " +
                    "WHERE LOWER(s.service_name) LIKE ? OR LOWER(s.description) LIKE ? " +
                    "GROUP BY s.service_id, sc.category_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + query.toLowerCase() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setId(rs.getInt("service_id"));
                    service.setName(rs.getString("service_name"));
                    service.setDescription(rs.getString("description"));
                    service.setPrice(rs.getDouble("price"));
                    service.setImagePath(rs.getString("image_path"));
                    service.setCategoryId(rs.getInt("category_id"));
                    service.setCategoryName(rs.getString("category_name"));
                    service.setAverageRating(rs.getDouble("average_rating"));
                    service.setReviewCount(rs.getInt("review_count"));
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public List<Service> getTopRatedServices(int limit) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, " +
                    "COALESCE(AVG(r.rating), 0) as avg_rating, " +
                    "COUNT(r.review_id) as review_count " +
                    "FROM services s " +
                    "LEFT JOIN reviews r ON s.service_id = r.service_id " +
                    "GROUP BY s.service_id " +
                    "ORDER BY avg_rating DESC, review_count DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Service service = mapServiceFromResultSet(rs);
                service.setAverageRating(rs.getDouble("avg_rating"));
                service.setReviewCount(rs.getInt("review_count"));
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
    
    public List<Service> getHighDemandServices(int limit) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, " +
                    "COUNT(b.booking_id) as booking_count " +
                    "FROM services s " +
                    "LEFT JOIN bookings b ON s.service_id = b.service_id " +
                    "WHERE b.created_at >= NOW() - INTERVAL '30 days' " +
                    "GROUP BY s.service_id " +
                    "ORDER BY booking_count DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Service service = mapServiceFromResultSet(rs);
                service.setBookingCount(rs.getInt("booking_count"));
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public Service mapServiceFromResultSet(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setId(rs.getInt("service_id"));
        service.setName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getDouble("price"));
        service.setImagePath(rs.getString("image_path"));
        service.setCategoryId(rs.getInt("category_id"));
        return service;
    }
}