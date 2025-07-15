package controller.admin;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import utils.AccessControl;

public class ServiceStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!AccessControl.hasPermission(session, "Xem thống kê dịch vụ")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        ServiceDAO dao = new ServiceDAO();
        
        Map<String, Integer> stats = dao.getServiceUsageStatistics();
        request.setAttribute("stats", stats);
        
        List<Map<String, Object>> statsFull = dao.getServiceUsageStatisticsFull();
        request.setAttribute("statsFull", statsFull);
        
        request.getRequestDispatcher("admin/service-statistics.jsp").forward(request, response);
    }
}
