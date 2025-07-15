package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie emailCookie = new Cookie("rememberedEmail", "");
        emailCookie.setMaxAge(0);
        emailCookie.setPath("/");

        Cookie passwordCookie = new Cookie("rememberedPassword", "");
        passwordCookie.setMaxAge(0);
        passwordCookie.setPath("/");

        response.addCookie(emailCookie);
        response.addCookie(passwordCookie);

        response.sendRedirect("home.jsp");
    }
}