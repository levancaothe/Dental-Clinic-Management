package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UpdateEmployeeStatus extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

            UserDAO dao = new UserDAO();
            boolean success = dao.updateUserStatus(userId, newStatus);

            if (success) {
                response.sendRedirect("admin/employee-list?message=success");
            } else {
                response.sendRedirect("admin/employee-list?message=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/employee-list?error=exception");
        }
    }
}
