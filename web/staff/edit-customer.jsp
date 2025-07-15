<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, java.text.SimpleDateFormat"%>
<%
    User user = (User) request.getAttribute("customer");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    Boolean showConfirmDob = (Boolean) request.getAttribute("showConfirmDob");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    if (user == null && error == null) {
%>
<p style="color:red; text-align:center; font-weight:bold;">Không tìm thấy tài khoản khách hàng!</p>
<div style="text-align:center; margin-top: 20px;">
    <a href="ViewCustomerAccountServlet">Quay về danh sách khách hàng</a>
</div>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa tài khoản khách hàng</title>
        <link rel="stylesheet" href="./css/style_k.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .form-container {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                max-width: 800px;
                width: 90%;
                margin: 40px auto;
                overflow: hidden;
                padding: 30px;
            }

            .form-container h2 {
                background-color: #64ccff;
                color: white;
                padding: 16px;
                font-weight: bold;
                font-size: 1.3rem;
                text-align: center;
                border-radius: 8px;
                margin-bottom: 25px;
            }

            label {
                font-weight: bold;
                display: block;
                margin: 12px 0 6px;
                color: #333;
            }

            input[type="text"],
            input[type="email"],
            input[type="date"],
            select {
                width: 100%;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 1rem;
                box-sizing: border-box;
            }

            .error {
                color: red;
                font-weight: bold;
                margin-top: 10px;
                text-align: center;
            }

            .message {
                color: green;
                font-weight: bold;
                margin-top: 10px;
                text-align: center;
            }

            .button-group {
                display: flex;
                justify-content: center;
                gap: 12px;
                margin-top: 25px;
                flex-wrap: wrap;
            }

            .button-group button,
            .button-group a {
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: bold;
                background-color: white;
                color: #64ccff;
                border: 1px solid #64ccff;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .button-group button:hover,
            .button-group a:hover {
                background-color: #64ccff;
                color: white;
            }
            .banner .logo-link {
                display: inline-block;
            }

            .banner .logo-link img {
                width: 60px;
                height: 60px;
                object-fit: contain;
            }

            .banner .logo-link {
                border: none;
                background: none;
                padding: 0;
            }

            .banner .logo-link:hover {
                background: none;
                color: inherit;
                cursor: pointer;
            }
            .error-msg {
                color: red;
                font-size: 0.9rem;
                font-weight: 500;
                display: none;
                margin-top: 4px;
            }

            input.is-invalid {
                border-color: red;
                background-color: #ffe6e6;
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="staff/dashboard.jsp" class="btn">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="staff/dashboard.jsp" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>

        <div class="form-container">
            <h2>Chỉnh sửa tài khoản khách hàng</h2>

            <% if (error != null) { %>
            <p class="error"><%= error %></p>
            <% } else if (message != null) { %>
            <p class="message"><%= message %></p>
            <% } %>
            <form method="post" action="EditCustomerServlet" id="editCustomerForm">
                <input type="hidden" name="id" value="<%= user.getUserId() %>" />

                <label>Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required />
                <span class="error-msg" id="fullNameError"></span>

                <label>Email:</label>
                <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required />
                <span class="error-msg" id="emailError"></span>

                <label>Số điện thoại:</label>
                <input type="text" id="phone" name="phone" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" />
                <span class="error-msg" id="phoneError"></span>

                <label>Địa chỉ:</label>
                <input type="text" id="address" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" />
                <span class="error-msg" id="addressError"></span>

                <label>Ngày sinh:</label>
                <input type="date" id="dob" name="dob" value="<%= user.getDateOfBirth() != null ? sdf.format(user.getDateOfBirth()) : "" %>" />
                <span class="error-msg" id="dobError"></span>

                <% if (Boolean.TRUE.equals(showConfirmDob)) { %>
                <p style="color: orange;">Bạn có chắc chắn ngày sinh này không?</p>
                <div class="button-group">
                    <button type="submit" name="confirmDob" value="true">Có</button>
                    <a href="EditCustomerServlet?id=<%= user.getUserId() %>">Không</a>
                </div>
                <% } else { %>
                <label>Giới tính:</label>
                <select name="gender">
                    <option value="Nam" <%= "Nam".equals(user.getGender()) ? "selected" : "" %>>Nam</option>
                    <option value="Nữ" <%= "Nữ".equals(user.getGender()) ? "selected" : "" %>>Nữ</option>
                    <option value="Khác" <%= "Khác".equals(user.getGender()) ? "selected" : "" %>>Khác</option>
                </select>
                <div class="button-group">
                    <button type="submit">Lưu thay đổi</button>
                    <button type="reset">Xóa tất cả</button>
                </div>
                <% } %>
            </form>

        </div>
        <script>
            function validateFullName() {
                const input = document.getElementById("fullName");
                const error = document.getElementById("fullNameError");
                const value = input.value.trim();
                const regex = /^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]*$/;
                const hasThreeRepeat = /(.)\1\1/;

                if (value === "") {
                    hideError(input, error);
                    return;
                }

                if (!regex.test(value)) {
                    error.textContent = "Tên không hợp lệ. Chỉ chứa chữ cái và khoảng trắng.";
                    showError(input, error);
                } else if (value.length > 50) {
                    error.textContent = "Tên quá dài (tối đa 50 ký tự).";
                    showError(input, error);
                } else if (hasThreeRepeat.test(value)) {
                    error.textContent = "Không được có 3 ký tự liên tiếp giống nhau.";
                    showError(input, error);
                } else {
                    hideError(input, error);
                }
            }

            function validateEmail() {
                const input = document.getElementById("email");
                const error = document.getElementById("emailError");
                const value = input.value.trim();
                const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (value === "") {
                    hideError(input, error);
                    return;
                }

                if (!regex.test(value)) {
                    error.textContent = "Email không hợp lệ.";
                    showError(input, error);
                } else {
                    hideError(input, error);
                }
            }

            function validatePhone() {
                const input = document.getElementById("phone");
                const error = document.getElementById("phoneError");
                const value = input.value.trim();
                const regex = /^0\d{9}$/;

                if (value === "") {
                    hideError(input, error);
                    return;
                }

                if (!regex.test(value)) {
                    error.textContent = "SĐT phải bắt đầu bằng 0 và có đúng 10 số.";
                    showError(input, error);
                } else {
                    hideError(input, error);
                }
            }

            function validateAddress() {
                const input = document.getElementById("address");
                const error = document.getElementById("addressError");
                const value = input.value.trim();
                const regex = /^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,/]*$/;

                if (value === "") {
                    hideError(input, error);
                    return;
                }

                if (value.length < 2 || !regex.test(value)) {
                    error.textContent = "Địa chỉ không hợp lệ.";
                    showError(input, error);
                } else {
                    hideError(input, error);
                }
            }

            function validateDob() {
                const input = document.getElementById("dob");
                const error = document.getElementById("dobError");
                const value = input.value;

                if (value === "") {
                    hideError(input, error);
                    return;
                }

                const dob = new Date(value);
                const now = new Date();

                if (isNaN(dob.getTime()) || dob > now || dob.getFullYear() < 1900) {
                    error.textContent = "Ngày sinh không hợp lệ.";
                    showError(input, error);
                } else {
                    hideError(input, error);
                }
            }

            function showError(input, error) {
                input.classList.add("is-invalid");
                error.style.display = "block";
            }

            function hideError(input, error) {
                input.classList.remove("is-invalid");
                error.style.display = "none";
            }

            document.getElementById("fullName").addEventListener("input", validateFullName);
            document.getElementById("email").addEventListener("input", validateEmail);
            document.getElementById("phone").addEventListener("input", validatePhone);
            document.getElementById("address").addEventListener("input", validateAddress);
            document.getElementById("dob").addEventListener("change", validateDob);

            // Gắn sự kiện kiểm tra toàn form khi submit
            document.getElementById("editCustomerForm").addEventListener("submit", function (e) {
                validateFullName();
                validateEmail();
                validatePhone();
                validateAddress();
                validateDob();

                const invalidFields = document.querySelectorAll(".is-invalid");
                if (invalidFields.length > 0) {
                    e.preventDefault(); // Chặn gửi form nếu còn lỗi
                    alert("Vui lòng kiểm tra lại các trường dữ liệu bị lỗi trước khi gửi.");
                }
            });
        </script>
    </body>
</html>