package controller;

import dao.UserDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "AddStaffServlet", urlPatterns = {"/addstaffservlet"})
public class AddStaffServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");

            if (phone == null || !phone.matches("\\d{10}")) {
                request.setAttribute("error", "Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số.");
                request.getRequestDispatcher("add-staff.jsp").forward(request, response);
                return;
            }
                Date dob = null;
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        sdf.setLenient(false);
                        dob = sdf.parse(dobStr);
                    } catch (ParseException e) {
                        request.setAttribute("error", "Ngày sinh không hợp lệ. Vui lòng nhập theo định dạng yyyy-MM-dd.");
                        request.getRequestDispatcher("add-staff.jsp").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("error", "Vui lòng nhập ngày sinh.");
                    request.getRequestDispatcher("add-staff.jsp").forward(request, response);
                    return;
                }

                User user = new User();
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPasswordHash(password);
                user.setPhoneNumber(phone);
                user.setAddress(address);
                user.setRoleId(roleId);
                user.setGender(gender);
                user.setDateOfBirth(dob);
                user.setStatus(true);

                UserDAO dao = new UserDAO();
                dao.insertUser(user);

                request.setAttribute("success", "✅ Thêm nhân viên thành công.");
                request.getRequestDispatcher("admin/add-staff.jsp").forward(request, response);


            }catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm nhân viên: " + ex.getMessage());
            request.getRequestDispatcher("admin/add-staff.jsp").forward(request, response);
        }
        }

        @Override
        public String getServletInfo
        
            () {
        return "AddStaffServlet - Thêm mới nhân viên";
        }
    }
