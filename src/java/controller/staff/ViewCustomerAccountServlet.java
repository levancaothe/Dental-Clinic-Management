package controller.staff;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ViewCustomerAccountServlet extends HttpServlet {

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

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        String sortBy = request.getParameter("sortBy");
        if (sortBy == null) {
            sortBy = "default";
        }

        System.out.println("Received sortBy: " + sortBy + ", search: " + search);

        UserDAO dao = new UserDAO();
        List<User> customerList;

        if (!search.trim().isEmpty()) {
            customerList = dao.searchCustomers(search.trim(), sortBy);
        } else if ("name".equalsIgnoreCase(sortBy)) {
            customerList = dao.sortCustomersByNameAZ();
        } else {
            customerList = dao.getCustomersByDefaultOrder();
        }

        System.out.println("Customer list size: " + customerList.size());

        customerList = dao.getUsersByPage(page, PAGE_SIZE, "Khách hàng", customerList);
        int totalCustomers = dao.getTotalUsers("Khách hàng");
        int totalPages = (int) Math.ceil((double) totalCustomers / PAGE_SIZE);

        request.setAttribute("customerList", customerList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("staff/view-customer-account.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet để xem thông tin khách hàng với tìm kiếm và phân trang";
    }
}
