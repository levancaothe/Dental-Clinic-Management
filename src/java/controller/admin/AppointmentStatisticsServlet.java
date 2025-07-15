package controller.admin;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import utils.AccessControl;

public class AppointmentStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!AccessControl.hasPermission(session, "Xem thống kê đặt lịch")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        int total = dao.getTotalAppointments();
        Map<String, Integer> stats = dao.getAppointmentStatistics();

        request.setAttribute("total", total);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("admin/appointment-statistics.jsp").forward(request, response);
    }
}
