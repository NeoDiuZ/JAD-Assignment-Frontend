package controllers;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.AddressDAO;
import models.Service;
import models.Address;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        try {
            // Retrieve the selected serviceId from the request
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));

            // Fetch service details
            ServiceDAO serviceDAO = new ServiceDAO();
            Service service = serviceDAO.getServiceById(serviceId);

            if (service == null) {
                request.setAttribute("error", "Service not found");
                response.sendRedirect("services.jsp");
                return;
            }

            // Pass service details to the booking.jsp page
            request.setAttribute("service", service);

            // Fetch user addresses
            AddressDAO addressDAO = new AddressDAO();
            Integer userId = (Integer) session.getAttribute("user");
            List<Address> addresses = addressDAO.getUserAddresses(userId);
            request.setAttribute("addresses", addresses);

            // Forward to booking.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("booking.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid service ID");
            response.sendRedirect("services.jsp");
        } catch (SQLException e) {
            e.printStackTrace(); // Log the exception
            request.setAttribute("error", "An error occurred while fetching addresses");
            response.sendRedirect("errorPage.jsp"); // Redirect to an error page
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