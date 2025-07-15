<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm nhân sự</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }
            .container {
                max-width: 650px;
                margin: 50px auto;
                background: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .form-title {
                font-size: 22px;
                font-weight: 600;
                color: #007acc;
                margin-bottom: 20px;
                text-align: center;
            }
            .form-error {
                color: red;
                font-size: 0.9em;
            }
        </style>
        <script>
            function validateField(field) {
                const name = field.name;
                const value = field.value.trim();
                let error = "";

                if (value === "")
                    return;

                if (name === "fullName") {
                    if (!/^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]{0,49}$/.test(value)) {
                        error = "Tên không hợp lệ (tối đa 50 ký tự, không chứa số/ký tự đặc biệt)";
                    } else if (/([\S\s])\1\1/.test(value)) {
                        error = "Tên không được chứa 3 ký tự liên tiếp giống nhau";
                    }
                }
                if (name === "email" && !/^[A-Za-z0-9+_.-]+@(.+)$/.test(value)) {
                    error = "Email không hợp lệ";
                }
                if (name === "phone" && !/^0\d{9}$/.test(value)) {
                    error = "Số điện thoại phải bắt đầu bằng 0 và đủ 10 số";
                }
                if (name === "password") {
                    if (value.length < 8 || value.length > 32) {
                        error = "Mật khẩu phải từ 8 đến 32 ký tự và phải có chữ cái, số và kí tự đặc biệt";
                    } else if (value.includes(" ")) {
                        error = "Không được chứa dấu cách";
                    } else if (!/[A-Za-z]/.test(value)) {
                        error = "Phải chứa ít nhất 1 chữ cái";
                    } else if (!/[!@#$%^&*()_+\-=[\]{};:'\"\\|,.<>/?]/.test(value)) {
                        error = "Phải có ký tự đặc biệt";
                    }
                }              }
                
                if (name === "address") {
                    if (!/^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,./]*$/.test(value)) {
                        error = "Địa chỉ không hợp lệ";
                    } else if (/([\S\s])\1\1/.test(value)) {
                        error = "Địa chỉ không được chứa 3 ký tự liên tiếp giống nhau";
                    }
                }
                
                if (name === "dob") {
                    const dob = new Date(value);
                    const today = new Date();
                    const age = today.getFullYear() - dob.getFullYear();
                    if (dob > today) {
                        error = "Ngày sinh không hợp lệ";
                    } else if (age > 60) {
                        error = "Tuổi không quá 60";
                    }
                }
                document.getElementById(name + "Error").innerText = error;
            }

            window.addEventListener("DOMContentLoaded", () => {
                document.querySelectorAll("input, select").forEach(field => {
                    field.addEventListener("input", () => validateField(field));
                });
            });
        </script>
    </head>
    <body>
        <div class="container">
            <div class="form-title">➕ Thêm tài khoản nhân sự</div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <form action="AddUserServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Họ và tên:</label>
                    <input type="text" name="fullName" class="form-control" value="${fullName}" required>
                    <div id="fullNameError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="email" name="email" class="form-control" value="${email}" required>
                    <div id="emailError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại:</label>
                    <input type="text" name="phone" class="form-control" value="${phone}" required>
                    <div id="phoneError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ:</label>
                    <input type="text" name="address" class="form-control" value="${address}" required>
                    <div id="addressError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu:</label>
                    <input type="password" name="password" class="form-control" value="${password}" required>
                    <div id="passwordError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày sinh:</label>
                    <input type="date" name="dob" class="form-control" value="${dob}" required>
                    <div id="dobError" class="form-error"></div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giới tính:</label>
                    <select name="gender" class="form-select">
                        <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                        <option value="Nữ" ${gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        <option value="Khác" ${gender == 'Khác' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="form-label">Vai trò:</label>
                    <select name="roleId" class="form-select" required>
                        <option value="2" ${roleId == '2' ? 'selected' : ''}>Nhân viên</option>
                        <option value="3" ${roleId == '3' ? 'selected' : ''}>Bác sĩ</option>
                    </select>
                </div>
                <div class="d-flex justify-content-between">
                    <button class="btn btn-primary" type="submit">Tạo tài khoản</button>
                    <button class="btn btn-secondary" type="reset">Làm mới</button>
                </div>
            </form>
        </div>
    </body>
</html>