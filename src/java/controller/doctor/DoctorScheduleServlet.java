package controller.doctor;

import dao.AppointmentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Appointment;
import model.User;

import java.io.IOException;
import java.text.SimpleDateFormat;
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

        String statusParam = request.getParameter("status");
        String fromDateParam = request.getParameter("fromDate");
        String toDateParam = request.getParameter("toDate");
        String pageParam = request.getParameter("page");

        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException ignored) {
            }
        }

        // Mặc định fromDate và toDate là ngày hôm nay nếu không truyền
        Date fromDate = null, toDate = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (fromDateParam != null && !fromDateParam.isEmpty()) {
                fromDate = sdf.parse(fromDateParam);
            }
            if (toDateParam != null && !toDateParam.isEmpty()) {
                toDate = sdf.parse(toDateParam);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            fromDate = cal.getTime(); // hôm nay

            cal.add(Calendar.DAY_OF_MONTH, 7); // cộng thêm 7 ngày
            toDate = cal.getTime(); // 7 ngày sau
        }
        
        int page = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 10;

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> fullList = dao.getDoctorAppointmentsByDateRange(doctor.getUserId(), fromDate, toDate, status);

        int totalRecords = fullList.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        List<Appointment> paginatedList = dao.getAppointmentsByPage(page, pageSize, fullList);

        request.setAttribute("appointments", paginatedList);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("fromDate", fromDateParam);
        request.setAttribute("toDate", toDateParam);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("doctor/doctor-schedule.jsp").forward(request, response);
    }
}
