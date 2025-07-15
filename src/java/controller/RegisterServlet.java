package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullname");
        String passwordHash = request.getParameter("passwordHash");
        String repassword = request.getParameter("repassword");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone");
        String address = request.getParameter("address");
        String dobDay = request.getParameter("dob_day");
        String dobMonth = request.getParameter("dob_month");
        String dobYear = request.getParameter("dob_year");
        String gender = request.getParameter("gender");
        String confirmDob = request.getParameter("confirmDob");

        String errorMessage = "";
        String successMessage = "";

        if (fullName == null || fullName.trim().isEmpty()) {
            errorMessage = "Họ và tên không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!fullName.matches("^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\\s]*$") || fullName.length() > 50) {
            errorMessage = "Tên tài khoản chỉ được chứa chữ cái và khoảng trắng, ký tự đầu tiên phải là chữ cái, tối đa 50 ký tự.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        boolean hasThreeConsecutive = false;
        for (int i = 0; i < fullName.length() - 2; i++) {
            if (fullName.charAt(i) == fullName.charAt(i + 1) && fullName.charAt(i) == fullName.charAt(i + 2)) {
                hasThreeConsecutive = true;
                break;
            }
        }
        if (hasThreeConsecutive) {
            errorMessage = "Tên tài khoản không được có 3 ký tự liên tiếp trùng nhau.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (passwordHash == null || passwordHash.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!passwordHash.matches("^[^!@#$%^&*()_+\\-=\\[\\]{};:'\"\\\\|,.<>\\/?].*$")) {
            errorMessage = "Mật khẩu không được bắt đầu bằng ký tự đặc biệt.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (passwordHash.matches(".*\\s+.*")) {
            errorMessage = "Mật khẩu không được chứa khoảng trắng.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (repassword == null || repassword.trim().isEmpty()) {
            errorMessage = "Nhập lại mật khẩu không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!repassword.matches("^[^!@#$%^&*()_+\\-=\\[\\]{};:'\"\\\\|,.<>\\/?].*$")) {
            errorMessage = "Nhập lại mật khẩu không được bắt đầu bằng ký tự đặc biệt.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (repassword.matches(".*\\s+.*")) {
            errorMessage = "Nhập lại mật khẩu không được chứa khoảng trắng.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (!passwordHash.equals(repassword)) {
            errorMessage = "Mật khẩu và nhập lại mật khẩu không khớp.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            errorMessage = "Email không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errorMessage = "Email không hợp lệ.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        String localPart = email.split("@")[0];
        if (localPart.matches("^[0-9]+$") && email.toLowerCase().endsWith("@gmail.com")) {
            errorMessage = "Email chứa toàn số trước @gmail.com không được chấp nhận, cần ít nhất 1 chữ cái.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        int count = 1;
        boolean hasMoreThanTenConsecutive = false;
        for (int i = 0; i < localPart.length() - 1; i++) {
            if (localPart.charAt(i) == localPart.charAt(i + 1)) {
                count++;
                if (count > 10) {
                    hasMoreThanTenConsecutive = true;
                    break;
                }
            } else {
                count = 1;
            }
        }
        if (hasMoreThanTenConsecutive) {
            errorMessage = "Email không được có hơn 10 ký tự liên tiếp trùng nhau trước @.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            errorMessage = "Số điện thoại không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!phoneNumber.matches("^0\\d{9}$")) {
            errorMessage = "Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            errorMessage = "Địa chỉ không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (address.length() < 2) {
            errorMessage = "Địa chỉ phải có ít nhất 2 ký tự.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        if (!address.matches("^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\\s*,.]*$")) {
            errorMessage = "Địa chỉ chỉ được chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        Date birthDate = null;
        if (dobDay == null || dobMonth == null || dobYear == null
                || dobDay.trim().isEmpty() || dobMonth.trim().isEmpty() || dobYear.trim().isEmpty()) {
            errorMessage = "Ngày sinh không được để trống.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }
        String dob = dobYear + "-" + (dobMonth.length() == 1 ? "0" + dobMonth : dobMonth) + "-"
                + (dobDay.length() == 1 ? "0" + dobDay : dobDay);

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            birthDate = sdf.parse(dob);
            Date currentDate = new Date();
            if (birthDate.after(currentDate)) {
                errorMessage = "Ngày sinh không được là ngày trong tương lai.";
                forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
                return;
            }
            int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
            int birthYear = Integer.parseInt(dobYear);
            if (currentYear - birthYear > 100 && !"true".equals(confirmDob)) {
                errorMessage = "Bạn có chắc là bạn sinh năm " + birthYear + " không?";
                request.setAttribute("fullName", fullName);
                request.setAttribute("passwordHash", passwordHash);
                request.setAttribute("repassword", repassword);
                request.setAttribute("email", email);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("address", address);
                request.setAttribute("dobDay", dobDay);
                request.setAttribute("dobMonth", dobMonth);
                request.setAttribute("dobYear", dobYear);
                request.setAttribute("gender", gender);
                request.setAttribute("showConfirmDob", "true");
                request.setAttribute("error", errorMessage);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
        } catch (ParseException e) {
            errorMessage = "Ngày sinh không hợp lệ.";
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            if (userDAO.isEmailExists(email)) {
                errorMessage = "Email \"" + email + "\" đã tồn tại, vui lòng chọn email khác để đăng ký hoặc quay lại đăng nhập bằng Email \"" + email + "\"";
                forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
                return;
            }
        } catch (SQLException ex) {
            errorMessage = "Lỗi khi kiểm tra email: " + ex.getMessage();
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setPasswordHash(passwordHash);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setAddress(address);
        user.setRoleId(1);
        user.setStatus(true);
        user.setGender(gender);
        user.setDateOfBirth(birthDate);

        try {
            UserDAO userDAO = new UserDAO();
            userDAO.insertUser(user);

            successMessage = "Đăng ký thành công!";
            request.setAttribute("success", successMessage);
            request.getRequestDispatcher("/success.jsp").forward(request, response);

        } catch (SQLException ex) {
            errorMessage = "Lỗi khi lưu dữ liệu vào cơ sở dữ liệu: " + ex.getMessage();
            forwardError(fullName, passwordHash, repassword, email, phoneNumber, address, dobDay, dobMonth, dobYear, gender, errorMessage, request, response);
        }
    }

    private void forwardError(String fullName, String passwordHash, String repassword, String email, String phoneNumber, String address, String dobDay, String dobMonth, String dobYear, String gender, String errorMessage, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.setAttribute("fullName", fullName);
        request.setAttribute("passwordHash", passwordHash);
        request.setAttribute("repassword", repassword);
        request.setAttribute("email", email);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("address", address);
        request.setAttribute("dobDay", dobDay);
        request.setAttribute("dobMonth", dobMonth);
        request.setAttribute("dobYear", dobYear);
        request.setAttribute("gender", gender);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("fullName", request.getParameter("fullname"));
        request.setAttribute("passwordHash", request.getParameter("passwordHash"));
        request.setAttribute("repassword", request.getParameter("repassword"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phoneNumber", request.getParameter("phone"));
        request.setAttribute("address", request.getParameter("address"));
        request.setAttribute("dobDay", request.getParameter("dob_day"));
        request.setAttribute("dobMonth", request.getParameter("dob_month"));
        request.setAttribute("dobYear", request.getParameter("dob_year"));
        request.setAttribute("gender", request.getParameter("gender"));
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
