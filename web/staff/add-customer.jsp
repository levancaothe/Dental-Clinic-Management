<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<!DOCTYPE html>
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
<html>
    <head>
        <title>Thêm tài khoản khách hàng</title>
        <link rel="stylesheet" href="./css/style_k.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .form-container {
                background-color: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                max-width: 700px;
                width: 90%;
                margin: 40px auto;
                overflow: hidden;
                padding: 30px;
            }
            .form-container .header {
                background-color: #64ccff;
                color: white;
                padding: 16px;
                font-weight: bold;
                font-size: 1.3rem;
                text-align: center;
                border-radius: 8px;
                margin-bottom: 25px;
            }
            form input[type="text"],
            form input[type="email"],
            form input[type="password"],
            form input[type="date"],
            form select {
                width: 100%;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 1rem;
                margin-bottom: 16px;
                box-sizing: border-box;
            }
            form button {
                width: 100%;
                background-color: #64ccff;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 6px;
                font-size: 1rem;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            form button:hover {
                background-color: #4db8e6;
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
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="staff/dashboard.jsp" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>
        <div class="form-container">
            <div class="header">Thêm tài khoản khách hàng</div>
            <form action="AddCustomerServlet" method="post">
                <input type="text" name="fullName" placeholder="Họ tên" required><br>
                <input type="email" name="email" placeholder="Email" required><br>
                <input type="password" name="password" placeholder="Mật khẩu" required><br>
                <input type="text" name="phone" placeholder="Số điện thoại"><br>
                <input type="text" name="address" placeholder="Địa chỉ"><br>
                <input type="date" name="dob"><br>
                <select name="gender">
                    <option value="Nam">Nam</option>
                    <option value="Nữ">Nữ</option>
                    <option value="Khác">Khác</option>
                </select><br>
                <button type="submit">Thêm tài khoản</button>
            </form>
        </div>
    </body>
</html>