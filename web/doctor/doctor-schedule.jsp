<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRoleId() != 3) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lịch khám sắp tới của bạn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link href="<c:url value='/css/style_k.css'/>" rel="stylesheet"/>
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f7fafd;
                margin: 0;
                padding: 0;
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

            .main-wrapper {
                min-height: calc(100vh - 140px);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }

            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0;
                width: 95%;
                background: none;
                box-shadow: none;
                border-radius: 0;
            }

            h2 {
                text-align: center;
                color: #007acc;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .filter-form {
                margin: 0 auto 20px auto;
                display: flex;
                justify-content: end;
                align-items: flex-end;
                gap: 12px;
                flex-wrap: wrap;
                padding: 15px 20px;
                border-radius: 10px;
            }

            .filter-form label {
                font-size: 0.9rem;
                color: #333;
                font-weight: 500;
                display: block;
                margin-bottom: 5px;
            }

            .filter-form select,
            .filter-form input[type="date"] {
                padding: 6px 10px;
                font-size: 0.9rem;
                border: 1px solid #90d5ec;
                border-radius: 6px;
                background-color: white;
                width: 150px;
            }

            .filter-form button {
                padding: 7px 16px;
                background-color: #42bff5;
                color: white;
                font-weight: 600;
                border: none;
                border-radius: 6px;
                font-size: 0.95rem;
                transition: 0.2s ease-in-out;
            }

            .filter-form button:hover {
                background-color: #0099dd;
            }

            .filter-form div {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }


            button {
                padding: 6px 14px;
                background-color: #64ccff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            button:hover {
                background-color: #56b8e6;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            }

            th, td {
                padding: 12px 14px;
                text-align: center;
                border: 1px solid #ddd;
                vertical-align: middle;
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

            .no-appointments {
                font-style: italic;
                color: #888;
                padding: 20px;
                text-align: center;
            }

            .pagination-container {
                margin-top: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 5px;
                flex-wrap: wrap;
            }

            .pagination-container a,
            .pagination-container span {
                padding: 8px 14px;
                border: 1px solid #64ccff;
                border-radius: 6px;
                color: #64ccff;
                text-decoration: none;
                font-weight: 600;
                transition: 0.3s;
            }

            .pagination-container a:hover {
                background-color: #64ccff;
                color: white;
            }

            .pagination-container a.active {
                background-color: #64ccff;
                color: white;
                pointer-events: none;
            }

            footer {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
            }

            .banner {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #d0f0fd;
                padding: 10px 20px;
            }

            .btn-back, .btn {
                font-size: 20px;
                color: #0078B4;
                padding: 6px 10px;
            }

            .btn:hover, .btn-back:hover {
                color: #005b8f;
            }
        </style>
    </head>
    <body>

        <div class="banner">
            <div class="logo-box">
                <a href="doctor/dashboard.jsp" class="logo-link">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="doctor/dashboard.jsp" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>

        <div class="main-wrapper">
            <div class="container">
                <form method="get" action="DoctorScheduleServlet" class="filter-form">
                    <div>
                        <label for="status">Trạng thái:</label>
                        <select name="status" id="status" class="form-select" onchange="this.form.submit()">
                            <option value="">Tất cả</option>
                            <option value="0" ${selectedStatus == '0' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="1" ${selectedStatus == '1' ? 'selected' : ''}>Hoàn tất</option>
                            <option value="2" ${selectedStatus == '2' ? 'selected' : ''}>Đã huỷ</option>
                        </select>
                    </div>

                    <div>
                        <label for="fromDate">From:</label>
                        <input type="date" name="fromDate" id="fromDate" value="${fromDate}" />
                    </div>

                    <div>
                        <label for="toDate">To:</label>
                        <input type="date" name="toDate" id="toDate" value="${toDate}" />
                    </div>

                    <button type="submit">Tìm kiếm</button>
                </form>

                <h2>Lịch khám sắp tới của bạn</h2>
                <!-- Bảng lịch hẹn -->
                <table>
                    <thead>
                        <tr>
                            <th>Khách hàng</th>
                            <th>Dịch vụ</th>
                            <th>Thời gian</th>
                            <th>Ghi chú</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${appointments}">
                            <tr>
                                <td>${a.customerName}</td>
                                <td>${a.serviceName}</td>
                                <td><fmt:formatDate value="${a.appointmentDate}" pattern="HH:mm dd/MM/yyyy"/></td>
                                <td>${a.note}</td>
                                <td>${a.statusString}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty appointments}">
                            <tr>
                                <td colspan="5" class="no-appointments">Không có lịch khám nào</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pagination-container">
                    <c:if test="${totalPages > 1}">
                        <c:if test="${currentPage > 1}">
                            <a href="DoctorScheduleServlet?page=1&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">&laquo;</a>
                            <a href="DoctorScheduleServlet?page=${currentPage - 1}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">Trước</a>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <a href="DoctorScheduleServlet?page=${i}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}"
                               class="${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="DoctorScheduleServlet?page=${currentPage + 1}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">Sau</a>
                            <a href="DoctorScheduleServlet?page=${totalPages}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">&raquo;</a>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>

        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>

    </body>
</html>
