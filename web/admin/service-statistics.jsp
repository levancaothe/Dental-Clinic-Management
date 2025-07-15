<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, Integer> statusCounts = (Map<String, Integer>) request.getAttribute("statusCounts");
    int activeCount = statusCounts != null ? statusCounts.getOrDefault("active", 0) : 0;
    int inactiveCount = statusCounts != null ? statusCounts.getOrDefault("inactive", 0) : 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thống kê dịch vụ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body class="p-4 bg-light">
        <h3 class="mb-4 text-primary"><i class="fas fa-chart-bar"></i> Thống kê Dịch vụ</h3>

        <div class="row">
            <div class="col-md-6">
                <table class="table table-bordered table-hover">
                    <thead class="table-info">
                        <tr>
                            <th>Tên dịch vụ</th>
                            <th>Số lượt được đặt</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${statsFull}">
                            <tr>
                                <td>${item.name}</td>
                                <td>${item.count}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status}">Đang hoạt động</c:when>
                                        <c:otherwise>Ngừng hoạt động</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <canvas id="serviceChart"></canvas>
            </div>
        </div>

        <script>
            const chartData = {
            labels: [
            <c:forEach var="item" items="${statsFull}" varStatus="loop">
                ${loop.index > 0 ? ',' : ''}"${item.name}"
            </c:forEach>
            ],
                    datasets: [{
                    label: 'Số lượt đặt',
                            data: [
            <c:forEach var="item" items="${statsFull}" varStatus="loop">
                ${loop.index > 0 ? ',' : ''}${item.count}
            </c:forEach>
                            ],
                            backgroundColor: '#0d6efd'
                    }]
            };
            new Chart(document.getElementById('serviceChart'), {
            type: 'bar',
                    data: chartData,
                    options: {
                    indexAxis: 'y',
                            responsive: true,
                            plugins: {
                            legend: { display: false }
                            }
                    }
            });
        </script>
    </body>
</html>