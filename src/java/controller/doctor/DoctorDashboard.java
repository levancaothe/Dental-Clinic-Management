package controller.doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import utils.AccessControl;

@WebServlet(name = "DoctorDashboard", urlPatterns = {"/DoctorDashboard"})
public class DoctorDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AccessControl.hasPermission(session, "Truy cập Doctor Dashboard")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.getRequestDispatcher("/doctor/dashboard.jsp").forward(request, response);
    }
}
