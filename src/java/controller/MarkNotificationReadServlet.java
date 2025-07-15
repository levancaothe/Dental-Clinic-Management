package controller;

import dao.NotificationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.User;
import java.io.IOException;

public class MarkNotificationReadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            try {
                int notiId = Integer.parseInt(idRaw);
                NotificationDAO dao = new NotificationDAO();
                dao.markAsReadById(notiId, user.getUserId());
            } catch (NumberFormatException e) {
                System.err.println("Invalid notification ID: " + idRaw);
            }
        }
    }
}
