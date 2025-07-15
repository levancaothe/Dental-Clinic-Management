package controller;

import dao.ShiftDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Shift;

public class ViewShiftsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ShiftDAO dao = new ShiftDAO();
        List<Shift> shifts = dao.getAllShiftsWithDoctorName();

        request.setAttribute("shifts", shifts);
        request.getRequestDispatcher("viewShifts.jsp").forward(request, response);
    }
}
