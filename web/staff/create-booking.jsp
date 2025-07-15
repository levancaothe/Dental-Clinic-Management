<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Service" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.ServiceDAO" %>
<!DOCTYPE html>
<%
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
    UserDAO userDao = new UserDAO();
    ServiceDAO serviceDao = new ServiceDAO();
    List<User> doctors = userDao.getUsersByDefaultOrder("Bác sĩ");
    List<User> customers = userDao.getUsersByDefaultOrder("Khách hàng");
    List<Service> services = serviceDao.getAllServices();
    
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String selectedCustomer = String.valueOf(request.getAttribute("customerId"));
    String selectedDoctor = String.valueOf(request.getAttribute("doctorId"));
    String selectedService = String.valueOf(request.getAttribute("serviceId"));
    String noteValue = request.getAttribute("note") != null ? request.getAttribute("note").toString() : "";
    String appointmentDateValue = request.getAttribute("appointmentDate") != null ? request.getAttribute("appointmentDate").toString() : "";
    String appointmentId = request.getAttribute("appointmentId") != null ? request.getAttribute("appointmentId").toString() : null;
    
    String status = request.getAttribute("status") != null ? request.getAttribute("status").toString() : "";
    String date = request.getAttribute("date") != null ? request.getAttribute("date").toString() : "";
    String sortBy = request.getAttribute("sortBy") != null ? request.getAttribute("sortBy").toString() : "";
    String keyword = request.getAttribute("keyword") != null ? request.getAttribute("keyword").toString() : "";
    String pageNumber = request.getAttribute("page") != null ? request.getAttribute("page").toString() : "1";
    
    // Tạo url quay lại trang danh sách, giữ các tham số filter/sort/page
    String redirectUrl = "ViewBookingServlet"
        + "?status=" + java.net.URLEncoder.encode(status, "UTF-8")
        + "&date=" + java.net.URLEncoder.encode(date, "UTF-8")
        + "&sortBy=" + java.net.URLEncoder.encode(sortBy, "UTF-8")
        + "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8")
        + "&page=" + java.net.URLEncoder.encode(pageNumber, "UTF-8");
%>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đặt lịch khám</title>
        <link href="./css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
            .error-message {
                color: red;
                text-align: center;
                margin-top: 10px;
                font-weight: bold;
                white-space: pre-line;
            }
            .success-message {
                color: green;
                text-align: center;
                margin-top: 10px;
                font-weight: bold;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                font-weight: 600;
                display: block;
                margin-bottom: 5px;
                color: #333;
            }
            .readonly-field {
                background: #f7f7f7;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                color: #444;
                font-size: 15px;
            }
            .readonly-field.note {
                white-space: pre-wrap;
                max-height: 100px;
                overflow-y: auto;
            }
            select {
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 15px;
                width: 100%;
            }
            .buttons {
                display: flex;
                gap: 12px;
                margin-top: 20px;
            }
            .btn-r {
                text-decoration: none;
                padding: 10px 18px;
                border-radius: 6px;
                border: 1px solid #64ccff;
                color: #64ccff;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                cursor: pointer;
                background: none;
                font-weight: 600;
            }
            .btn-r:hover {
                background-color: #64ccff;
                color: white;
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
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="<%= dashboardUrl %>" class="logo-link">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="<%= redirectUrl %>" class="btn-r">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="<%= dashboardUrl %>" class="btn-r">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>
        <div class="content">
            <div class="form-container">
                <div class="header">Xếp Bác Sĩ</div>
                <div class="form-body">
                    <% if (error != null) { %>
                    <div class="error-message"><%= error %></div>
                    <% } %>
                    <% if (success != null) { %>
                    <div class="success-message"><%= success %></div>
                    <div style="text-align: center; margin-top: 15px;">
                        <a href="<%= redirectUrl %>" class="btn" style="background-color: #64ccff; color: white; padding: 10px 18px; border-radius: 6px; text-decoration: none;">
                            <i class="fas fa-list"></i> Xem danh sách lịch khám
                        </a>
                    </div>
                    <% } else { %>
                    <form action="CreateBookingServlet" method="post" onsubmit="return validateNote();">
                        <% if (appointmentId != null) { %>
                        <input type="hidden" name="appointmentId" value="<%= appointmentId %>"/>
                        <% } %>
                        <input type="hidden" name="status" value="<%= status %>"/>
                        <input type="hidden" name="date" value="<%= date %>"/>
                        <input type="hidden" name="sortBy" value="<%= sortBy %>"/>
                        <input type="hidden" name="keyword" value="<%= keyword %>"/>
                        <input type="hidden" name="page" value="<%= pageNumber %>"/>
                        <div class="form-group">
                            <label>Bệnh nhân:</label>
                            <input type="hidden" name="customerId" value="<%= selectedCustomer %>"/>
                            <div class="readonly-field">
                                <%= userDao.getUserById(Integer.parseInt(selectedCustomer)).getFullName() %>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="doctorId">Bác sĩ:</label>
                            <select name="doctorId" id="doctorId" required>
                                <option value="">-- Chọn bác sĩ --</option>
                                <% for (User u : doctors) { %>
                                <option value="<%= u.getUserId() %>" <%= String.valueOf(u.getUserId()).equals(selectedDoctor) ? "selected" : "" %>>
                                    <%= u.getFullName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Dịch vụ:</label>
                            <input type="hidden" name="serviceId" value="<%= selectedService %>"/>
                            <div class="readonly-field">
                                <%= serviceDao.getServiceById(Integer.parseInt(selectedService)).getServiceName() %>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Ngày khám:</label>
                            <input type="hidden" name="appointmentDate" value="<%= appointmentDateValue %>"/>
                            <div class="readonly-field">
                                <%= appointmentDateValue.replace('T', ' ') %>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Ghi chú:</label>
                            <input type="hidden" name="note" value="<%= noteValue %>"/>
                            <div class="readonly-field note">
                                <%= noteValue %>
                            </div>
                        </div>
                        <div class="buttons">
                            <button type="submit" class="btn">Xác nhận</button>
                            <a href="<%= redirectUrl %>" class="btn-r">Huỷ</a>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>
        <script>
            function validateNote() {
                let noteInput = document.querySelector('input[name="note"]');
                if (!noteInput)
                    return true;
                let note = noteInput.value.trim();
                if (note === '')
                    return true;
                if (note.length > 255) {
                    alert("Ghi chú không được vượt quá 255 ký tự.");
                    return false;
                }
                if (/^[^a-zA-Z0-9]/.test(note)) {
                    alert("Ghi chú không được bắt đầu bằng ký tự đặc biệt.");
                    return false;
                }
                if (/<[^>]*>/.test(note)) {
                    alert("Không được nhập thẻ HTML vào ghi chú.");
                    return false;
                }
                if (!/[a-zA-Z]/.test(note.charAt(0))) {
                    alert("Ghi chú phải bắt đầu bằng chữ cái.");
                    return false;
                }
                if (/(.)\1\1/.test(note)) {
                    alert("Không được nhập 3 ký tự giống nhau liên tiếp trong ghi chú.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>