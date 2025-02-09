package controllers;

import dao.CartDAO;
import dao.BookingDAO;
import dao.AddressDAO;
import models.Cart;
import models.Booking;
import models.Address;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import util.StripeConfig;
import com.stripe.model.PaymentIntent;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private CartDAO cartDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user");
        List<Cart> cartItems = cartDAO.getCartItems(userId);
        
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/viewCart");
            return;
        }

        // Calculate total
        double total = cartItems.stream()
                .mapToDouble(item -> item.getTotalPrice())
                .sum();

        try {
            AddressDAO addressDAO = new AddressDAO();
            List<Address> addresses = addressDAO.getUserAddresses(userId);
            
            if (addresses.isEmpty()) {
                // If no addresses found, redirect to add address page
                session.setAttribute("error", "Please add a delivery address before checkout");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            
            request.setAttribute("addresses", addresses);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("total", total);
            request.setAttribute("stripePublicKey", StripeConfig.STRIPE_PUBLIC_KEY);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to load addresses. Please try again.");
            response.sendRedirect(request.getContextPath() + "/viewCart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String sessionId = request.getParameter("session_id");
        boolean stripeSuccess = "true".equals(request.getParameter("success"));

        // Verify payment if it's card payment
        if ("card".equals(paymentMethod) && !stripeSuccess) {
            session.setAttribute("error", "Payment was not completed");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // If stripe payment was successful or if it's cash payment, proceed with booking
        int userId = (Integer) session.getAttribute("user");
        List<Cart> cartItems = cartDAO.getCartItems(userId);

        try {
            // Create bookings for each cart item
            for (Cart item : cartItems) {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                String specialRequests = request.getParameter("specialRequests");
                
                boolean success = bookingDAO.createBooking(
                    userId,
                    item.getServiceId(),
                    addressId,
                    item.getBookingTime(),
                    item.getTimeLength(),
                    specialRequests
                );
                
                if (!success) {
                    throw new Exception("Failed to create booking");
                }
            }

            // Clear the cart
            cartDAO.clearCart(userId);

            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/profile?success=checkout");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Checkout failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
} 