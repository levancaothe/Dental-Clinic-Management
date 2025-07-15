package controller;

import dao.ServiceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

public class DeleteServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ServiceDAO dao = new ServiceDAO();
        dao.deleteService(id);
        response.sendRedirect("ListServiceServlet");
    }
}
