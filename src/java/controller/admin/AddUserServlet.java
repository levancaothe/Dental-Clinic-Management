package controller.admin;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            int roleId = Integer.parseInt(request.getParameter("roleId"));

            if (!phone.matches("^0\\d{9}$")) {
                throw new Exception("Số điện thoại không hợp lệ");
            }
            if (password.length() < 8 || password.length() > 32 || password.contains(" ")
                    || !password.matches(".*[A-Za-z].*")
                    || !password.matches(".*[!@#$%^&*()_+\\-\\[\\]{};:'\"\\\\|,.<>/?].*")) {
                throw new Exception("Mật khẩu không hợp lệ");
            }

            Date dob = null;
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
                if (dob.after(new Date())) {
                    throw new Exception("Ngày sinh không hợp lệ");
                }
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhoneNumber(phone);
            user.setAddress(address);
            user.setPasswordHash(password);
            user.setGender(gender);
            user.setDateOfBirth(dob);
            user.setRoleId(roleId);
            user.setStatus(true);

            UserDAO dao = new UserDAO();
            dao.insertUser(user);

            request.setAttribute("success", "✅ Thêm nhân sự thành công!");
        } catch (Exception e) {
            request.setAttribute("error", "❌ Email đã tồn tại. Vui lòng chọn email khác.");
        }

        request.getRequestDispatcher("admin/add-user.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("admin/add-user.jsp").forward(request, response);
    }
}
