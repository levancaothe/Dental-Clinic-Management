package controller;

import dao.NotificationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Notification;
import model.User;

import java.io.IOException;
import java.util.List;

public class NotificationDropdownServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null || user.getRoleId() != 2) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        NotificationDAO dao = new NotificationDAO();
        List<Notification> notifications = dao.getAllByUserId(user.getUserId());

        StringBuilder html = new StringBuilder();

        for (Notification n : notifications) {
            html.append("<li class='dropdown-item noti-item ")
                    .append(n.isRead() ? "read" : "unread")
                    .append("' data-id='").append(n.getNotificationId()).append("'>")
                    .append("<strong>")
                    .append(n.getTitle() == null || n.getTitle().isEmpty() ? "Thông báo" : n.getTitle())
                    .append("</strong><br>")
                    .append("<small>").append(n.getMessage()).append("</small>")
                    .append("</li>");
        }

        if (notifications.isEmpty()) {
            html.append("<li class='dropdown-item text-muted'>Không có thông báo nào</li>");
        }

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(html.toString());
    }
}
