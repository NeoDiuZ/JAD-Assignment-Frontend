package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import util.DatabaseConnection;
import java.util.ArrayList;
import java.util.List;

public class SalesDAO {
    
    public double getTotalSales() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0.0) as total_sales FROM (" +
                    "    SELECT (s.price * b.time_length) as total_amount " +
                    "    FROM bookings b " +
                    "    JOIN services s ON b.service_id = s.service_id " +
                    "    JOIN booking_statuses bs ON b.status_id = bs.status_id" +
                    ") AS booking_totals";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total_sales");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error calculating total sales: " + e.getMessage());
        }
        return 0.0;
    }

    // Remove throws SQLException from the method signature
    public List<String> generateSalesReportData() {
	    List<String> reportLines = new ArrayList<>();
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	    String sql = "SELECT b.booking_id, b.booking_time, u.name as user_name, " +
	                 "s.service_name, s.price, b.time_length, (s.price * b.time_length) as total_amount, " +
	                 "bs.status_name " +
	                 "FROM bookings b " +
	                 "INNER JOIN services s ON b.service_id = s.service_id " +
	                 "INNER JOIN users u ON b.user_id = u.user_id " +
	                 "INNER JOIN booking_statuses bs ON b.status_id = bs.status_id " +
	                 "ORDER BY b.booking_time DESC";
	
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {
	
	        // Add CSV header
	        reportLines.add("Booking ID,Date,Customer,Service,Price,Duration,Total Amount,Status");
	
	        // Add data rows
	        while (rs.next()) {
	            StringBuilder line = new StringBuilder();
	            line.append(rs.getInt("booking_id")).append(",");
	            line.append(dateFormat.format(rs.getTimestamp("booking_time"))).append(",");
	            line.append(escapeCsvField(rs.getString("user_name"))).append(",");
	            line.append(escapeCsvField(rs.getString("service_name"))).append(",");
	            line.append(rs.getDouble("price")).append(",");
	            line.append(rs.getDouble("time_length")).append(",");
	            line.append(rs.getDouble("total_amount")).append(",");
	            line.append(escapeCsvField(rs.getString("status_name")));
	
	            reportLines.add(line.toString());
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        reportLines.add("Error generating sales report");
	        reportLines.add("Error message: " + e.getMessage());
	    }
	    return reportLines;
	}

    private String escapeCsvField(String field) {
        if (field == null) {
            return "";
        }
        if (field.contains(",") || field.contains("\"") || field.contains("\n")) {
            return "\"" + field.replace("\"", "\"\"") + "\"";
        }
        return field;
    }

    public double getMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(s.price * b.time_length), 0) as monthly_revenue " +
                    "FROM bookings b " +
                    "INNER JOIN services s ON b.service_id = s.service_id " +
                    "WHERE b.status_id = 3 " +
                    "AND b.booking_time >= DATE_TRUNC('month', CURRENT_DATE)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("monthly_revenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}