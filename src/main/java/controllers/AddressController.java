package controllers;

import dao.AddressDAO;

import models.Address;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/address/*")
public class AddressController extends HttpServlet {
    private AddressDAO addressDAO;

    @Override
    public void init() throws ServletException {
        addressDAO = new AddressDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        // Get userId from session
        Integer userId = (Integer) session.getAttribute("user");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        String action = request.getPathInfo();
        try {
            switch (action) {
                case "/add":
                    handleAddAddress(request, response, userId);
                    break;
                case "/update":
                    handleUpdateAddress(request, response, userId);
                    break;
                case "/delete":
                    handleDeleteAddress(request, response, userId);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/profile");
            }
        } catch (SQLException e) {
            System.out.println("Error in AddressController: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Database error occurred");
            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (Exception e) {
            System.out.println("Unexpected error in AddressController: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "An unexpected error occurred");
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleAddAddress(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        Address address = new Address();
        address.setUserId(userId);
        address.setAddress(request.getParameter("address"));
        address.setPostalCode(request.getParameter("postalCode"));

        int newAddressId = addressDAO.addAddress(address);
        if (newAddressId > 0) {
            request.getSession().setAttribute("message", "Address added successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to add address");
        }
        response.sendRedirect(request.getContextPath() + "/profile/edit");
    }

    private void handleUpdateAddress(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        Address address = new Address();
        address.setAddressId(Integer.parseInt(request.getParameter("addressId")));
        address.setUserId(userId);
        address.setAddress(request.getParameter("address"));
        address.setPostalCode(request.getParameter("postalCode"));

        if (addressDAO.updateAddress(address)) {
            request.getSession().setAttribute("message", "Address updated successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to update address");
        }
        response.sendRedirect(request.getContextPath() + "/profile/edit");
    }

    private void handleDeleteAddress(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        int addressId = Integer.parseInt(request.getParameter("addressId"));

        if (addressDAO.deleteAddress(addressId, userId)) {
            request.getSession().setAttribute("message", "Address deleted successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to delete address");
        }
        response.sendRedirect(request.getContextPath() + "/profile/edit");
    }
}