package controller.doctor;

import dao.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Appointment;
import model.User;

import java.io.IOException;
import java.util.*;

public class DoctorScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User doctor = (User) session.getAttribute("user");
        if (doctor == null || doctor.getRoleId() != 3) {
            response.sendRedirect("login.jsp");
            return;
        }

        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");
        int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
        int pageSize = 10;

        java.util.Date today = new java.util.Date();
        AppointmentDAO dao = new AppointmentDAO();

        List<Appointment> fullList = dao.getAppointmentsOfDoctorInDayAllStatus(doctor.getUserId(), today, status);
        int totalRecords = fullList.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        List<Appointment> paginated = dao.getAppointmentsByPage(page, pageSize, fullList);

        request.setAttribute("appointments", paginated);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("doctor/doctor-schedule.jsp").forward(request, response);
    }
}
