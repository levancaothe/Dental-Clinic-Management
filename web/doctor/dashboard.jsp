<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>SmileCare - Bảng điều khiển bác sĩ</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="<c:url value='/css/style_s.css'/>">
        <link rel="stylesheet" href="<c:url value='/css/responsive.css'/>">

        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            .page-container {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .content-area {
                flex: 1;
            }

            .dashboard-wrapper {
                max-width: 1000px;
                margin: 80px auto;
                padding: 30px;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                text-align: center;
            }

            .dashboard-header h2 {
                font-family: 'Poppins', sans-serif;
                font-weight: 600;
                color: #007acc;
                margin-bottom: 10px;
            }

            .dashboard-header p {
                color: #555;
                margin-bottom: 30px;
            }

            .dashboard-options {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }

            .dashboard-option {
                flex: 1 1 200px;
                background-color: #e7f6ff;
                border: 1px solid #cce7ff;
                border-radius: 8px;
                padding: 20px;
                transition: 0.3s ease;
                text-decoration: none;
                color: #333;
            }

            .dashboard-option:hover {
                background-color: #d6efff;
                transform: translateY(-3px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            .dashboard-option i {
                font-size: 2rem;
                color: #007acc;
                margin-bottom: 10px;
            }

            .dashboard-option h5 {
                font-size: 1.1rem;
                font-weight: 600;
                margin: 0;
            }

            .topbar {
                background-color: #d0f0fd;
                padding: 12px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
            }

            .topbar .logo img {
                height: 45px;
            }

            .topbar .user-actions {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .topbar .user-actions span {
                font-weight: 500;
                color: #007acc;
            }

            .topbar .user-actions a {
                padding: 6px 12px;
                border: 1px solid #007acc;
                border-radius: 4px;
                text-decoration: none;
                color: #007acc;
                transition: 0.3s;
            }

            .topbar .user-actions a:hover {
                background-color: #007acc;
                color: white;
            }

            .footer-bottom {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
                margin-top: auto;
            }

            @media (max-width: 576px) {
                .dashboard-options {
                    flex-direction: column;
                }

                .topbar {
                    flex-direction: column;
                    gap: 10px;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-container">

            <div class="topbar">
                <div class="logo">
                    <img src="https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="SmileCare Logo">
                </div>
                <div class="user-actions">
                    <span>👨‍⚕️ <%= user.getFullName() %></span>
                    <a href="<c:url value='/LogoutServlet'/>"><i class="fas fa-sign-out-alt me-1"></i> Đăng xuất</a>
                </div>
            </div>

            <div class="dashboard-wrapper content-area">
                <div class="dashboard-header">
                    <h2>Chào mừng Bác sĩ!</h2>
                </div>

                <div class="dashboard-options">
                    <a href="<c:url value='/ViewProfileServlet'/>" class="dashboard-option">
                        <i class="fas fa-user-md"></i>
                        <h5>Thông tin cá nhân</h5>
                    </a>
                    <a href="<c:url value='/UpdateProfileServlet'/>" class="dashboard-option">
                        <i class="fas fa-user-edit"></i>
                        <h5>Chỉnh sửa hồ sơ cá nhân</h5>
                    </a>
                    <a href="<c:url value='/DoctorScheduleServlet'/>" class="dashboard-option">
                        <i class="fas fa-clock"></i>
                        <h5>Lịch khám hôm nay</h5>
                    </a>

                </div>
            </div>

            <footer class="footer-bottom">
                Nụ cười của bạn – Sứ mệnh của chúng tôi.
            </footer>
        </div>
    </body>
</html>
