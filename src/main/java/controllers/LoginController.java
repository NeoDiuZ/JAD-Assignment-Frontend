package controllers;

import dao.*;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {
    "/login",
    "/admin",
    "/admin/login",
    "/logout"
})
public class LoginController extends HttpServlet {
    private UserDAO userDAO;
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();
        HttpSession session = request.getSession(false);

        switch (pathInfo) {
            case "/admin":
            case "/admin/login":
                // Check if admin is already logged in
                if (session != null && session.getAttribute("adminId") != null) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
                break;
                
            case "/login":
                // Check if user is already logged in
                if (session != null && session.getAttribute("user") != null) {
                    response.sendRedirect("index");
                    return;
                }
                request.getRequestDispatcher("/userLogin.jsp").forward(request, response);
                break;
                
            case "/logout":
                if (session != null) {
                    boolean isAdmin = session.getAttribute("adminId") != null;
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + 
                        (isAdmin ? "/admin/login" : "/login"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/login");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String loginType = request.getParameter("loginType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        HttpSession session = request.getSession();
        
        if ("admin".equals(loginType)) {
            handleAdminLogin(email, password, session, request, response);
        } else if ("user".equals(loginType)) {
            handleUserLogin(email, password, session, request, response);
        } else {
            handleLoginError(session, response, "Invalid login type");
        }
    }

	private void handleUserLogin(String email, String password, HttpSession session, 
                               HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("Attempting user login for email: " + email);
        
        try {
            // Validate the credentials
            boolean isValid = userDAO.validateUser(email, password);
            System.out.println("Credential validation result: " + isValid);
            
            if (isValid) {
                int userId = userDAO.getUserIdByEmail(email);
                System.out.println("User login successful - ID: " + userId);
                
                if (userId != -1) {
                    // Store user information in session
                    session.setAttribute("user", userId);
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userType", "user");
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
                    
                    // Clear any existing error messages
                    session.removeAttribute("error");
                    
                    System.out.println("Session created successfully for user ID: " + userId);
                    
                    // Redirect to profile page
                    response.sendRedirect("index.jsp");
                    return;
                } else {
                    System.out.println("User ID not found for email: " + email);
                    handleLoginError(session, response, "User account not found.");
                    return;
                }
            } else {
                System.out.println("Invalid credentials for user: " + email);
                handleLoginError(session, response, "Invalid email or password.");
                return;
            }
        } catch (Exception e) {
            System.out.println("Error in user login: " + e.getMessage());
            e.printStackTrace();
            handleLoginError(session, response, "Error during login. Please try again.");
        }
    }

    private void handleLoginError(HttpSession session, HttpServletResponse response, String errorMessage) 
            throws IOException {
        session.setAttribute("error", errorMessage);
        response.sendRedirect("userLogin.jsp");
    }

    private void handleAdminLogin(String email, String password, HttpSession session, 
                                HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("Attempting admin login for email: " + email);
        
        try {
            if (adminDAO.validateAdmin(email, password)) {
                int adminId = adminDAO.getAdminIdByEmail(email);
                System.out.println("Admin login successful - ID: " + adminId);
                
                if (adminId != -1) {
                    // Store admin information in session
                    session.setAttribute("adminId", adminId);
                    session.setAttribute("adminEmail", email);
                    session.setAttribute("userType", "admin");
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
                    
                    // Clear any existing error messages
                    session.removeAttribute("error");
                    
                    System.out.println("Admin session created - Redirecting to dashboard");
                    response.sendRedirect("dashboard");
                    return;
                } else {
                    System.out.println("Admin ID not found for email: " + email);
                    session.setAttribute("error", "Admin account not found.");
                }
            } else {
                System.out.println("Invalid credentials for admin: " + email);
                session.setAttribute("error", "Invalid email or password for Admin.");
            }
            
            // If we reach here, login failed
            response.sendRedirect("adminLogin.jsp");
            
        } catch (Exception e) {
            System.out.println("Error in admin login: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error during admin login. Please try again.");
            response.sendRedirect("adminLogin.jsp");
        }
    }

    @Override
    public void destroy() {
        // Clean up resources if needed
        userDAO = null;
        adminDAO = null;
    }
}