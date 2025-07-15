package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

public class AuthUtil {

    public static boolean isAuthorized(HttpServletRequest request, String requiredRole) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return false;
        }

        return user.getRole().getRoleName().equals(requiredRole);
    }

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        return (User) session.getAttribute("user");
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public static String getRedirectPathForRole(String roleName) {
        if (roleName == null) {
            return "login";
        }

        switch (roleName.trim()) {
            case "Quản trị viên":
                return "admin/dashboard.jsp";
            case "Bác sĩ":
                return "doctor/dashboard.jsp";
            case "Nhân viên":
                return "staff/dashboard.jsp";
            case "Khách hàng":
                return "customer/dashboard.jsp";
            default:
                return "login";
        }
    }

    public static String getDashboardPath(String roleName) {
        switch (roleName.toLowerCase()) {
            case "admin":
                return "admin/dashboard";
            case "staff":
            case "nhân viên":
                return "staff/dashboard";
            case "doctor":
            case "bác sĩ":
                return "doctor/dashboard";
            case "customer":
            case "khách hàng":
                return "customer/dashboard";
            default:
                return "login.jsp";
        }
    }
}

