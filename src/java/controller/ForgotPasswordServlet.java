package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.EmailUtil;
import utils.OTPUtil;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String step = request.getParameter("step");
        if (step == null) {
            step = "email";
        }
        
        switch (step) {
            case "email":
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                break;
            case "otp":
                request.getRequestDispatcher("/verify-otp.jsp").forward(request, response);
                break;
            case "reset":
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "sendOTP":
                handleSendOTP(request, response);
                break;
            case "verifyOTP":
                handleVerifyOTP(request, response);
                break;
            case "resetPassword":
                handleResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }
    
    private void handleSendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email is required");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        try {
            if (!userDAO.isEmailExists(email)) {
                request.setAttribute("errorMessage", "Email not found or account is inactive");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        String otp = OTPUtil.generateOTP();
        OTPUtil.storeOTP(email, otp);
        
        if (EmailUtil.sendOTPEmail(email, otp)) {
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            session.setAttribute("successMessage", "OTP has been sent to your email");
            response.sendRedirect(request.getContextPath() + "/forgot-password?step=otp");
        } else {
            request.setAttribute("errorMessage", "Failed to send OTP. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
    
    private void handleVerifyOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("errorMessage", "OTP is required");
            request.getRequestDispatcher("/verify-otp.jsp").forward(request, response);
            return;
        }
        
        if (OTPUtil.validateOTP(email, otp)) {
            session.setAttribute("otpVerified", true);
            response.sendRedirect(request.getContextPath() + "/forgot-password?step=reset");
        } else {
            request.setAttribute("errorMessage", "Invalid or expired OTP");
            request.getRequestDispatcher("/verify-otp.jsp").forward(request, response);
        }
    }
    
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        if (email == null || otpVerified == null || !otpVerified) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "New password is required");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        if (userDAO.updatePassword(email, newPassword)) {

            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");
            
            session.setAttribute("successMessage", "Password has been reset successfully. Please login with your new password.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}
