package controllers;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.AddressDAO;
import models.Service;
import models.Address;
import models.Booking;
import util.StripeConfig;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int ITEMS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        try {
            int currentPage = 1;
            String status = request.getParameter("status");
            if (status == null) status = "pending"; // Default status
            
            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null) {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }

            BookingDAO bookingDAO = new BookingDAO();
            Integer userId = (Integer) session.getAttribute("user");
            
            // Get total count of bookings for the selected status
            int totalBookings = bookingDAO.getTotalBookingsCountByStatus(userId, status);
            int totalPages = (int) Math.ceil((double) totalBookings / ITEMS_PER_PAGE);
            
            // Get paginated bookings for the selected status
            List<Booking> bookings = bookingDAO.getBookingsPaginatedByStatus(userId, status, currentPage, ITEMS_PER_PAGE);
            
            // Set attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("bookings", bookings);
            request.setAttribute("currentStatus", status);

            // Get counts for each status
            request.setAttribute("pendingCount", bookingDAO.getBookingsCountByStatus(userId, "Pending"));
            request.setAttribute("confirmedCount", bookingDAO.getBookingsCountByStatus(userId, "Confirmed"));
            request.setAttribute("completedCount", bookingDAO.getBookingsCountByStatus(userId, "Completed"));

            RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect("userLogin.jsp");
	        return;
	    }
	
	    try {
	        // Get userId from session
	        Integer userId = (Integer) session.getAttribute("user");
	        
	        // Retrieve form data
	        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
	        String bookingDate = request.getParameter("bookingDate");
	        String bookingTime = request.getParameter("bookingTime");
	        float timeLength = Float.parseFloat(request.getParameter("timeLength"));
	        String specialRequests = request.getParameter("specialRequests");
	        int addressId = Integer.parseInt(request.getParameter("addressId"));
	
	        // Validate inputs
	        if (bookingDate == null || bookingDate.trim().isEmpty() ||
	            bookingTime == null || bookingTime.trim().isEmpty()) {
	            session.setAttribute("error", "Please select both date and time");
	            response.sendRedirect(request.getHeader("Referer"));
	            return;
	        }
	
	        // Combine bookingDate and bookingTime into a Timestamp
	        String combinedDateTime = bookingDate + " " + bookingTime + ":00";
	        java.sql.Timestamp bookingTimestamp = java.sql.Timestamp.valueOf(combinedDateTime);
	
	        // Save booking data
	        BookingDAO bookingDAO = new BookingDAO();
	        boolean isBooked = bookingDAO.createBooking(userId, serviceId, addressId, bookingTimestamp, timeLength, specialRequests);
	
	        // Set appropriate message and redirect
	        if (isBooked) {
	            session.setAttribute("message", "Booking created successfully!");
	            response.sendRedirect("profile");  // Redirect to profile page to see the booking
	        } else {
	            session.setAttribute("error", "Failed to create booking. Please try again.");
	            response.sendRedirect(request.getHeader("Referer"));
	        }
	
	    } catch (NumberFormatException e) {
	        session.setAttribute("error", "Invalid input data");
	        response.sendRedirect(request.getHeader("Referer"));
	    } catch (IllegalArgumentException e) {
	        session.setAttribute("error", "Invalid date or time format");
	        response.sendRedirect(request.getHeader("Referer"));
	    } catch (Exception e) {
	        e.printStackTrace();
	        session.setAttribute("error", "An error occurred while processing your booking");
	        response.sendRedirect(request.getHeader("Referer"));
	    }
	}
}