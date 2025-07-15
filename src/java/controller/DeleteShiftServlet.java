package controller;

import dao.ShiftDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DeleteShiftServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int shiftId = Integer.parseInt(request.getParameter("id"));
            ShiftDAO dao = new ShiftDAO();
            dao.deleteShift(shiftId);

            response.sendRedirect("ViewShiftsServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi xoá lịch: " + e.getMessage());
        }
    }
}
