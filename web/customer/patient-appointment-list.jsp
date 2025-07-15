<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Appointment, dao.UserDAO, dao.ServiceDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointmentList");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String sortOrder = (String) request.getAttribute("sortOrder");
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    
    UserDAO userDao = new UserDAO();
    ServiceDAO serviceDao = new ServiceDAO();
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch hẹn của tôi</title>
        <link rel="stylesheet" href="css/style_k.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            body {
                overflow-x: hidden;
                margin: 0;
                padding: 0;
                max-width: 100vw;
            }
            .page-wrapper {
                width: 100%;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content {
                flex: 1;
            }
            .table-container {
                max-width: 1000px;
                margin: 30px auto;
                background-color: #fff;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            .header {
                background-color: white;
                color: #64ccff;
                padding: 16px;
                font-weight: bold;
                font-size: 1.3rem;
                text-align: center;
                border-radius: 10px 10px 0 0;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            th, td {
                padding: 10px 12px;
                text-align: center;
                border: 1px solid #ddd;
                vertical-align: top;
            }
            th {
                background-color: #64ccff;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #e0f7ff;
            }
            .btn {
                background-color: white;
                color: #64ccff;
                border-color: #64ccff;
                text-decoration: none;
            }
            .banner {
                background-color: #d0f0fd;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            }
            .banner img {
                width: 60px;
                height: 60px;
                object-fit: contain;
            }
            .banner a:not(.logo-box a) {
                font-weight: bold;
                color: #0078B4;
                text-decoration: none;
                border: 1px solid #64ccff;
                padding: 8px 16px;
                border-radius: 8px;
                background-color: white;
                transition: all 0.3s ease;
            }
            .banner a:not(.logo-box a):hover {
                background-color: #64ccff;
                color: white;
            }
            .action-buttons {
                display: flex;
                gap: 8px;
                justify-content: center;
                align-items: center;
                flex-wrap: nowrap;
            }
            .action-buttons a.btn {
                display: inline-block;
                padding: 6px 12px;
                width: auto;
                white-space: nowrap;
                border-radius: 6px;
                font-size: 0.9rem;
            }
            .pagination {
                margin-top: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 5px;
                flex-wrap: wrap;
            }

            .pagination a, .pagination span {
                padding: 8px 14px;
                border: 1px solid #64ccff;
                border-radius: 6px;
                color: #64ccff;
                text-decoration: none;
                font-weight: 600;
                transition: 0.3s;
            }

            .pagination a:hover {
                background-color: #64ccff;
                color: white;
            }

            .pagination a.active {
                background-color: #64ccff;
                color: white;
                pointer-events: none;
            }
            td.note-column {
                word-break: break-word;
                white-space: pre-wrap;
                max-width: 200px;
            }
            footer {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
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

            .filter-container {
                width: 100%;
                padding: 10px 30px 0 30px;
                display: flex;
                justify-content: flex-end;
            }

            .filter-form {
                margin: 0;
                display: flex;
                align-items: flex-end;
                gap: 15px;
                flex-wrap: wrap;
            }

            .filter-item {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .filter-item label {
                font-weight: bold;
                font-size: 0.9rem;
                color: #333;
            }

            .filter-item select,
            .filter-item input[type="date"] {
                padding: 6px 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                width: 140px;
            }

            .filter-item.button-item {
                align-self: flex-end;
            }

            .filter-item .btn {
                padding: 8px 14px;
                font-weight: bold;
                background-color: #64ccff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                width: 100%;
            }

            .filter-item .btn:hover {
                background-color: #0099cc;
            }
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                padding: 0;
                overflow-x: hidden;
            }

            .banner, footer {
                width: 100vw;
                box-sizing: border-box;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">           
            <div class="banner">
                <div class="logo-box">
                    <a href="customer/dashboard.jsp">
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

                <div class="filter-container">
                    <form class="filter-form" action="PatientAppointmentListServlet" method="get">
                        <div class="filter-item">
                            <label for="sortOrder">Sắp xếp:</label>
                            <select name="sortOrder" onchange="this.form.submit()">
                                <option value="">Mặc định</option>
                                <option value="asc" <%= "asc".equals(sortOrder) ? "selected" : "" %>>Cũ Nhất</option>
                                <option value="desc" <%= "desc".equals(sortOrder) ? "selected" : "" %>>Mới Nhất</option>
                            </select>
                        </div>
                        <div class="filter-item">
                            <label for="status">Trạng thái:</label>
                            <select name="status" onchange="this.form.submit()">
                                <option value="">Tất cả</option>
                                <option value="0" <%= "0".equals(statusFilter) ? "selected" : "" %>>Đang xử lý</option>
                                <option value="1" <%= "1".equals(statusFilter) ? "selected" : "" %>>Hoàn tất</option>
                                <option value="2" <%= "2".equals(statusFilter) ? "selected" : "" %>>Đã huỷ</option>
                            </select>
                        </div>
                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" name="fromDate" value="<%= fromDate != null ? fromDate : "" %>">
                        </div>
                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" name="toDate" value="<%= toDate != null ? toDate : "" %>">
                        </div>
                        <div class="filter-item button-item">
                            <button type="submit" class="btn">Lọc</button>
                        </div>
                    </form>
                </div>

                <div class="table-container">
                    <div class="header">Lịch hẹn của tôi</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày khám</th>
                                <th>Dịch vụ</th>
                                <th>Bác sĩ</th>
                                <th>Trạng thái</th>
                                <th>Ghi chú</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (appointments != null && !appointments.isEmpty()) {
                                    for (Appointment a : appointments) {
                                        String serviceName = serviceDao.getServiceById(a.getServiceId()).getServiceName();
                                        String doctorName = (a.getDoctorId() > 0)
                                            ? userDao.getUserById(a.getDoctorId()).getFullName()
                                            : "Chưa xếp";
                                        String statusText = "";
                                        switch (a.getStatus()) {
                                            case 0: statusText = "Đang xử lý"; break;
                                            case 1: statusText = "Hoàn tất"; break;
                                            case 2: statusText = "Đã huỷ"; break;
                                            default: statusText = "Không xác định"; break;
                                        }
                            %>
                            <tr>
                                <td><%= df.format(a.getAppointmentDate()) %></td>
                                <td><%= serviceName %></td>
                                <td><%= doctorName %></td>
                                <td><%= statusText %></td>
                                <td class="note-column"><%= a.getNote() != null ? a.getNote() : "" %></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="PatientEditBookingServlet?id=<%= a.getAppointmentId() %>" class="btn">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="AppointmentDetailServlet?id=<%= a.getAppointmentId() %>" class="btn">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6">Bạn chưa có lịch hẹn nào.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>

                    <div class="pagination">
                        <%
                            if (totalPages > 1) {
                                int visiblePages = 5;
                                boolean leftDots = false, rightDots = false;
                                if (currentPage > 1) {
                        %>
                        <a href="PatientAppointmentListServlet?page=1">&laquo;</a>
                        <a href="PatientAppointmentListServlet?page=<%= currentPage - 1 %>">Trước</a>
                        <%
                                }
                                for (int i = 1; i <= totalPages; i++) {
                                    if (i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                        %>
                        <a href="PatientAppointmentListServlet?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                        <%
                                    } else if (!leftDots && i < currentPage - 1) {
                                        leftDots = true;
                        %>
                        <span>...</span>
                        <%
                                    } else if (!rightDots && i > currentPage + 1) {
                                        rightDots = true;
                        %>
                        <span>...</span>
                        <%
                                    }
                                }
                                if (currentPage < totalPages) {
                        %>
                        <a href="PatientAppointmentListServlet?page=<%= currentPage + 1 %>">Sau</a>
                        <a href="PatientAppointmentListServlet?page=<%= totalPages %>">&raquo;</a>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
            <footer>
                Nụ cười của bạn – Sứ mệnh của chúng tôi!
            </footer>
        </div>
    </body>
</html>