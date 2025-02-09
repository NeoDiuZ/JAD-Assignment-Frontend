package controllers;

import dao.ServiceDAO;
import dao.BookingDAO;
import dao.SalesDAO;
import dao.UserDAO;
import models.Service;
import models.ServiceCategory;
import models.Booking;
import models.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;
import java.util.Map;

@WebServlet(name = "AdminController", urlPatterns = {
    "/dashboard", 
    "/addService", 
    "/editService", 
    "/deleteService", 
    "/updateService",
    "/downloadSalesReport",
    "/viewAllServices",
    "/deleteUser",
    "/viewAllBookings",
    "/updateBookingStatus",
    "/viewAllUsers",
    "/generateBookingReport",
    "/generateServiceCustomerReport"
})
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SalesDAO salesDAO = new SalesDAO();
    private final UserDAO userDAO = new UserDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    // Check if admin is logged in
	    HttpSession session = request.getSession();
	    if (session.getAttribute("adminId") == null) {
	        response.sendRedirect("adminLogin.jsp");
	        return;
	    }

	    String servletPath = request.getServletPath();
	    
	    try {
	        switch (servletPath) {
	            case "/viewAllUsers":
	                viewAllUsers(request, response);
	                break;
                case "/deleteUser":
                    deleteUser(request, response);
                    break;
	            case "/viewAllServices":
	                viewAllServices(request, response);
	                break;
	            case "/viewAllBookings":
	                viewAllBookings(request, response);
	                break;
                case "/addService":
                    showAddServiceForm(request, response);
                    break;
                case "/editService":
                    showEditServiceForm(request, response);
                    break;
                case "/deleteService":
                    deleteService(request, response);
                    break;
                case "/updateService":
                    updateService(request, response);
                    break;
	            case "/generateBookingReport":
	                generateBookingReport(request, response);
	                break;
	            case "/generateServiceCustomerReport":
	                generateServiceCustomerReport(request, response);
	                break;
	            case "/dashboard":
	            default:
	                showDashboard(request, response);
	                break;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("dashboard?error=system");
	    }
	}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/addService":
                    addService(request, response);
                    break;
                case "/updateService":
                    updateService(request, response);
                    break;
                case "/deleteService":
                    deleteService(request, response);
                    break;
                case "/deleteUser":
                    deleteUser(request, response);
                    break;
                case "/updateBookingStatus":
                    updateBookingStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=system");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get dashboard statistics
            int totalServices = serviceDAO.getTotalServices();
            int totalBookings = bookingDAO.getTotalBookings();
            
            // Get lists of data
            List<Service> services = serviceDAO.getServicesWithCategory();
            List<Booking> recentBookings = bookingDAO.getRecentBookings(5);
            List<User> users = userDAO.getAllUsers();
            
            // Get top 5 rated services
            List<Service> topRatedServices = serviceDAO.getTopRatedServices(5);
            request.setAttribute("topRatedServices", topRatedServices);
            
            // Get top 5 high demand services
            List<Service> highDemandServices = serviceDAO.getHighDemandServices(5);
            request.setAttribute("highDemandServices", highDemandServices);
            
            // Load top customers for dashboard
            List<Map<String, Object>> topCustomers = bookingDAO.getTopCustomersByValue(10);
            request.setAttribute("topCustomers", topCustomers);
            
            // Get service customers if a service is selected
            String serviceIdParam = request.getParameter("serviceId");
            if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
                try {
                    int serviceId = Integer.parseInt(serviceIdParam);
                    List<Map<String, Object>> serviceCustomers = bookingDAO.getCustomersByService(serviceId);
                    request.setAttribute("serviceCustomers", serviceCustomers);
                    request.setAttribute("selectedServiceId", serviceId);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid service ID");
                }
            }
            
            // Set attributes
            request.setAttribute("totalServices", totalServices);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("services", services);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("users", users);
            
            // Get any success/error messages from redirect
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
                request.setAttribute("successMessage", getSuccessMessage(success));
            }
            if (error != null) {
                request.setAttribute("errorMessage", getErrorMessage(error));
            }
            
            // Forward to dashboard
            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=system");
        }
    }

    private void viewAllBookings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Booking> allBookings = bookingDAO.getAllBookings();
            request.setAttribute("allBookings", allBookings);
            
            // Get any success/error messages
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
                request.setAttribute("successMessage", getSuccessMessage(success));
            }
            if (error != null) {
                request.setAttribute("errorMessage", getErrorMessage(error));
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewAllBookings.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=system");
        }
    }

    private void viewAllUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<User> allUsers = userDAO.getAllUsers();
            request.setAttribute("allUsers", allUsers);
            
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
                request.setAttribute("successMessage", getSuccessMessage(success));
            }
            if (error != null) {
                request.setAttribute("errorMessage", getErrorMessage(error));
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewAllUsers.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=system");
        }
    }

    private void showAddServiceForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<ServiceCategory> categories = serviceDAO.getAllCategories();
        request.setAttribute("categories", categories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("addService.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditServiceForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            Service service = serviceDAO.getServiceById(serviceId);
            List<ServiceCategory> categories = serviceDAO.getAllCategories();

            if (service != null) {
                request.setAttribute("service", service);
                request.setAttribute("categories", categories);
                RequestDispatcher dispatcher = request.getRequestDispatcher("editService.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("viewAllServices?error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewAllServices?error=invalid");
        }
    }

    private void addService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Service service = new Service();
            service.setName(request.getParameter("serviceName"));
            service.setDescription(request.getParameter("description"));
            service.setPrice(Double.parseDouble(request.getParameter("price")));
            service.setImagePath(request.getParameter("imagePath"));
            service.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));

            if (serviceDAO.addService(service)) {
                response.sendRedirect("viewAllServices?success=add");
            } else {
                response.sendRedirect("addService?error=failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("addService?error=invalid");
        }
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Service service = new Service();
            service.setId(Integer.parseInt(request.getParameter("serviceId")));
            service.setName(request.getParameter("serviceName"));
            service.setDescription(request.getParameter("description"));
            service.setPrice(Double.parseDouble(request.getParameter("price")));
            service.setImagePath(request.getParameter("imagePath"));
            service.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));

            if (serviceDAO.updateService(service)) {
                response.sendRedirect("viewAllServices?success=update");
            } else {
                response.sendRedirect("editService?serviceId=" + service.getId() + "&error=failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewAllServices?error=invalid");
        }
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            if (serviceDAO.deleteService(serviceId)) {
                response.sendRedirect("viewAllServices?success=delete");
            } else {
                response.sendRedirect("viewAllServices?error=deletefailed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewAllServices?error=invalid");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userDAO.deleteUser(userId)) {
                response.sendRedirect(request.getHeader("Referer") + "?success=userdeleted");
            } else {
                response.sendRedirect(request.getHeader("Referer") + "?error=deletefailed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getHeader("Referer") + "?error=invalid");
        }
    }

    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String newStatus = request.getParameter("newStatus");
            int statusId = getStatusId(newStatus);

            if (bookingDAO.updateBookingStatus(bookingId, statusId)) {
                response.sendRedirect("viewAllBookings?success=statusupdated");
            } else {
                response.sendRedirect("viewAllBookings?error=statusupdatefailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewAllBookings?error=system");
        }
    }

    private void viewAllServices(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Service> services = serviceDAO.getServicesWithCategory();
        List<ServiceCategory> categories = serviceDAO.getAllCategories();
        
        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("successMessage", getSuccessMessage(success));
        }
        if (error != null) {
            request.setAttribute("errorMessage", getErrorMessage(error));
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewAllServices.jsp");
        dispatcher.forward(request, response);
    }
    
    private void downloadSalesReport(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    response.setContentType("text/csv");
	    String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
	    String filename = "sales_report_" + timeStamp + ".csv";
	    
	    // Set the response headers
	    response.setHeader("Content-Disposition", "attachment; filename=" + filename);
	    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	    response.setHeader("Pragma", "no-cache");
	    response.setHeader("Expires", "0");
	
	    try (PrintWriter writer = response.getWriter()) {
	        // Write CSV header
	        writer.println("Booking ID,Date,Customer,Service,Duration (hours),Total Amount,Status,Address");
	        
	        // Get all bookings
	        List<Booking> bookings = bookingDAO.getAllBookings();
	        
	        // Write booking data
	        for (Booking booking : bookings) {
	            // Format the date
	            String formattedDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
	                    .format(booking.getBookingTime());
	            
	            // Escape fields that might contain commas
	            String customerName = escapeCSV(booking.getUserName());
	            String serviceName = escapeCSV(booking.getServiceName());
	            String address = escapeCSV(booking.getAddress());
	            
	            // Create CSV line
	            writer.println(String.format("%d,%s,%s,%s,%.1f,%.2f,%s,%s",
	                booking.getId(),
	                formattedDate,
	                customerName,
	                serviceName,
	                booking.getTimeLength(),
	                booking.getTotalCost(),
	                booking.getStatus(),
	                address
	            ));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("dashboard?error=reportfailed");
	    }
	}
	
	private String escapeCSV(String value) {
	    if (value == null) {
	        return "";
	    }
	    // If the value contains comma, quote, or newline, wrap it in quotes and escape existing quotes
	    if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
	        return "\"" + value.replace("\"", "\"\"") + "\"";
	    }
	    return value;
	}

    private int getStatusId(String status) {
        switch (status.toLowerCase()) {
            case "pending":
                return 1;
            case "confirmed":
                return 2;
            case "completed":
                return 3;
            default:
                throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    private String getSuccessMessage(String code) {
        switch (code) {
            case "add":
                return "Service was successfully added.";
            case "update":
                return "Service was successfully updated.";
            case "delete":
                return "Service was successfully deleted.";
            case "userdeleted":
                return "User was successfully deleted.";
            case "statusupdated":
                return "Booking status was successfully updated.";
            default:
                return "Operation completed successfully.";
        }
    }

    private String getErrorMessage(String code) {
        switch (code) {
            case "invalid":
                return "Invalid input data provided.";
            case "notfound":
                return "Item was not found.";
            case "failed":
                return "Operation failed. Please try again.";
            case "deletefailed":
                return "Could not delete. Item may be referenced by other records.";
            case "statusupdatefailed":
                return "Could not update booking status. Please try again.";
            case "system":
                return "A system error occurred. Please try again later.";
            default:
                return "An error occurred.";
        }
    }

    private void generateBookingReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(request.getParameter("startDate"));
            Date endDate = dateFormat.parse(request.getParameter("endDate"));
            
            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> bookings = bookingDAO.getBookingsByDateRange(startDate, endDate);
            
            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", 
                "attachment; filename=bookings_report_" + dateFormat.format(startDate) + "_to_" + 
                dateFormat.format(endDate) + ".csv");
            
            // Write CSV content
            PrintWriter writer = response.getWriter();
            writer.println("Booking ID,Date,Customer,Service,Duration,Total Cost,Status,Address");
            
            for (Booking booking : bookings) {
                writer.println(String.format("%d,%s,%s,%s,%.1f,%.2f,%s,%s",
                    booking.getId(),
                    dateFormat.format(booking.getBookingTime()),
                    booking.getUserName(),
                    booking.getServiceName(),
                    booking.getTimeLength(),
                    booking.getTotalCost(),
                    booking.getStatus(),
                    booking.getAddress()
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=reportGenerationFailed");
        }
    }
    
    private void generateServiceCustomerReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            BookingDAO bookingDAO = new BookingDAO();
            List<Map<String, Object>> customers = bookingDAO.getCustomersByService(serviceId);
            
            request.setAttribute("serviceCustomers", customers);
            request.setAttribute("selectedServiceId", serviceId);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/dashboard.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=reportGenerationFailed");
        }
    }
}