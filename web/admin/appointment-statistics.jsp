<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map" %>
<%
    int total = (int) request.getAttribute("total");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thống kê đặt lịch</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            h3 {
                font-weight: bold;
            }
            .filter-form {
                background-color: #ffffff;
                border: 1px solid #dee2e6;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
            }
            .table-container {
                background-color: #ffffff;
                border-radius: 10px;
                padding: 15px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
            }
            canvas {
                background-color: #ffffff;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
            }
            .form-label {
                font-weight: 500;
            }
            #dateError {
                color: red;
                font-size: 0.9rem;
                padding-top: 5px;
                margin-bottom: 0;
                display: block;
                clear: both;
            }
            #noDataMessage {
                background-color: #ffffff;
                padding: 15px;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
                height: 300px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-style: italic;
                color: #888;
            }
        </style>
    </head>
    <body class="container py-4">
        <h3 class="mb-4 text-primary"><i class="fas fa-chart-bar"></i> Thống kê Đặt lịch</h3>

        <div class="mb-3">
            <h5>Tổng lượt đặt lịch: <span class="text-success">${total}</span></h5>
        </div>

        <!-- Form lọc theo ngày -->
        <form method="get" action="AppointmentStatisticsServlet" class="filter-form row g-3 align-items-end" onsubmit="return validateDateRange()">
            <div class="col-md-4">
                <label class="form-label">Ngày bắt đầu</label>
                <input type="date" id="fromDate" name="fromDate" value="${param.fromDate}" class="form-control">
            </div>
            <div class="col-md-4">
                <label class="form-label">Ngày kết thúc</label>
                <input type="date" id="toDate" name="toDate" value="${param.toDate}" class="form-control">
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-primary w-100">Lọc theo thời gian</button>
                <div id="dateError"></div>
            </div>
        </form>

        <div class="row mt-4">
            <!-- Bảng thống kê -->
            <div class="col-md-6">
                <div class="table-container">
                    <table class="table table-bordered table-hover mb-0">
                        <thead class="table-info">
                            <tr>
                                <th>Trạng thái</th>
                                <th>Số lượt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${stats}">
                                <tr>
                                    <td>${entry.key}</td>
                                    <td>${entry.value}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty stats}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted">Không có dữ liệu trong khoảng thời gian được chọn.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Biểu đồ hoặc thông báo -->
            <div class="col-md-6">
                <c:choose>
                    <c:when test="${empty stats}">
                        <div id="noDataMessage">
                            Không có dữ liệu để hiển thị biểu đồ.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <canvas id="appointmentChart" height="300"></canvas>
                        </c:otherwise>
                    </c:choose>
            </div>
        </div>

        <!-- Chart Script -->
        <c:if test="${not empty stats}">
            <script>
                const chartData = {
                labels: [
                <c:forEach var="entry" items="${stats}" varStatus="loop">
                "${entry.key}"<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
                ],
                        datasets: [{
                        label: 'Số lượt',
                                data: [
                <c:forEach var="entry" items="${stats}" varStatus="loop">
                    ${entry.value}<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
                                ],
                                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545', '#6f42c1', '#20c997']
                        }]
                };
                new Chart(document.getElementById('appointmentChart'), {
                type: 'pie',
                        data: chartData,
                        options: {
                        plugins: {
                        legend: {
                        position: 'bottom'
                        }
                        }
                        }
                });
            </script>
        </c:if>

        <!-- Validate ngày -->
        <script>
            function validateDateRange() {
            const from = document.getElementById('fromDate').value;
            const to = document.getElementById('toDate').value;
            const error = document.getElementById('dateError');
            error.textContent = '';
            if (from && to && from > to) {
            error.textContent = 'Ngày bắt đầu không được lớn hơn ngày kết thúc';
            return false;
            }
            return true;
            }
        </script>
    </body>
</html>
