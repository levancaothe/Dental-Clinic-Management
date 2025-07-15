package controller.staff;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dob = dobStr != null && !dobStr.isEmpty() ? sdf.parse(dobStr) : null;

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPasswordHash(password);
            user.setPhoneNumber(phone);
            user.setAddress(address);
            user.setGender(gender);
            user.setDateOfBirth(dob);
            user.setRoleId(1);
            user.setStatus(true);

            UserDAO dao = new UserDAO();
            dao.insertUser(user);

            response.sendRedirect("ViewCustomerAccountServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("staff/add-customer.jsp").forward(request, response);
    }
}
