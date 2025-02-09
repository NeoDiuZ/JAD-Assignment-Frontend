package controllers;

import dao.UserDAO;
import models.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        System.out.println("Debug - Register - Raw password length: " + password.length());
        System.out.println("Debug - Register - Raw password value: " + password);

        try {
            // Check if user already exists
            if (userDAO.isEmailRegistered(email)) {
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);

            if (userDAO.registerUser(user)) {
                // Successful registration
                response.sendRedirect(request.getContextPath() + "/userLogin.jsp?success=registered");
            } else {
                request.setAttribute("error", "Registration failed");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
