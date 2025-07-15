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

public class EditShiftServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ShiftDAO shiftDao = new ShiftDAO();
            Shift shift = shiftDao.getShiftById(id);

            UserDAO userDao = new UserDAO();
            List<User> doctors = userDao.getUsersByRole(3);

            request.setAttribute("shift", shift);
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("editShift.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi lấy dữ liệu ca làm việc: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int shiftId = Integer.parseInt(request.getParameter("shiftId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            Timestamp start = Timestamp.valueOf(request.getParameter("startDateTime").replace("T", " ") + ":00");
            Timestamp end = Timestamp.valueOf(request.getParameter("endDateTime").replace("T", " ") + ":00");
            String desc = request.getParameter("description");

            Shift s = new Shift(shiftId, doctorId, start, end, desc);
            new ShiftDAO().updateShift(s);

            response.sendRedirect("ViewShiftsServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi cập nhật ca làm việc: " + e.getMessage());
        }
    }
}
