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
                max-width: 250px;
                margin: 0 auto 20px;
            }

            .form-select {
                padding: 6px 10px;
                border: 1px solid #64ccff;
                border-radius: 6px;
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

        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="doctor/dashboard.jsp">
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
                <h2>Lịch khám sắp tới của bạn</h2>

                <form method="get" action="DoctorScheduleServlet" class="filter-form">
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="">Tất cả</option>
                        <option value="0" ${selectedStatus == '0' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="1" ${selectedStatus == '1' ? 'selected' : ''}>Hoàn tất</option>
                        <option value="2" ${selectedStatus == '2' ? 'selected' : ''}>Đã huỷ</option>
                    </select>
                </form>

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
                                <td colspan="5" class="no-appointments">Không có lịch khám nào trong ngày</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <div class="pagination-container">
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="DoctorScheduleServlet?page=1&status=${selectedStatus}">&laquo;</a>
                                <a href="DoctorScheduleServlet?page=${currentPage - 1}&status=${selectedStatus}">Trước</a>
                            </c:if>

                            <c:set var="leftDots" value="false" />
                            <c:set var="rightDots" value="false" />
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                        <a class="${i == currentPage ? 'active' : ''}" href="DoctorScheduleServlet?page=${i}&status=${selectedStatus}">${i}</a>
                                    </c:when>
                                    <c:when test="${i < currentPage - 1 && not leftDots}">
                                        <span>...</span>
                                        <c:set var="leftDots" value="true" />
                                    </c:when>
                                    <c:when test="${i > currentPage + 1 && not rightDots}">
                                        <span>...</span>
                                        <c:set var="rightDots" value="true" />
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="DoctorScheduleServlet?page=${currentPage + 1}&status=${selectedStatus}">Sau</a>
                                <a href="DoctorScheduleServlet?page=${totalPages}&status=${selectedStatus}">&raquo;</a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>
    </body>
</html>