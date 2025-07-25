package controller.admin;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
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

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        AppointmentDAO dao = new AppointmentDAO();
        int total;
        Map<String, Integer> stats;

        if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
            total = dao.getTotalAppointments(fromDate, toDate);
            stats = dao.getAppointmentStatistics(fromDate, toDate);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
        } else {
            total = dao.getTotalAppointments();
            stats = dao.getAppointmentStatistics();
        }

        request.setAttribute("total", total);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("admin/appointment-statistics.jsp").forward(request, response);
    }
}