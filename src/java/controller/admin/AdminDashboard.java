package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import utils.AccessControl;

@WebServlet(name = "AdminDashboard", urlPatterns = {"/AdminDashboard"})
public class AdminDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AccessControl.hasPermission(session, "Truy cập Dashboard")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        UserDAO dao = new UserDAO();
        request.setAttribute("totalUsers", dao.countAllUsers());
        request.setAttribute("staffCount", dao.countUsersByRole(2));
        request.setAttribute("customerCount", dao.countUsersByRole(1));
        request.setAttribute("doctorCount", dao.countUsersByRole(3));

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
