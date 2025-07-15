<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Service, model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Service service = (Service) request.getAttribute("service");
    User currentUser = (User) session.getAttribute("user");
    String dashboardUrl = "#";
    if (currentUser != null) {
        switch (currentUser.getRoleId()) {
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
        <title>Cập nhật Dịch vụ</title>
        <link href="<%= request.getContextPath() %>/css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            .form-body {
                padding: 20px 30px;
            }
            textarea {
                resize: vertical;
            }
            input[type="number"], input[type="text"], textarea, select {
                width: 100%;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 1rem;
                box-sizing: border-box;
                margin-bottom: 4px;
            }
            .error-message {
                color: red;
                font-size: 0.9em;
                font-weight: 500;
                display: none;
                margin-top: 2px;
                margin-bottom: 10px;
            }
            .error-server {
                color: red;
                font-weight: bold;
                margin-bottom: 15px;
            }
            .buttons {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }
            .btn, .btn-r, .btn-back {
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: bold;
                border: 1px solid #64ccff;
                color: #0078B4;
                background-color: white;
                transition: all 0.3s ease;
            }
            .btn:hover, .btn-back:hover {
                background-color: #64ccff;
                color: white;
            }
            .btn-r:hover {
                background-color: #FF6B6B;
                color: white;
            }
            .banner {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #d0f0fd;
                padding: 10px 20px;
            }
            .banner img {
                height: 50px;
            }
            footer {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
                margin-top: 30px;
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
                <div class="header">Cập nhật Dịch vụ</div>
                <div class="form-body">
                    <c:if test="${not empty error}">
                        <div class="error-server">${error}</div>
                    </c:if>

                    <form action="EditServiceServlet" method="post" id="editServiceForm">
                        <input type="hidden" name="id" value="<%= service.getServiceId() %>">

                        <label for="serviceName">Tên dịch vụ:</label>
                        <input type="text" id="serviceName" name="serviceName" value="<%= service.getServiceName() %>">
                        <span class="error-message" id="serviceNameError"></span>

                        <label for="description">Mô tả:</label>
                        <textarea id="description" name="description" rows="4"><%= service.getDescription() %></textarea>
                        <span class="error-message" id="descriptionError"></span>

                        <label for="price">Giá (VNĐ):</label>
                        <input type="number" id="price" name="price" value="<%= service.getPrice().stripTrailingZeros().toPlainString() %>" min="0" step="1000">
                        <span class="error-message" id="priceError"></span>

                        <label for="status">Trạng thái:</label>
                        <select name="status">
                            <option value="1" <%= service.isStatus() ? "selected" : "" %>>Hoạt động</option>
                            <option value="0" <%= !service.isStatus() ? "selected" : "" %>>Ngừng</option>
                        </select>

                        <div class="buttons">
                            <button type="submit" class="btn">Cập nhật</button>
                            <button type="reset" class="btn-r" onclick="clearErrors()">Huỷ</button>
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
            }
            function hideError(input) {
                const error = document.getElementById(input.id + "Error");
                error.textContent = "";
                error.style.display = "none";
            }
            function clearErrors() {
                ["serviceName", "description", "price"].forEach(id => hideError(document.getElementById(id)));
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
                return validateServiceName() & validateDescription() & validatePrice();
            }
            document.getElementById("editServiceForm").addEventListener("submit", function (e) {
                if (!validateForm()) {
                    e.preventDefault();
                    alert("Vui lòng kiểm tra lại các trường bị lỗi.");
                }
            });
            ["serviceName", "description", "price"].forEach(id => {
                document.getElementById(id).addEventListener("input", () => {
                    switch (id) {
                        case "serviceName":
                            validateServiceName();
                            break;
                        case "description":
                            validateDescription();
                            break;
                        case "price":
                            validatePrice();
                            break;
                    }
                });
            });
        </script>
    </body>
</html>