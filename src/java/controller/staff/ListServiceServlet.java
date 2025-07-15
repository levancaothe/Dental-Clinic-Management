package controller.staff;

import dao.ServiceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ListServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;

        String pageRaw = request.getParameter("page");
        if (pageRaw != null) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        String sort = request.getParameter("sort");
        if (sort == null) {
            sort = "auto";
        }

        ServiceDAO dao = new ServiceDAO();

        List<Service> allFiltered = dao.searchSortServices(keyword, sort);
        int totalServices = allFiltered.size();
        int totalPages = (int) Math.ceil((double) totalServices / pageSize);
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalServices);

        List<Service> paginatedList = new ArrayList<>();
        if (fromIndex < toIndex) {
            paginatedList = allFiltered.subList(fromIndex, toIndex);
        }

        request.setAttribute("services", paginatedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("staff/list-service.jsp").forward(request, response);
    }
}
