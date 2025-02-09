package dao;

import util.DatabaseConnection;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {
    public boolean validateAdmin(String email, String password) {
        String sql = "SELECT password FROM admins WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                return PasswordUtil.verifyPassword(password, storedHash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getAdminIdByEmail(String email) {
        String sql = "SELECT admin_id FROM admins WHERE email = ?";
        int adminId = -1;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                adminId = rs.getInt("admin_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return adminId;
    }
}
