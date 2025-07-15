<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Integer unreadCount = (Integer) session.getAttribute("unreadCount");
    if (unreadCount == null) unreadCount = 0;
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>SmileCare - Bảng điều khiển nhân viên</title>
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
                background-color: #f0f8ff;
                border: 1px solid #cce7ff;
                border-radius: 8px;
                padding: 20px;
                transition: 0.3s ease;
                text-decoration: none;
                color: #333;
            }
            .dashboard-option:hover {
                background-color: #e6f3ff;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                transform: translateY(-3px);
            }
            .dashboard-option i {
                font-size: 2rem;
                color: #007acc;
                margin-bottom: 10px;
            }
            .dashboard-option h5 {
                margin: 0;
                font-size: 1.1rem;
                font-weight: 600;
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
            }

            .notification-icon .badge {
                position: absolute;
                top: 0;
                right: -6px;
                background: red;
                color: white;
                font-size: 10px;
                padding: 3px 6px;
                border-radius: 50%;
            }
            .dropdown-item.unread {
                font-weight: bold;
                background-color: #eaf6ff;
            }
            .dropdown-item.read {
                color: #666;
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
            #notificationContent::-webkit-scrollbar {
                width: 6px;
            }
            #notificationContent::-webkit-scrollbar-thumb {
                background-color: rgba(0, 0, 0, 0.2);
                border-radius: 3px;
            }
            .dropdown-item:active {
                background-color: #eaf6ff !important;
                color: #000 !important;
            }
            .dropdown-item:hover {
                background-color: #f2f9ff;
                cursor: pointer;
            }
            td.buttons {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                min-width: 280px;
                height: 100%;
            }

            td.buttons a {
                flex: 1;
                text-align: center;
            }

            td.buttons .btn {
                width: 100%;
                min-width: 90px;
                padding: 6px 10px;
                font-size: 13px;
            }

            .table tbody td {
                height: 60px;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="page-container">
            <div class="topbar">
                <div class="logo">
                    <a href="<c:url value='/staff/dashboard.jsp'/>">
                        <img src="https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="SmileCare Logo">
                    </a>
                </div>
                <div class="user-actions">
                    <span>👩‍⚕️ <%= user.getFullName() %></span>
                    <div class="dropdown position-relative">
                        <a class="btn dropdown-toggle notification-icon" href="#" id="notiDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-bell fa-lg"></i>
                            <% if (unreadCount > 0) { %>
                            <span class="badge"><%= unreadCount %></span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end"
                            id="notificationContent"
                            style="min-width:300px; max-height:300px; overflow-y:auto;"
                            aria-labelledby="notiDropdown">
                            <li class="dropdown-item text-muted">Đang tải...</li>
                        </ul>
                    </div>
                    <a href="<c:url value='/LogoutServlet'/>"><i class="fas fa-sign-out-alt me-1"></i> Đăng xuất</a>
                </div>
            </div>

            <div class="dashboard-wrapper content-area">
                <div class="dashboard-header">
                    <h2>Bảng điều khiển nhân viên</h2>
                </div>
                <div class="dashboard-options">
                    <a href="<c:url value='/ViewBookingServlet'/>" class="dashboard-option">
                        <i class="fas fa-calendar-alt"></i>
                        <h5>Quản lý lịch khám</h5>
                    </a>
                    <a href="<c:url value='/ViewCustomerAccountServlet'/>" class="dashboard-option">
                        <i class="fas fa-users"></i>
                        <h5>Quản lý tài khoản bệnh nhân</h5>
                    </a>
                    <a href="<c:url value='/ViewProfileServlet'/>" class="dashboard-option">
                        <i class="fas fa-user-cog"></i>
                        <h5>Xem hồ sơ cá nhân</h5>
                    </a>
                    <a href="<c:url value='/UpdateProfileServlet'/>" class="dashboard-option">
                        <i class="fas fa-user-edit"></i>
                        <h5>Chỉnh sửa hồ sơ cá nhân</h5>
                    </a>
                    <a href="<c:url value='/ListServiceServlet'/>" class="dashboard-option">
                        <i class="fas fa-tooth"></i>
                        <h5>Quản lý dịch vụ</h5>
                    </a>

                </div>
            </div>

            <footer class="footer-bottom">
                Nụ cười của bạn – Sứ mệnh của chúng tôi.
            </footer>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function updateBadgeCount() {
                fetch("<c:url value='/NotificationUnreadCountServlet'/>")
                        .then(res => res.text())
                        .then(count => {
                            const icon = document.querySelector(".notification-icon");
                            const badge = icon.querySelector(".badge");
                            if (badge)
                                badge.remove();
                            if (parseInt(count) > 0) {
                                const span = document.createElement("span");
                                span.className = "badge";
                                span.textContent = count;
                                icon.appendChild(span);
                            }
                        });
            }

            document.getElementById("notiDropdown").addEventListener("click", function (event) {
                event.stopPropagation();
                fetch("<c:url value='/NotificationDropdownServlet'/>")
                        .then(res => res.text())
                        .then(data => {
                            const dropdown = document.getElementById("notificationContent");
                            dropdown.innerHTML = data;
                            document.querySelectorAll('.noti-item').forEach(item => {
                                item.addEventListener('click', function (event) {
                                    event.stopPropagation();
                                    const id = this.dataset.id;
                                    fetch("<c:url value='/MarkNotificationReadServlet'/>", {
                                        method: 'POST',
                                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                        body: "id=" + id
                                    }).then(() => {
                                        this.classList.remove('unread');
                                        this.classList.add('read');
                                        updateBadgeCount();
                                    });
                                });
                            });
                        });
                    });

            document.addEventListener("click", function () {
                const dropdown = document.getElementById("notiDropdown");
                const bsDropdown = bootstrap.Dropdown.getInstance(dropdown);
                if (bsDropdown)
                    bsDropdown.hide();
            });

            document.addEventListener("DOMContentLoaded", updateBadgeCount);
        </script>
    </body>
</html>