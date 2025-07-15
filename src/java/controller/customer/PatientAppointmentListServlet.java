package controller.customer;

import dao.AppointmentDAO;
import model.Appointment;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class PatientAppointmentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getUserId();
        AppointmentDAO dao = new AppointmentDAO();

        String status = request.getParameter("status");
        String sortOrder = request.getParameter("sortOrder");
        String fromDateRaw = request.getParameter("fromDate");
        String toDateRaw = request.getParameter("toDate");

        Date fromDate = null, toDate = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (fromDateRaw != null && !fromDateRaw.isEmpty()) {
                fromDate = sdf.parse(fromDateRaw);
            }
            if (toDateRaw != null && !toDateRaw.isEmpty()) {
                toDate = sdf.parse(toDateRaw);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Appointment> allAppointments = dao.getFilteredAppointmentsByCustomer(userId, status, fromDate, toDate, sortOrder);

        int pageSize = 10;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalAppointments = allAppointments.size();
        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalAppointments);
        List<Appointment> paginatedList = allAppointments.subList(start, end);

        request.setAttribute("appointmentList", paginatedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("statusFilter", status);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("fromDate", fromDateRaw);
        request.setAttribute("toDate", toDateRaw);

        request.getRequestDispatcher("customer/patient-appointment-list.jsp").forward(request, response);
    }
}
