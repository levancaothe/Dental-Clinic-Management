package controller;

import dao.NotificationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.User;
import java.io.IOException;

public class NotificationUnreadCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            return;
        }

        NotificationDAO dao = new NotificationDAO();
        int count = dao.countUnreadByUserId(user.getUserId());

        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(count));
    }
}
