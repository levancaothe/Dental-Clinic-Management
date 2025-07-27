<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String dashboardUrl = "#";
    if (currentUser != null) {
        int role = currentUser.getRoleId();
        switch (role) {
            case 1: dashboardUrl = "admin/dashboard.jsp"; break;
            case 2: dashboardUrl = "staff/dashboard.jsp"; break;
            case 3: dashboardUrl = "doctor/dashboard.jsp"; break;
            case 4: dashboardUrl = "customer/dashboard.jsp"; break;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm Dịch vụ</title>
        <link href="<%= request.getContextPath() %>/css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .form-body input[type="text"],
            .form-body input[type="number"],
            .form-body textarea,
            .form-body select {
                border-radius: 8px;
                border: 1px solid #ccc;
                padding: 10px 12px;
                width: 100%;
                box-sizing: border-box;
                margin-bottom: 6px;
                font-size: 1rem;
            }

            .form-body label {
                font-weight: 600;
                margin-top: 12px;
                display: block;
            }

            .error-message {
                color: red;
                font-size: 0.9em;
                font-weight: 500;
                display: none;
                margin-top: 2px;
                margin-bottom: 10px;
            }

            .buttons {
                text-align: center;
                margin-top: 20px;
            }

            .buttons .btn, .buttons .btn-r {
                width: 140px;
            }

            .is-invalid {
                /* Không có viền đỏ */
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="<%= dashboardUrl %>">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back"><i class="fas fa-arrow-left"></i></a>
                <a href="<%= dashboardUrl %>" class="btn"><i class="fas fa-home"></i></a>
            </div>
        </div>

        <div class="content">
            <div class="form-container">
                <div class="header">Thêm Dịch vụ Mới</div>
                <div class="form-body">
                    <form action="CreateServiceServlet" method="post" id="createServiceForm">
                        <label for="serviceName">Tên dịch vụ:</label>
                        <input type="text" id="serviceName" name="serviceName" placeholder="Nhập tên dịch vụ" />
                        <span class="error-message" id="serviceNameError"></span>

                        <label for="description">Mô tả:</label>
                        <textarea id="description" name="description" rows="4" placeholder="Mô tả ngắn về dịch vụ..."></textarea>
                        <span class="error-message" id="descriptionError"></span>

                        <label for="price">Giá (VNĐ):</label>
                        <input type="number" id="price" name="price"
                               value="<%= request.getAttribute("price") != null ? new java.math.BigDecimal((String)request.getAttribute("price")).stripTrailingZeros().toPlainString() : "" %>"
                               placeholder="Ví dụ: 500000" min="0" step="1" />
                        <span class="error-message" id="priceError"></span>

                        <label for="status">Trạng thái:</label>
                        <select name="status">
                            <option value="1">Hoạt động</option>
                            <option value="0">Ngừng</option>
                        </select>

                        <div class="buttons">
                            <button type="submit" class="btn">Thêm</button>
                            <button type="reset" class="btn-r" onclick="clearErrors()">Xoá</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <footer>Nụ cười của bạn – Sứ mệnh của chúng tôi!</footer>

        <script>
            function showError(input, message) {
                const error = document.getElementById(input.id + "Error");
                error.textContent = message;
                error.style.display = "block";
                input.classList.add("is-invalid");
            }

            function hideError(input) {
                const error = document.getElementById(input.id + "Error");
                error.textContent = "";
                error.style.display = "none";
                input.classList.remove("is-invalid");
            }

            function clearErrors() {
                ["serviceName", "description", "price"].forEach(id => {
                    hideError(document.getElementById(id));
                });
            }

            function validateServiceName() {
                const input = document.getElementById("serviceName");
                const value = input.value.trim();
                const regex = /^[a-zA-ZÀ-ỹ0-9\s\-]+$/;
                if (value === "") {
                    showError(input, "Tên dịch vụ không được để trống.");
                    return false;
                } else if (!regex.test(value)) {
                    showError(input, "Tên chỉ chứa chữ, số, khoảng trắng và dấu gạch ngang.");
                    return false;
                } else if (value.length > 100) {
                    showError(input, "Tên không vượt quá 100 ký tự.");
                    return false;
                } else {
                    hideError(input);
                    return true;
                }
            }

            function validateDescription() {
                const input = document.getElementById("description");
                const value = input.value.trim();
                if (value.length > 255) {
                    showError(input, "Mô tả không vượt quá 255 ký tự.");
                    return false;
                } else if (/<[^>]+>/.test(value)) {
                    showError(input, "Không được chứa thẻ HTML.");
                    return false;
                } else {
                    hideError(input);
                    return true;
                }
            }

            function validatePrice() {
                const input = document.getElementById("price");
                const value = input.value.trim();
                if (value === "" || !/^\d+$/.test(value)) {
                    showError(input, "Giá phải là số nguyên không âm.");
                    return false;
                } else {
                    hideError(input);
                    return true;
                }
            }

            function validateForm() {
                const valid1 = validateServiceName();
                const valid2 = validateDescription();
                const valid3 = validatePrice();
                return valid1 && valid2 && valid3;
            }

            document.getElementById("createServiceForm").addEventListener("submit", function (e) {
                if (!validateForm()) {
                    e.preventDefault();
                    alert("Vui lòng kiểm tra lại các trường bị lỗi.");
                }
            });

            document.getElementById("serviceName").addEventListener("input", validateServiceName);
            document.getElementById("description").addEventListener("input", validateDescription);
            document.getElementById("price").addEventListener("input", validatePrice);
        </script>
    </body>
</html>