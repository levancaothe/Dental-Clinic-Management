package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DashboardOverviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO dao = new UserDAO();
        request.setAttribute("totalUsers", dao.countAllUsers());
        request.setAttribute("staffCount", dao.countUsersByRole(2));
        request.setAttribute("doctorCount", dao.countUsersByRole(3));
        request.setAttribute("customerCount", dao.countUsersByRole(1));

        request.getRequestDispatcher("admin/dashboard-overview.jsp").forward(request, response);
    }
}
