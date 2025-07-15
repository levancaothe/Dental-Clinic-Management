package controller.staff;

import dao.ServiceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Service;

import java.io.IOException;
import java.math.BigDecimal;

public class CreateServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("serviceName").trim();
        String description = request.getParameter("description") != null ? request.getParameter("description").trim() : "";
        String priceStr = request.getParameter("price").trim();
        String statusStr = request.getParameter("status");

        String error = null;
        if (name.isEmpty()) {
            error = "Tên dịch vụ không được để trống.";
        } else if (!name.matches("^[a-zA-ZÀ-ỹ0-9\\s\\-]+$")) {
            error = "Tên dịch vụ chỉ được chứa chữ cái, số, khoảng trắng và dấu gạch ngang.";
        } else if (name.length() > 100) {
            error = "Tên dịch vụ không được vượt quá 100 ký tự.";
        } else if (description.length() > 255) {
            error = "Mô tả không được vượt quá 255 ký tự.";
        } else if (description.matches(".*<[^>]+>.*")) {
            error = "Không được nhập thẻ HTML trong mô tả.";
        } else if (priceStr.isEmpty() || !priceStr.matches("\\d+")) {
            error = "Giá phải là số nguyên không âm.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("name", name);
            request.setAttribute("description", description);
            request.setAttribute("price", priceStr);
            request.setAttribute("status", statusStr);
            request.getRequestDispatcher("staff/create-service.jsp").forward(request, response);
            return;
        }

        int priceInt = Integer.parseInt(priceStr);
        BigDecimal price = BigDecimal.valueOf(priceInt);
        boolean status = "1".equals(statusStr);
        Service s = new Service(0, name, description, price, status);
        ServiceDAO dao = new ServiceDAO();
        dao.insertService(s);
        response.sendRedirect("ListServiceServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("staff/create-service.jsp").forward(request, response);
    }
}
