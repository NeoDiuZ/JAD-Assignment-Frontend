package controllers;

import dao.UserDAO;
import dao.AddressDAO;
import models.User;
import models.Address;
import models.Booking;
import dao.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.sql.SQLException;

@WebServlet({"/profile", "/profile/*"})
public class UserController extends HttpServlet {
    private UserDAO userDAO;
    private AddressDAO addressDAO;
    private BookingDAO bookingDAO;


    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        addressDAO = new AddressDAO();
        bookingDAO = new BookingDAO(); // Add this line

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("\n--- Profile Page Request Started ---");

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("userLogin.jsp");
                return;
            }

            // Get userId from session - matches how LoginController stores it
            Integer userId = (Integer) session.getAttribute("user");
            if (userId == null) {
                response.sendRedirect("userLogin.jsp");
                return;
            }

            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                handleProfileView(request, response, userId);
            } else if (pathInfo.equals("/edit")) {
                handleEditProfileView(request, response, userId);
            }

        } catch (Exception e) {
            System.out.println("Unexpected error in UserController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("\n--- Profile Update Request Started ---");

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("userLogin.jsp");
                return;
            }

            // Get userId from session - matches how LoginController stores it
            Integer userId = (Integer) session.getAttribute("user");
            if (userId == null) {
                response.sendRedirect("userLogin.jsp");
                return;
            }

            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/update")) {
                handleProfileUpdate(request, response, userId);
            }

        } catch (Exception e) {
            System.out.println("Error in profile update: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile");
            request.getRequestDispatcher("/update-profile.jsp").forward(request, response);
        }
    }

	// In your UserController's handleProfileView method:
	private void handleProfileView(HttpServletRequest request, HttpServletResponse response, int userId)
	        throws ServletException, IOException, SQLException {
	    User userData = userDAO.getUserById(userId);
	    
	    if (userData != null) {
	        // Fetch addresses
	        List<Address> addresses = addressDAO.getUserAddresses(userId);
	        
	        // Fetch bookings
	        List<Booking> bookings = bookingDAO.getUserBookings(userId);
	        
	        // Set attributes
	        request.setAttribute("userData", userData);
	        request.setAttribute("addresses", addresses);
	        request.setAttribute("bookings", bookings);
	        
	        request.getRequestDispatcher("/profile.jsp").forward(request, response);
	    } else {
	        request.setAttribute("error", "User data not found");
	        response.sendRedirect("userLogin.jsp");
	    }
	}

    private void handleEditProfileView(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException, SQLException {
        // Get full user data from database using userId
        User userData = userDAO.getUserById(userId);
        
        if (userData != null) {
            // Get user's addresses
            List<Address> userAddresses = addressDAO.getUserAddresses(userId);
            
            // Set both user data and addresses as separate attributes
            request.setAttribute("userData", userData);
            request.setAttribute("addresses", userAddresses);
            
            // Forward to edit profile page
            request.getRequestDispatcher("/update-profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "User data not found");
            response.sendRedirect("userLogin.jsp");
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException, SQLException {
        // Get current user data
        User userData = userDAO.getUserById(userId);
        
        if (userData != null) {
            // Update the user data
            userData.setName(request.getParameter("name"));
            userData.setEmail(request.getParameter("email"));
            userData.setPhone(request.getParameter("phone"));

            // Save updates to database
            boolean updateSuccess = userDAO.updateUser(userData);

            if (updateSuccess) {
                request.getSession().setAttribute("message", "Profile updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update profile");
            }

            // Redirect back to profile page
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("error", "User data not found");
            response.sendRedirect("userLogin.jsp");
        }
    }
}