package controller.staff;

import dao.AppointmentDAO;
import dao.UserDAO;
import dao.ServiceDAO;
import model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ViewBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String keyword = request.getParameter("keyword");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        if (status == null) {
            status = "";
        }
        if (fromDate == null) {
            fromDate = "";
        }
        if (toDate == null) {
            toDate = "";
        }
        if (sortBy == null) {
            sortBy = "";
        }
        if (keyword == null) {
            keyword = "";
        }

        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        AppointmentDAO dao = new AppointmentDAO();
        UserDAO userDao = new UserDAO();
        ServiceDAO serviceDao = new ServiceDAO();

        List<Appointment> fullList;

        if (!keyword.trim().isEmpty()) {
            fullList = dao.searchAppointmentsByCustomerName(keyword, status, fromDate, toDate, sortBy);
        } else if ("name".equalsIgnoreCase(sortBy)) {
            fullList = dao.sortAppointmentsByCustomerNameAZ(status, fromDate, toDate);
        } else if ("date".equalsIgnoreCase(sortBy)) {
            fullList = dao.sortAppointmentsByDate(status, fromDate, toDate);
        } else {
            fullList = dao.getFilteredAppointments(status, fromDate, toDate);
        }

        int totalAppointments = fullList.size();
        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);
        if (page > totalPages && totalPages != 0) {
            page = totalPages;
        }
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalAppointments);
        
        List<Appointment> paginatedList = (start < end) ? fullList.subList(start, end) : List.of();
    
        request.setAttribute("appointmentList", paginatedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("filterStatus", status);
        request.setAttribute("filterFromDate", fromDate);
        request.setAttribute("filterToDate", toDate);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("keyword", keyword);
        request.setAttribute("userDao", userDao);
        request.setAttribute("serviceDao", serviceDao);

        String success = request.getParameter("success");
        if ("true".equals(success)) {
            request.setAttribute("message", "Đặt lịch thành công!");
        }
        request.getRequestDispatcher("staff/view-booking.jsp").forward(request, response);
    }
}
