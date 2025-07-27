<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký Tài Khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="./css/style_k.css" rel="stylesheet"/>
        <style>
            body {
                justify-content: center;
                align-items: center;
                background: url('image/home_swp.jpg') no-repeat center center fixed;
                background-size: cover;
                position: relative;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.4);
                z-index: 1;
            }

            .register-container {
                background-color: rgba(255, 255, 255, 0.95);
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                max-width: 700px;
                width: 100%;
                padding: 30px;
                margin: 20px auto;
                border-top: 6px solid #64ccff;
                animation: fadeIn 0.6s ease-in-out;
                position: relative;
                z-index: 2;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-title {
                text-align: center;
                font-weight: 700;
                color: #0078B4;
                margin-bottom: 25px;
                font-size: 2rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
            }

            .invalid-feedback {
                display: none;
                color: #FF4500;
                font-size: 0.85rem;
                margin-top: 5px;
                font-weight: 500;
            }


            .is-invalid {
                border-color: #FF4500;
                box-shadow: 0 0 6px rgba(255, 69, 0, 0.2);
                transition: all 0.3s ease;
            }

            .gender-group {
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .gender-row {
                display: flex;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
            }

        </style>
    </head>
    <body>
        <div class="container register-container">
            <h2 class="form-title">Đăng Ký Tài Khoản</h2>

            <% 
                String error = (String) request.getAttribute("error");
                String fullName = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
                String gender = request.getAttribute("gender") != null ? (String) request.getAttribute("gender") : "";
                String dobDay = request.getAttribute("dobDay") != null ? (String) request.getAttribute("dobDay") : "";
                String dobMonth = request.getAttribute("dobMonth") != null ? (String) request.getAttribute("dobMonth") : "";
                String dobYear = request.getAttribute("dobYear") != null ? (String) request.getAttribute("dobYear") : "";   
                String phoneNumber = request.getAttribute("phoneNumber") != null ? (String) request.getAttribute("phoneNumber") : "";
                String email = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
                String address = request.getAttribute("address") != null ? (String) request.getAttribute("address") : ""; 
                
                // Đặt giá trị mặc định là ngày hiện tại nếu không có dữ liệu từ request
                java.util.Calendar cal = java.util.Calendar.getInstance();
                String defaultDobDay = dobDay.isEmpty() ? String.valueOf(cal.get(java.util.Calendar.DAY_OF_MONTH)) : dobDay;
                String defaultDobMonth = dobMonth.isEmpty() ? String.valueOf(cal.get(java.util.Calendar.MONTH) + 1) : dobMonth;
                String defaultDobYear = dobYear.isEmpty() ? String.valueOf(cal.get(java.util.Calendar.YEAR)) : dobYear;
            %>

            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>

            <% if (error != null && !error.isEmpty() && !"true".equals(request.getAttribute("showConfirmDob"))) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <% if ("true".equals(request.getAttribute("showConfirmDob"))) { %>
            <div class="alert alert-warning">
                <%= error %>
                <div class="mt-2">
                    <form action="RegisterServlet" method="post" class="d-inline">
                        <input type="hidden" name="fullname" value="<%= fullName %>">
                        <input type="hidden" name="gender" value="<%= gender %>">
                        <input type="hidden" name="dob_day" value="<%= dobDay %>">
                        <input type="hidden" name="dob_month" value="<%= dobMonth %>">
                        <input type="hidden" name="dob_year" value="<%= dobYear %>">
                        <input type="hidden" name="confirmDob" value="true">
                        <input type="hidden" name="phone" value="<%= phoneNumber %>">
                        <input type="hidden" name="email" value="<%= email %>">
                        <input type="hidden" name="address" value="<%= address %>">
                        <input type="hidden" name="passwordHash" value="<%= request.getAttribute("passwordHash") != null ? request.getAttribute("passwordHash") : "" %>">
                        <input type="hidden" name="repassword" value="<%= request.getAttribute("repassword") != null ? request.getAttribute("repassword") : "" %>">
                        <button type="submit" class="btn btn-primary btn-sm">Có</button>
                    </form>
                    <form action="RegisterServlet" method="get" class="d-inline">
                        <input type="hidden" name="fullname" value="<%= fullName %>">
                        <input type="hidden" name="gender" value="<%= gender %>">
                        <input type="hidden" name="dob_day" value="<%= dobDay %>">
                        <input type="hidden" name="dob_month" value="<%= dobMonth %>">
                        <input type="hidden" name="dob_year" value="<%= dobYear %>">
                        <input type="hidden" name="phone" value="<%= phoneNumber %>">
                        <input type="hidden" name="email" value="<%= email %>">              
                        <input type="hidden" name="address" value="<%= address %>">                                              
                        <input type="hidden" name="passwordHash" value="<%= request.getAttribute("passwordHash") != null ? request.getAttribute("passwordHash") : "" %>">
                        <input type="hidden" name="repassword" value="<%= request.getAttribute("repassword") != null ? request.getAttribute("repassword") : "" %>">
                        <button type="submit" class="btn btn-secondary btn-sm">Không</button>
                    </form>
                </div>
            </div>
            <% } else { %>
            <form action="RegisterServlet" method="post" id="registerForm">
                <div class="mb-3">
                    <label class="form-label">Họ và tên *</label>
                    <input type="text" class="form-control" name="fullname" id="fullname" value="<%= fullName %>" required>
                    <div class="invalid-feedback" id="fullnameError">Tên tài khoản chỉ được chứa chữ cái và khoảng trắng, ký tự đầu tiên phải là chữ cái, tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau</div>
                </div>

                <div class="mb-3 gender-row">
                    <label class="form-label" style="margin-bottom: 0;">Giới Tính *</label>
                    <div class="gender-group">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Nam" <%= "Nam".equals(gender) || gender.isEmpty() ? "checked" : "" %> required>
                            <label class="form-check-label">Nam</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Nữ" <%= "Nữ".equals(gender) ? "checked" : "" %>>
                            <label class="form-check-label">Nữ</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="gender" value="Khác" <%= "Khác".equals(gender) ? "checked" : "" %>>
                            <label class="form-check-label">Khác</label>
                        </div>
                    </div>
                    <div class="invalid-feedback" id="genderError">Vui lòng chọn giới tính</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ngày Sinh *</label>
                    <div class="d-flex gap-2">
                        <select class="form-select" name="dob_day" id="dob_day" required>
                            <% for (int d = 1; d <= 31; d++) { %>
                            <option <%= defaultDobDay.equals(String.valueOf(d)) ? "selected" : "" %>><%= d %></option>
                            <% } %>
                        </select>
                        <select class="form-select" name="dob_month" id="dob_month" required>
                            <% for (int m = 1; m <= 12; m++) { %>
                            <option <%= defaultDobMonth.equals(String.valueOf(m)) ? "selected" : "" %>><%= m %></option>
                            <% } %>
                        </select>
                        <select class="form-select" name="dob_year" id="dob_year" required>
                            <% 
                                int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                                for (int y = currentYear; y >= 1800; y--) { 
                            %>
                            <option <%= defaultDobYear.equals(String.valueOf(y)) ? "selected" : "" %>><%= y %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="invalid-feedback" id="dobError">Ngày sinh không hợp lệ</div>
                </div>              

                <div class="mb-3">
                    <label class="form-label">Số Điện Thoại *</label>
                    <input type="text" class="form-control" name="phone" id="phone" value="<%= phoneNumber %>" required>
                    <div class="invalid-feedback" id="phoneError">Số điện thoại phải bắt đầu bằng số 0, có đúng 10 số và không được chứa ký tự nào khác ngoài số</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email *</label>
                    <input type="email" class="form-control" name="email" id="email" value="<%= email %>" required>
                    <div class="invalid-feedback" id="emailError">Email chưa đúng định dạng, nếu chứa số thì phải có ít nhất 1 chữ cái trước @gmail.com, không được có hơn 10 ký tự liên tiếp trùng nhau trước @</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa Chỉ *</label>
                    <input type="text" class="form-control" name="address" id="address" value="<%= address %>">
                    <div class="invalid-feedback" id="addressError">Địa chỉ phải từ 2 ký tự trở lên, chỉ chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số</div>
                </div>


                <div class="mb-3 password-toggle">
                    <label class="form-label">Mật Khẩu *</label>
                    <input type="password" class="form-control" name="passwordHash" id="passwordHash" value="<%= request.getAttribute("passwordHash") != null ? request.getAttribute("passwordHash") : "" %>" required>
                    <span class="toggle-btn" onclick="togglePassword('passwordHash', 'togglePasswordIcon')">

                    </span>
                    <div class="invalid-feedback" id="passwordError">Mật khẩu phải từ 8 đến 32 ký tự, không bắt đầu bằng ký tự đặc biệt, không chứa khoảng trắng, phải có ít nhất 1 chữ cái, 1 số, 1 ký tự đặc biệt</div>
                </div>

                <div class="mb-3 password-toggle">
                    <label class="form-label">Nhập Lại Mật Khẩu *</label>
                    <input type="password" class="form-control" name="repassword" id="repassword" value="<%= request.getAttribute("repassword") != null ? request.getAttribute("repassword") : "" %>" required>
                    <span class="toggle-btn" onclick="togglePassword('repassword', 'toggleRepasswordIcon')">

                    </span>
                    <div class="invalid-feedback" id="repasswordError">Mật khẩu nhập lại phải từ 8 đến 32 ký tự, không bắt đầu bằng ký tự đặc biệt, không chứa khoảng trắng, phải có ít nhất 1 chữ cái, 1 số, 1 ký tự đặc biệt</div>
                </div>

                <div class="buttons">
                    <button type="submit" class="btn">Tạo Tài Khoản</button>
                    <button type="button" class="btn-r" onclick="cleanForm()">Xoá Tất Cả</button>
                    <a class="btn" href="home.jsp">Quay lại</a>
                </div>
            </form>
            <% } %>
        </div>
        <script>
            function togglePassword(fieldId, iconId) {
                const passwordField = document.getElementById(fieldId);
                const toggleIcon = document.getElementById(iconId);
                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    toggleIcon.classList.remove("fa-eye");
                    toggleIcon.classList.add("fa-eye-slash");
                } else {
                    passwordField.type = "password";
                    toggleIcon.classList.remove("fa-eye-slash");
                    toggleIcon.classList.add("fa-eye");
                }
            }

            function cleanForm() {
                const form = document.getElementById("registerForm");
                if (form) {
                    form.reset();
                    document.getElementById("passwordHash").type = "password";
                    document.getElementById("repassword").type = "password";
                    document.getElementById("togglePasswordIcon").classList.remove("fa-eye-slash");
                    document.getElementById("togglePasswordIcon").classList.add("fa-eye");
                    document.getElementById("toggleRepasswordIcon").classList.remove("fa-eye-slash");
                    document.getElementById("toggleRepasswordIcon").classList.add("fa-eye");
                    document.querySelectorAll(".invalid-feedback").forEach(error => error.style.display = "none");
                    document.querySelectorAll(".is-invalid").forEach(input => input.classList.remove("is-invalid"));
                }
            }

            const fullnameInput = document.getElementById("fullname");
            const fullnameError = document.getElementById("fullnameError");
            if (fullnameInput) {
                fullnameInput.addEventListener("input", function () {
                    const fullnameRegex = /^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]*$/;
                    const maxLength = 50;
                    let hasThreeConsecutive = false;
                    for (let i = 0; i < fullnameInput.value.length - 2; i++) {
                        if (fullnameInput.value[i] === fullnameInput.value[i + 1] && fullnameInput.value[i] === fullnameInput.value[i + 2]) {
                            hasThreeConsecutive = true;
                            break;
                        }
                    }
                    if (!fullnameRegex.test(fullnameInput.value) && fullnameInput.value !== "") {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.style.display = "block";
                    } else if (fullnameInput.value.length > maxLength) {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.textContent = "Tên tài khoản chứa tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau";
                        fullnameError.style.display = "block";
                    } else if (hasThreeConsecutive) {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.textContent = "Tên tài khoản không được có 3 ký tự liên tiếp trùng nhau";
                        fullnameError.style.display = "block";
                    } else {
                        fullnameInput.classList.remove("is-invalid");
                        fullnameError.style.display = "none";
                    }
                });
            }

            const passwordInput = document.getElementById("passwordHash");
            const passwordError = document.getElementById("passwordError");
            if (passwordInput) {
                passwordInput.addEventListener("input", function () {
                    const passwordSpecialCharRegex = /^[^!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?].*$/;
                    const passwordSpaceRegex = /\s/;
                    const passwordContentRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?]).*$/;
                    const minLength = 8;
                    const maxLength = 32;
                    if (!passwordSpecialCharRegex.test(passwordInput.value) && passwordInput.value !== "") {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu không được bắt đầu bằng ký tự đặc biệt";
                        passwordError.style.display = "block";
                    } else if (passwordSpaceRegex.test(passwordInput.value)) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu không được chứa khoảng trắng";
                        passwordError.style.display = "block";
                    } else if (passwordInput.value.length < minLength || passwordInput.value.length > maxLength) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu phải từ 8 đến 32 ký tự và phải có chữ cái, số và kí tự đặc biệt";
                        passwordError.style.display = "block";
                    } else if (!passwordContentRegex.test(passwordInput.value) && passwordInput.value !== "") {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu phải có ít nhất 1 chữ cái và 1 ký tự đặc biệt";
                        passwordError.style.display = "block";
                    } else {
                        passwordInput.classList.remove("is-invalid");
                        passwordError.style.display = "none";
                    }
                });
            }

            const repasswordInput = document.getElementById("repassword");
            const repasswordError = document.getElementById("repasswordError");
            if (repasswordInput) {
                repasswordInput.addEventListener("input", function () {
                    const repasswordSpecialCharRegex = /^[^!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?].*$/;
                    const repasswordSpaceRegex = /\s/;
                    const repasswordContentRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?]).*$/;
                    const minLength = 8;
                    const maxLength = 32;
                    if (!repasswordSpecialCharRegex.test(repasswordInput.value) && repasswordInput.value !== "") {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại không được bắt đầu bằng ký tự đặc biệt";
                        repasswordError.style.display = "block";
                    } else if (repasswordSpaceRegex.test(repasswordInput.value)) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại không được chứa khoảng trắng";
                        repasswordError.style.display = "block";
                    } else if (repasswordInput.value !== passwordInput.value && repasswordInput.value !== "") {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu và mật khẩu nhập lại không khớp";
                        repasswordError.style.display = "block";
                    } else if (repasswordInput.value.length < minLength || repasswordInput.value.length > maxLength) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại phải từ 8 đến 32 ký tự và phải có chữ cái, số và kí tự đặc biệt";
                        repasswordError.style.display = "block";
                    } else if (!repasswordContentRegex.test(repasswordInput.value) && repasswordInput.value !== "") {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại phải có ít nhất 1 chữ cái, 1 số, 1 ký tự đặc biệt";
                        repasswordError.style.display = "block";
                    } else {
                        repasswordInput.classList.remove("is-invalid");
                        repasswordError.style.display = "none";
                    }
                });
            }

            const phoneInput = document.getElementById("phone");
            const phoneError = document.getElementById("phoneError");
            if (phoneInput) {
                phoneInput.addEventListener("input", function () {
                    const phoneRegex = /^0\d{9}$/;
                    if (!phoneRegex.test(phoneInput.value) && phoneInput.value !== "") {
                        phoneInput.classList.add("is-invalid");
                        phoneError.style.display = "block";
                    } else {
                        phoneInput.classList.remove("is-invalid");
                        phoneError.style.display = "none";
                    }
                });
            }

            const emailInput = document.getElementById("email");
            const emailError = document.getElementById("emailError");
            if (emailInput) {
                emailInput.addEventListener("input", function () {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    const localPart = emailInput.value.split('@')[0];
                    const isOnlyNumbers = /^\d+$/.test(localPart);
                    let hasMoreThanTenConsecutive = false;
                    let count = 1;
                    for (let i = 0; i < localPart.length - 1; i++) {
                        if (localPart[i] === localPart[i + 1]) {
                            count++;
                            if (count > 10) {
                                hasMoreThanTenConsecutive = true;
                                break;
                            }
                        } else {
                            count = 1;
                        }
                    }
                    if (!emailRegex.test(emailInput.value) && emailInput.value !== "") {
                        emailInput.classList.add("is-invalid");
                        emailError.style.display = "block";
                    } else if (isOnlyNumbers && emailInput.value.toLowerCase().endsWith("@gmail.com")) {
                        emailInput.classList.add("is-invalid");
                        emailError.textContent = "Email chứa toàn số trước @gmail.com không được chấp nhận, cần ít nhất 1 chữ cái";
                        emailError.style.display = "block";
                    } else if (hasMoreThanTenConsecutive) {
                        emailInput.classList.add("is-invalid");
                        emailError.textContent = "Email không được có hơn 10 ký tự liên tiếp trùng nhau trước @";
                        emailError.style.display = "block";
                    } else {
                        emailInput.classList.remove("is-invalid");
                        emailError.style.display = "none";
                    }
                });
            }

            const addressInput = document.getElementById("address");
            const addressError = document.getElementById("addressError");
            if (addressInput) {
                addressInput.addEventListener("input", function () {
                    const addressRegex = /^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,/]*$/;
                    if (addressInput.value.length < 2 && addressInput.value !== "") {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = "Địa chỉ phải từ 2 ký tự trở lên";
                        addressError.style.display = "block";
                    } else if (!addressRegex.test(addressInput.value) && addressInput.value !== "") {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = "Địa chỉ chỉ được chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số";
                        addressError.style.display = "block";
                    } else {
                        addressInput.classList.remove("is-invalid");
                        addressError.style.display = "none";
                    }
                });
            }

            const dobDayInput = document.getElementById("dob_day");
            const dobMonthInput = document.getElementById("dob_month");
            const dobYearInput = document.getElementById("dob_year");
            const dobError = document.getElementById("dobError");
            if (dobDayInput && dobMonthInput && dobYearInput) {
                [dobDayInput, dobMonthInput, dobYearInput].forEach(input => {
                    input.addEventListener("change", function () {
                        const day = parseInt(dobDayInput.value);
                        const month = parseInt(dobMonthInput.value) - 1;
                        const year = parseInt(dobYearInput.value);
                        const dob = new Date(year, month, day);
                        const now = new Date();
                        if (isNaN(dob.getTime()) || dob > now || year < 1800 || month < 0 || month > 11 || day < 1 || day > 31) {
                            dobError.textContent = "Ngày sinh không hợp lệ";
                            dobError.style.display = "block";
                            [dobDayInput, dobMonthInput, dobYearInput].forEach(i => i.classList.add("is-invalid"));
                        } else {
                            dobError.style.display = "none";
                            [dobDayInput, dobMonthInput, dobYearInput].forEach(i => i.classList.remove("is-invalid"));
                        }
                    });
                });
            }

            const genderInputs = document.querySelectorAll('input[name="gender"]');
            const genderError = document.getElementById("genderError");
            if (genderInputs) {
                genderInputs.forEach(input => {
                    input.addEventListener("change", function () {
                        const isChecked = Array.from(genderInputs).some(i => i.checked);
                        if (!isChecked) {
                            genderError.style.display = "block";
                        } else {
                            genderError.style.display = "none";
                        }
                    });
                });
            }

            const form = document.getElementById("registerForm");
            if (form) {
                form.addEventListener("submit", function (e) {
                    e.preventDefault();
                    let isValid = true;

                    const fullnameRegex = /^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]*$/;
                    const maxLength = 50;
                    let hasThreeConsecutive = false;
                    for (let i = 0; i < fullnameInput.value.length - 2; i++) {
                        if (fullnameInput.value[i] === fullnameInput.value[i + 1] && fullnameInput.value[i] === fullnameInput.value[i + 2]) {
                            hasThreeConsecutive = true;
                            break;
                        }
                    }
                    if (!fullnameRegex.test(fullnameInput.value)) {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.style.display = "block";
                        isValid = false;
                    } else if (fullnameInput.value.length > maxLength) {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.textContent = "Tên tài khoản chứa tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau";
                        fullnameError.style.display = "block";
                        isValid = false;
                    } else if (hasThreeConsecutive) {
                        fullnameInput.classList.add("is-invalid");
                        fullnameError.textContent = "Tên tài khoản không được có 3 ký tự liên tiếp trùng nhau";
                        fullnameError.style.display = "block";
                        isValid = false;
                    }

                    const passwordSpecialCharRegex = /^[^!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?].*$/;
                    const passwordSpaceRegex = /\s/;
                    const passwordContentRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?]).*$/;
                    const passwordMinLength = 8;
                    const passwordMaxLength = 32;
                    if (!passwordSpecialCharRegex.test(passwordInput.value)) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu không được bắt đầu bằng ký tự đặc biệt";
                        passwordError.style.display = "block";
                        isValid = false;
                    } else if (passwordSpaceRegex.test(passwordInput.value)) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu không được chứa khoảng trắng";
                        passwordError.style.display = "block";
                        isValid = false;
                    } else if (passwordInput.value.length < passwordMinLength || passwordInput.value.length > passwordMaxLength) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu phải từ 8 đến 32 ký tự";
                        passwordError.style.display = "block";
                        isValid = false;
                    } else if (!passwordContentRegex.test(passwordInput.value)) {
                        passwordInput.classList.add("is-invalid");
                        passwordError.textContent = "Mật khẩu phải có ít nhất 1 chữ cái, 1 số, 1 ký tự đặc biệt";
                        passwordError.style.display = "block";
                        isValid = false;
                    }

                    const repasswordSpecialCharRegex = /^[^!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?].*$/;
                    const repasswordSpaceRegex = /\s/;
                    const repasswordContentRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:'"\\|,.<>\/?]).*$/;
                    const repasswordMinLength = 8;
                    const repasswordMaxLength = 32;
                    if (!repasswordSpecialCharRegex.test(repasswordInput.value)) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại không được bắt đầu bằng ký tự đặc biệt";
                        repasswordError.style.display = "block";
                        isValid = false;
                    } else if (repasswordSpaceRegex.test(repasswordInput.value)) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại không được chứa khoảng trắng";
                        repasswordError.style.display = "block";
                        isValid = false;
                    } else if (repasswordInput.value !== passwordInput.value) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu và mật khẩu nhập lại không khớp";
                        repasswordError.style.display = "block";
                        isValid = false;
                    } else if (repasswordInput.value.length < repasswordMinLength || repasswordInput.value.length > repasswordMaxLength) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại phải từ 8 đến 32 ký tự";
                        repasswordError.style.display = "block";
                        isValid = false;
                    } else if (!repasswordContentRegex.test(repasswordInput.value)) {
                        repasswordInput.classList.add("is-invalid");
                        repasswordError.textContent = "Mật khẩu nhập lại phải có ít nhất 1 chữ cái, 1 số, 1 ký tự đặc biệt";
                        repasswordError.style.display = "block";
                        isValid = false;
                    }

                    const phoneRegex = /^0\d{9}$/;
                    if (!phoneRegex.test(phoneInput.value)) {
                        phoneInput.classList.add("is-invalid");
                        phoneError.style.display = "block";
                        isValid = false;
                    }

                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    const localPart = emailInput.value.split('@')[0];
                    const isOnlyNumbers = /^\d+$/.test(localPart);
                    let hasMoreThanTenConsecutive = false;
                    let count = 1;
                    for (let i = 0; i < localPart.length - 1; i++) {
                        if (localPart[i] === localPart[i + 1]) {
                            count++;
                            if (count > 10) {
                                hasMoreThanTenConsecutive = true;
                                break;
                            }
                        } else {
                            count = 1;
                        }
                    }
                    if (!emailRegex.test(emailInput.value)) {
                        emailInput.classList.add("is-invalid");
                        emailError.style.display = "block";
                        isValid = false;
                    } else if (isOnlyNumbers && emailInput.value.toLowerCase().endsWith("@gmail.com")) {
                        emailInput.classList.add("is-invalid");
                        emailError.textContent = "Email chứa toàn số trước @gmail.com không được chấp nhận, cần ít nhất 1 chữ cái";
                        emailError.style.display = "block";
                        isValid = false;
                    } else if (hasMoreThanTenConsecutive) {
                        emailInput.classList.add("is-invalid");
                        emailError.textContent = "Email không được có hơn 10 ký tự liên tiếp trùng nhau trước @";
                        emailError.style.display = "block";
                        isValid = false;
                    }

                    const addressRegex = /^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,/]*$/;
                    if (addressInput.value.length < 2 || !addressRegex.test(addressInput.value)) {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = addressInput.value.length < 2 ?
                                "Địa chỉ phải từ 2 ký tự trở lên" :
                                "Địa chỉ chỉ chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số";
                        addressError.style.display = "block";
                        isValid = false;
                    }

                    const day = parseInt(dobDayInput.value);
                    const month = parseInt(dobMonthInput.value) - 1;
                    const year = parseInt(dobYearInput.value);
                    const dob = new Date(year, month, day);
                    const now = new Date();
                    if (isNaN(dob.getTime()) || dob > now || year < 1800 || month < 0 || month > 11 || day < 1 || day > 31) {
                        dobError.style.display = "block";
                        isValid = false;
                    }

                    const isGenderChecked = Array.from(genderInputs).some(i => i.checked);
                    if (!isGenderChecked) {
                        genderError.style.display = "block";
                        isValid = false;
                    }

                    if (isValid) {
                        form.submit();
                    }
                });
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>