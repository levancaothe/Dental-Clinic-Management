package controller.staff;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import utils.AccessControl;


@WebServlet(name = "StaffDashboard", urlPatterns = {"/StaffDashboard"})
public class StaffDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AccessControl.hasPermission(session, "Truy cập Staff Dashboard")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user != null && user.getRoleId() == 2) {
            NotificationDAO dao = new NotificationDAO();
            int unread = dao.countUnreadByUserId(user.getUserId());
            session.setAttribute("unreadCount", unread);
        }

        request.getRequestDispatcher("/staff/dashboard.jsp").forward(request, response);
    }
}
