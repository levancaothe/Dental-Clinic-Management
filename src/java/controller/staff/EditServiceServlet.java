package controller.staff;

import dao.ServiceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.Service;

import java.io.IOException;
import java.math.BigDecimal;

public class EditServiceServlet extends HttpServlet {

    private final ServiceDAO dao = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Service service = dao.getServiceById(id);
            if (service == null) {
                response.sendRedirect("staff/service-list.jsp");
                return;
            }
            request.setAttribute("service", service);
            request.getRequestDispatcher("staff/edit-service.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff/service-list.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idRaw = request.getParameter("id");
        String name = request.getParameter("serviceName") != null ? request.getParameter("serviceName").trim() : "";
        String description = request.getParameter("description") != null ? request.getParameter("description").trim() : "";
        String priceStr = request.getParameter("price") != null ? request.getParameter("price").trim() : "";
        String statusStr = request.getParameter("status");

        String error = null;
        int id = 0;

        try {
            id = Integer.parseInt(idRaw);

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
                Service s = new Service(id, name, description,
                        new BigDecimal(priceStr.isEmpty() ? "0" : priceStr),
                        "1".equals(statusStr));
                request.setAttribute("error", error);
                request.setAttribute("service", s);
                request.getRequestDispatcher("staff/edit-service.jsp").forward(request, response);
                return;
            }

            int priceInt = Integer.parseInt(priceStr);
            BigDecimal price = BigDecimal.valueOf(priceInt);
            boolean status = "1".equals(statusStr);
            Service s = new Service(id, name, description, price, status);
            dao.updateService(s);
            response.sendRedirect("ListServiceServlet");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("staff/service-list.jsp");
        }
    }
}
