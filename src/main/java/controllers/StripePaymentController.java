package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.StripeConfig;
import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.stripe.exception.StripeException;
import java.io.BufferedReader;

@WebServlet("/stripe-checkout")  // Changed URL pattern
public class StripePaymentController extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        Stripe.apiKey = StripeConfig.STRIPE_SECRET_KEY;
        System.out.println("StripePaymentController initialized with API key"); // Debug log
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Received request to /stripe-checkout"); // Debug log
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            JsonObject error = new JsonObject();
            error.addProperty("error", "User not authenticated");
            out.println(error.toString());
            return;
        }

        try {
            // Read and parse the JSON request body
            StringBuilder buffer = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    buffer.append(line);
                }
            }
            
            System.out.println("Request body: " + buffer.toString()); // Debug log

            JsonObject jsonRequest = JsonParser.parseString(buffer.toString()).getAsJsonObject();
            double amount = jsonRequest.get("amount").getAsDouble();
            
            // Store form data in session
            if (jsonRequest.has("addressId")) {
                session.setAttribute("checkout_address_id", jsonRequest.get("addressId").getAsString());
            }
            if (jsonRequest.has("specialRequests")) {
                session.setAttribute("checkout_special_requests", jsonRequest.get("specialRequests").getAsString());
            }

            // Create line items for Stripe Checkout
            List<Object> lineItems = new ArrayList<>();
            Map<String, Object> lineItem = new HashMap<>();
            Map<String, Object> priceData = new HashMap<>();
            
            priceData.put("currency", "sgd");
            priceData.put("unit_amount", (long)(amount * 100));
            priceData.put("product_data", new HashMap<String, Object>() {{
                put("name", "Cleaning Service Booking");
                put("description", "Booking for cleaning service");
            }});

            lineItem.put("price_data", priceData);
            lineItem.put("quantity", 1);
            lineItems.add(lineItem);

            // Build success and cancel URLs
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            baseUrl += request.getContextPath();

            // Create Checkout Session
            Map<String, Object> params = new HashMap<>();
            params.put("payment_method_types", List.of("card"));
            params.put("line_items", lineItems);
            params.put("mode", "payment");
            params.put("success_url", baseUrl + "/checkout?success=true&session_id={CHECKOUT_SESSION_ID}");
            params.put("cancel_url", baseUrl + "/checkout?success=false");

            System.out.println("Creating Stripe session with params: " + params); // Debug log

            // Create the session with Stripe
            Session checkoutSession = Session.create(params);

            // Return the session ID
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("sessionId", checkoutSession.getId());
            System.out.println("Session created: " + checkoutSession.getId()); // Debug log
            out.println(jsonResponse.toString());

        } catch (StripeException e) {
            System.err.println("Stripe error: " + e.getMessage()); // Debug log
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Stripe error: " + e.getMessage());
            out.println(error.toString());
        } catch (Exception e) {
            System.err.println("Server error: " + e.getMessage()); // Debug log
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Server error: " + e.getMessage());
            out.println(error.toString());
        }
    }
}