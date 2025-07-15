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
        <title>SmileCare - Dashboard hệ thống</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                background-color: #f9fafe;
                display: flex;
                height: 100vh;
            }
            .sidebar {
                width: 220px;
                background-color: #ffffff;
                padding: 20px;
                border-right: 1px solid #dce0e5;
                box-shadow: 2px 0 6px rgba(0,0,0,0.05);
            }
            .sidebar h2 {
                margin-top: 0;
                color: #007acc;
                font-size: 22px;
                font-weight: bold;
            }
            .sidebar a {
                display: block;
                padding: 12px;
                margin-bottom: 8px;
                color: #333;
                text-decoration: none;
                border-radius: 6px;
                transition: background-color 0.2s ease;
            }
            .sidebar a:hover,
            .sidebar a.active-link {
                background-color: #e6f3ff;
                color: #007acc;
                font-weight: 600;
            }
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .topbar {
                background-color: #d0f0fd;
                padding: 12px 24px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #c0d9e8;
            }
            .topbar img {
                height: 45px;
            }
            .logout-btn {
                background-color: #007acc;
                color: white;
                padding: 8px 16px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }
            .logout-btn:hover {
                background-color: #005f9e;
            }
            iframe {
                flex: 1;
                width: 100%;
                border: none;
            }
            .lo {
                text-decoration: none;
                padding: 5px;
                border: 2px solid #007acc;
                border-radius: 5px;
            }
            .lo:hover {
                background-color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Dashboard</h2>
            <a href="AddUserServlet" target="contentFrame" class="nav-link">➕ Thêm tài khoản</a>
            <a href="ManageAccountStatusServlet" target="contentFrame" class="nav-link">👥 Danh sách nhân sự</a>
            <a href="DashboardOverviewServlet" target="contentFrame" class="nav-link active-link">📊 Thống kê người dùng</a>
            <a href="AppointmentStatisticsServlet" target="contentFrame" class="nav-link">📅 Thống kê đặt lịch</a>
            <a href="ServiceStatisticsServlet" target="contentFrame" class="nav-link">🩺 Thống kê dịch vụ</a>
        </div>

        <div class="main">
            <div class="topbar">
                <div>
                    <img src="https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo">
                </div> 
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span style="font-weight: 500; color: #007acc;">
                        👤 <%= user.getFullName() %>
                    </span>
                    <a class="lo" href="<c:url value='/LogoutServlet'/>">
                        <i class="fas fa-sign-out-alt me-1"></i> Đăng xuất
                    </a>
                </div>
            </div>

            <iframe name="contentFrame" src="DashboardOverviewServlet"></iframe>
        </div>

        <script>
            const links = document.querySelectorAll('.sidebar .nav-link');
            links.forEach(link => {
                link.addEventListener('click', function () {
                    links.forEach(l => l.classList.remove('active-link'));
                    this.classList.add('active-link');
                });
            });
        </script>
    </body>
</html>