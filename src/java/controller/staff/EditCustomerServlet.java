package controller.staff;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class EditCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy người dùng");
            request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
            return;
        }
        try {
            int id = Integer.parseInt(idRaw);
            UserDAO dao = new UserDAO();
            User user = dao.getUserById(id);
            if (user == null) {
                request.setAttribute("error", "Người dùng không tồn tại");
            } else {
                request.setAttribute("customer", user);
            }
            request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ");
            request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idRaw = request.getParameter("id");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String confirmDob = request.getParameter("confirmDob");

        String error = null;
        User user = new User();

        try {
            int id = Integer.parseInt(idRaw);
            user.setUserId(id);

            if (fullName == null || fullName.trim().isEmpty()) {
                error = "Họ và tên không được để trống.";
            } else if (!fullName.matches("^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\\s]{0,49}$")) {
                error = "Tên chỉ chứa chữ và khoảng trắng, tối đa 50 ký tự.";
            } else {
                for (int i = 0; i < fullName.length() - 2; i++) {
                    if (fullName.charAt(i) == fullName.charAt(i + 1) && fullName.charAt(i) == fullName.charAt(i + 2)) {
                        error = "Tên không được có 3 ký tự liên tiếp giống nhau.";
                        break;
                    }
                }
            }
            user.setFullName(fullName);

            if (phone == null || !phone.matches("^0\\d{9}$")) {
                error = "Số điện thoại phải bắt đầu bằng 0 và đủ 10 số.";
            }
            user.setPhoneNumber(phone);

            if (address == null || address.trim().length() < 2) {
                error = "Địa chỉ phải có ít nhất 2 ký tự.";
            } else if (!address.matches("^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\\s/,\\.]*$")) {
                error = "Địa chỉ chỉ chứa chữ, số, khoảng trắng, dấu phẩy, chấm hoặc gạch chéo.";
            }
            user.setAddress(address);

            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    sdf.setLenient(false);
                    Date dob = sdf.parse(dobStr);
                    Date now = new Date();
                    if (dob.after(now)) {
                        error = "Ngày sinh không được lớn hơn hiện tại.";
                    } else {
                        int birthYear = Integer.parseInt(dobStr.substring(0, 4));
                        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                        if (currentYear - birthYear > 100 && !"true".equals(confirmDob)) {
                            request.setAttribute("showConfirmDob", true);
                            error = "Bạn có chắc sinh năm " + birthYear + " không?";
                        }
                    }
                    user.setDateOfBirth(dob);
                } catch (ParseException e) {
                    error = "Định dạng ngày sinh không hợp lệ.";
                }
            }

            user.setGender(gender);
            user.setEmail(email);

            if (error != null) {
                request.setAttribute("error", error);
                request.setAttribute("customer", user);
                request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
                return;
            }

            UserDAO dao = new UserDAO();
            boolean updated = dao.updateProfile(user);

            if (updated) {
                User updatedUser = dao.getUserById(user.getUserId());
                request.setAttribute("message", "Cập nhật thành công.");
                request.setAttribute("customer", updatedUser);
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
                request.setAttribute("customer", user);
            }

            request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình xử lý.");
            request.getRequestDispatcher("staff/edit-customer.jsp").forward(request, response);
        }
    }
}