package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.User;
import utils.AccessControl;

import java.io.IOException;
import java.util.List;

public class ManageAccountStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!AccessControl.hasPermission(session, "Quản lý trạng thái tài khoản")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");

        if (keyword != null) {
            keyword = keyword.trim();
        }

        int page = 1;
        int pageSize = 10;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        UserDAO dao = new UserDAO();
        List<User> allEmployees = dao.getInternalUsers(keyword, sortBy);

        int totalEmployees = allEmployees.size();
        int totalPages = (int) Math.ceil((double) totalEmployees / pageSize);

        int fromIndex = Math.max((page - 1) * pageSize, 0);
        int toIndex = Math.min(fromIndex + pageSize, totalEmployees);
        List<User> paginatedEmployees = allEmployees.subList(fromIndex, toIndex);

        request.setAttribute("employees", paginatedEmployees);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("admin/manage-account-status.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!AccessControl.hasPermission(session, "Quản lý trạng thái tài khoản")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));
            UserDAO dao = new UserDAO();
            dao.updateUserStatus(userId, newStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String page = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");

        if (keyword == null) {
            keyword = "";
        }
        if (sortBy == null) {
            sortBy = "";
        }
        if (page == null) {
            page = "1";
        }

        String redirectUrl = String.format("ManageAccountStatusServlet?page=%s&keyword=%s&sortBy=%s",
                page,
                java.net.URLEncoder.encode(keyword, "UTF-8"),
                java.net.URLEncoder.encode(sortBy, "UTF-8")
        );
        response.sendRedirect(redirectUrl);
    }
}
