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
    </head>
    <body class="p-4 bg-light">
        <h3 class="mb-4 text-primary"><i class="fas fa-chart-bar"></i> Thống kê Đặt lịch</h3>
        <div class="mb-4">
            <h5>Tổng lượt đặt lịch: <span class="text-success">${total}</span></h5>
        </div>
        <div class="row">
            <div class="col-md-6">
                <table class="table table-bordered table-hover">
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
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <canvas id="appointmentChart"></canvas>
            </div>
        </div>

        <script>
            const chartData = {
                labels: [<c:forEach var="entry" items="${stats}" varStatus="loop">${loop.index > 0 ? ',' : ''}"${entry.key}"</c:forEach>],
                        datasets: [{
                                label: 'Số lượt',
                                data: [<c:forEach var="entry" items="${stats}" varStatus="loop">${loop.index > 0 ? ',' : ''}${entry.value}</c:forEach>],
                                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545']
                            }]
            };

            new Chart(document.getElementById('appointmentChart'), {
                type: 'pie',
                data: chartData
            });
        </script>
    </body>
</html>