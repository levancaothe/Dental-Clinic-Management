package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import utils.AccessControl;

@WebServlet(name = "CustomerDashboard", urlPatterns = {"/CustomerDashboard"})
public class CustomerDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AccessControl.hasPermission(session, "Truy cập Customer Dashboard")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
    }
}
