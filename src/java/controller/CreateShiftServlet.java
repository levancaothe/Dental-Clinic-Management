package controller;

import dao.ShiftDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Shift;
import model.User;

public class CreateShiftServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDao = new UserDAO();
        List<User> doctors = userDao.getUsersByRole(3); // 3 = bác sĩ
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("createShift.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            Timestamp start = Timestamp.valueOf(request.getParameter("startDateTime").replace("T", " ") + ":00");
            Timestamp end = Timestamp.valueOf(request.getParameter("endDateTime").replace("T", " ") + ":00");
            String description = request.getParameter("description");

            Shift shift = new Shift(0, doctorId, start, end, description);
            new ShiftDAO().insertShift(shift);

            response.sendRedirect("ViewShiftsServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi thêm lịch: " + e.getMessage());
        }
    }
}
