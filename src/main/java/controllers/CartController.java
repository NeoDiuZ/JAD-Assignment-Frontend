package controllers;

import dao.CartDAO;
import models.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(urlPatterns = {
    "/cart",
    "/addToCart",
    "/removeFromCart",
    "/viewCart",
    "/updateCart"
})
public class CartController extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getServletPath();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        switch (action) {
            case "/viewCart":
            case "/cart":
                viewCart(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/viewCart");
                break;
        }
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("user");
        List<Cart> cartItems = cartDAO.getCartItems(userId);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getServletPath();
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/userLogin.jsp");
            return;
        }

        try {
            switch (action) {
                case "/addToCart":
                    addToCart(request, response);
                    break;
                case "/removeFromCart":
                    removeFromCart(request, response);
                    break;
                case "/updateCart":
                    updateCart(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/viewCart");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/viewCart");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("user");
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        String bookingTime = request.getParameter("bookingTime");
        float timeLength = Float.parseFloat(request.getParameter("timeLength"));

        Cart cartItem = new Cart();
        cartItem.setUserId(userId);
        cartItem.setServiceId(serviceId);
        cartItem.setBookingTime(Timestamp.valueOf(bookingTime));
        cartItem.setTimeLength(timeLength);

        if (cartDAO.addToCart(cartItem)) {
            response.sendRedirect("viewCart?success=added");
        } else {
            response.sendRedirect("viewCart?error=failed");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int userId = (Integer) request.getSession().getAttribute("user");

        if (cartDAO.removeFromCart(cartId, userId)) {
            response.sendRedirect("viewCart?success=removed");
        } else {
            response.sendRedirect("viewCart?error=removefailed");
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("user");
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        String bookingTime = request.getParameter("bookingTime");
        float timeLength = Float.parseFloat(request.getParameter("timeLength"));

        Cart cart = new Cart();
        cart.setCartId(cartId);
        cart.setUserId(userId);
        cart.setBookingTime(Timestamp.valueOf(bookingTime));
        cart.setTimeLength(timeLength);

        if (cartDAO.updateCart(cart)) {
            response.sendRedirect(request.getContextPath() + "/viewCart?success=updated");
        } else {
            request.getSession().setAttribute("error", "Failed to update cart item");
            response.sendRedirect(request.getContextPath() + "/viewCart");
        }
    }
} 