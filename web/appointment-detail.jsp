<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Appointment, model.User, model.Service, java.text.SimpleDateFormat" %>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi Tiết Lịch Khám</title>
        <link href="./css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .date-time-input {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .form-body label {
                margin-top: 15px;
                display: inline-block;
                width: 200px;
                font-weight: bold;
                text-align: right;
                padding-right: 10px;
            }
            .form-body .value {
                display: inline-block;
                margin-left: 10px;
                color: #333;
                vertical-align: middle;
            }
            .error-message {
                color: red;
                font-size: 0.9rem;
                margin-top: 5px;
                display: none;
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
                <a href="customer/dashboard.jsp" class="btn">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="customer/dashboard.jsp" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>
        <div class="content">
            <div class="form-container">
                <div class="header">Chi Tiết Lịch Khám</div>
                <div class="form-body">
                    <%
                        Appointment appointment = (Appointment) request.getAttribute("appointment");
                        User patient = (User) request.getAttribute("patient");
                        User doctor = (User) request.getAttribute("doctor");
                        Service service = (Service) request.getAttribute("service");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                        if (appointment != null) {
                            String formattedAppointmentDate = sdf.format(appointment.getAppointmentDate());
                    %>
                    <label>Họ tên bệnh nhân:</label><span class="value"><%= patient != null ? patient.getFullName() : "Chưa cập nhật" %></span><br>
                    <label>Giới tính:</label><span class="value"><%= patient != null ? patient.getGender() : "Chưa cập nhật" %></span><br>
                    <label>Ngày/tháng/năm sinh:</label><span class="value"><%= patient != null && patient.getDateOfBirth() != null ? sdf.format(patient.getDateOfBirth()) : "Chưa cập nhật" %></span><br>
                    <label>SĐT:</label><span class="value"><%= patient != null ? patient.getPhoneNumber() : "Chưa cập nhật" %></span><br>
                    <label>Địa chỉ:</label><span class="value"><%= patient != null ? patient.getAddress() : "Chưa cập nhật" %></span><br>
                    <label>Email:</label><span class="value"><%= patient != null ? patient.getEmail() : "Chưa cập nhật" %></span><br>
                    <label>Ngày khám:</label><span class="value"><%= formattedAppointmentDate %></span><br>
                    <label>Dịch vụ:</label><span class="value"><%= service != null ? service.getServiceName() : "Chưa xác định" %></span><br>
                    <label>Trạng thái:</label><span class="value"><%= appointment.getStatusString() %></span><br>
                    <label>Giá cả:</label><span class="value"><%= service != null ? String.format("%.0f VNĐ", service.getPrice().doubleValue()) : "Chưa cập nhật" %></span><br>
                    <label>Họ tên bác sĩ:</label><span class="value"><%= doctor != null ? doctor.getFullName() : "Chưa xác định" %></span><br>
                    <label>Ghi chú:</label><span class="value"><%= appointment.getNote() != null ? appointment.getNote() : "Không có ghi chú" %></span><br>
                    <% } else { %>
                    <p class="error-message" style="display: block;">Không tìm thấy lịch khám.</p>
                    <% } %>
                </div>
            </div>
        </div>
        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>
    </body>
</html>