package controller;

import dao.UserDAO;
import model.User;
import model.Permission;
import utils.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import dao.PermissionDAO;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            response.sendRedirect(request.getContextPath() + "/" + AuthUtil.getRedirectPathForRole(user.getRoleName()));
            return;
        }
        for (Cookie cookie : request.getCookies() != null ? request.getCookies() : new Cookie[0]) {
            if ("rememberedEmail".equals(cookie.getName())) {
                request.setAttribute("rememberedEmail", cookie.getValue());
            } else if ("rememberedPassword".equals(cookie.getName())) {
                request.setAttribute("rememberedPassword", cookie.getValue());
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean remember = "on".equals(request.getParameter("rememberMe"));
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("errorMessage", "Email và mật khẩu là bắt buộc.");
            forwardWithRememberedData(request, response, email, password);
            return;
        }
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(email, password);
        if (user == null || !user.isStatus()) {
            String error = (user == null) ? "Email hoặc mật khẩu không đúng."
                    : "Tài khoản đã bị khóa. Liên hệ admin.";
            request.setAttribute("errorMessage", error);
            forwardWithRememberedData(request, response, email, password);
            return;
        }
        if (remember) {
            rememberUser(response, email, password);
        } else {
            clearRememberMeCookies(response);
        }
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        PermissionDAO permissionDAO = new PermissionDAO();
        List<Permission> permissionObjs = permissionDAO.getPermissionsByRoleId(user.getRoleId());

        List<String> permissionNames = new ArrayList<>();
        for (Permission p : permissionObjs) {
            permissionNames.add(p.getPermissionName());
        }
 
        session.setAttribute("permissions", permissionNames);       
        session.setAttribute("permissionObjects", permissionObjs);     
        session.setAttribute("justLoggedIn", true);
        session.setAttribute("loginSuccess", "Chào mừng " + user.getFullName() + "!");
        String path = AuthUtil.getRedirectPathForRole(user.getRoleName());
        request.getRequestDispatcher("/" + path).forward(request, response);
    }

    private void rememberUser(HttpServletResponse response, String email, String password) {
        int age = 30 * 24 * 60 * 60;
        Cookie emailCookie = new Cookie("rememberedEmail", email);
        Cookie passwordCookie = new Cookie("rememberedPassword", password);
        emailCookie.setMaxAge(age);
        passwordCookie.setMaxAge(age);
        emailCookie.setPath("/");
        passwordCookie.setPath("/");
        response.addCookie(emailCookie);
        response.addCookie(passwordCookie);
    }

    private void clearRememberMeCookies(HttpServletResponse response) {
        Cookie emailCookie = new Cookie("rememberedEmail", "");
        Cookie passwordCookie = new Cookie("rememberedPassword", "");
        emailCookie.setMaxAge(0);
        passwordCookie.setMaxAge(0);
        emailCookie.setPath("/");
        passwordCookie.setPath("/");
        response.addCookie(emailCookie);
        response.addCookie(passwordCookie);
    }

    private void forwardWithRememberedData(HttpServletRequest request, HttpServletResponse response, String email, String password)
            throws ServletException, IOException {
        request.setAttribute("rememberedEmail", email);
        request.setAttribute("rememberedPassword", password);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
