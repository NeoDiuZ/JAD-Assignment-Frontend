package controllers;

import dao.ServiceDAO;
import models.Service;
import models.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/services",
    "/service-details",
    "/service/*"
})
public class ServiceController extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getServletPath();

        if ("/service-details".equals(pathInfo)) {
            // Handle service details page
            String serviceIdStr = request.getParameter("serviceId");
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                Service service = serviceDAO.getServiceById(serviceId);
                if (service != null) {
                    // Get reviews for the service
                    List<Review> reviews = serviceDAO.getServiceReviews(serviceId);

                    request.setAttribute("service", service);
                    request.setAttribute("reviews", reviews);
                    request.getRequestDispatcher("service-details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("services");
                return;
            }
        }

        // Original services listing code
        List<Service> services = serviceDAO.getServicesWithCategory();
        request.setAttribute("services", services);
        request.setAttribute("categories", serviceDAO.getAllCategories());
        request.getRequestDispatcher("services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Log the action parameter for debugging
        String action = request.getParameter("action");
        System.out.println("Action: " + action);

        // Handle rating submission
        if ("submitRating".equals(action)) {
            HttpSession session = request.getSession();
            // Changed from userId to user to match LoginController
            Integer userId = (Integer) session.getAttribute("user");
            
            // Add debug logging
            System.out.println("User ID from session: " + userId);

            if (userId == null) {
                System.out.println("No user ID found in session - redirecting to login");
                // Store the return URL in session so we can redirect back after login
                session.setAttribute("returnUrl", "service-details?serviceId=" + request.getParameter("serviceId"));
                response.sendRedirect("login");
                return;
            }

            try {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                boolean success = serviceDAO.addReview(userId, serviceId, rating, comment);

                if (success) {
                    response.sendRedirect("service-details?serviceId=" + serviceId + "&rated=true");
                } else {
                    response.sendRedirect("service-details?serviceId=" + serviceId + "&error=true");
                }
            } catch (NumberFormatException e) {
                System.out.println("Error parsing service ID or rating: " + e.getMessage());
                response.sendRedirect("service-details?serviceId=" + request.getParameter("serviceId") + "&error=true");
            }
        } else {
            // Log unexpected action
            System.out.println("Unexpected action: " + action);
            response.sendRedirect("service-details");
        }
    }
    
    private void loadServices(HttpServletRequest request) throws ServletException, IOException {
	    List<Service> services = serviceDAO.getServicesWithCategory(); // Fetch services
	    request.setAttribute("services", services); // Set services in request
	}
}