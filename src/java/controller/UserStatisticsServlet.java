package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class UserStatisticsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String roleFilter = request.getParameter("roleFilter");
        if (roleFilter == null || roleFilter.isEmpty()
                || !("Bác sĩ".equals(roleFilter) || "Nhân viên".equals(roleFilter) || "Khách hàng".equals(roleFilter))) {
            roleFilter = "";
        }

        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || !("name".equals(sortBy) || "default".equals(sortBy))) {
            sortBy = "default";
        }

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        UserDAO dao = new UserDAO();
        List<User> userList;

        if (!search.trim().isEmpty()) {
            userList = dao.searchUsers(search.trim(), roleFilter.isEmpty() ? null : roleFilter, sortBy);
        } else if ("name".equals(sortBy)) {
            userList = dao.sortUsersByNameAZ(roleFilter.isEmpty() ? null : roleFilter);
        } else {
            userList = dao.getUsersByDefaultOrder(roleFilter.isEmpty() ? null : roleFilter);
        }

        userList = dao.getUsersByPage(page, PAGE_SIZE, roleFilter.isEmpty() ? null : roleFilter, userList);

        int totalUsers = search.trim().isEmpty()
                ? dao.getTotalUsers(roleFilter.isEmpty() ? null : roleFilter)
                : dao.getTotalUsersWithSearch(search.trim(), roleFilter.isEmpty() ? null : roleFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);

        int totalDoctors = dao.getTotalUsers("Bác sĩ");
        int totalStaff = dao.getTotalUsers("Nhân viên");
        int totalCustomers = dao.getTotalUsers("Khách hàng");
        int totalAllUsers = dao.getTotalUsers(null);

        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("search", search);
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalAllUsers", totalAllUsers);

        request.getRequestDispatcher("statistics.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User statistics servlet with pagination, sorting, and search";
    }
}
