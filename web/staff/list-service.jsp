<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Service" %>
<%@ page import="model.User" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    DecimalFormat priceFormat = new DecimalFormat("#,###");
%>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    String message = (String) request.getAttribute("message");
    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
    String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "auto";
%>
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
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Dịch vụ</title>
        <link href="<%= request.getContextPath() %>/css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .action-links {
                display: flex;
                justify-content: center;
                gap: 10px;
            }
            .table-container {
                overflow-x: auto;
                max-width: 1200px;
                margin: auto;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                border-radius: 8px;
                overflow: hidden;
            }
            .table thead {
                background-color: #64ccff;
                color: white;
            }
            .table th, .table td {
                padding: 12px 16px;
                text-align: center;
                border-bottom: 1px solid #eee;
            }
            .table tbody tr:hover {
                background-color: #e0f7ff;
            }
            .header {
                background-color: #fff;
                color: #64ccff;
                padding: 16px;
                font-weight: bold;
                font-size: 1.3rem;
                text-align: center;
                border-radius: 12px 12px 0 0;
            }
            .add-service {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 10px;
            }
            .add-service .btn {
                font-weight: bold;
                color: #0078B4;
                text-decoration: none;
                border: 1px solid #64ccff;
                padding: 8px 16px;
                border-radius: 6px;
                background-color: white;
                transition: all 0.3s ease;
            }
            .add-service .btn:hover {
                background-color: #64ccff;
                color: white;
            }
            .form-body {
                padding: 0;
            }
            .btn-action {
                text-decoration: none;
            }
            .pagination-container {
                margin-top: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 5px;
                flex-wrap: wrap;
            }
            .pagination-container a, .pagination-container span {
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
            @media (max-width: 600px) {
                .add-service {
                    padding: 0 10px;
                }
            }
            .filter-form {
                padding: 10px 20px;
                margin: 10px 20px 0 auto;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 15px;
                flex-wrap: wrap;
                max-width: 1200px;
            }
            .filter-form label {
                font-size: 1rem;
                color: #333;
                font-weight: bold;
            }
            .filter-form select,
            .filter-form input[type="text"] {
                padding: 8px;
                border: 1px solid #0078B4;
                border-radius: 4px;
                font-size: 0.95rem;
            }
            .filter-form button {
                padding: 8px 12px;
                background-color: #64ccff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.95rem;
            }
            .filter-form button:hover {
                background-color: #0078B4;
            }
        </style>
    </head>
    <body>
        <div class="banner">
            <div class="logo-box">
                <a href="<%= dashboardUrl %>">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back"><i class="fas fa-arrow-left"></i></a>
                <a href="<%= dashboardUrl %>" class="btn"><i class="fas fa-home"></i></a>
            </div>
        </div>

        <form method="get" action="ListServiceServlet" class="filter-form">
            <div>
                <label for="keyword">Tìm kiếm:</label>
                <input type="text" name="keyword" id="keyword" value="<%= keyword %>" placeholder="Tên dịch vụ..." />
                <button type="submit">Tìm</button>
            </div>
            <div>
                <label for="sort">Sắp xếp:</label>
                <select name="sort" id="sort" onchange="this.form.submit()">
                    <option value="auto" <%= "auto".equals(sort) ? "selected" : "" %>>Mặc định</option>
                    <option value="name_asc" <%= "name_asc".equals(sort) ? "selected" : "" %>>Tên A-Z</option>
                    <option value="price_asc" <%= "price_asc".equals(sort) ? "selected" : "" %>>Giá tăng dần</option>
                    <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>Giá giảm dần</option>
                </select>
            </div>
        </form>

        <div class="table-container">

            <div class="add-service">
                <a href="CreateServiceServlet" class="btn">+ Thêm dịch vụ</a>
            </div>

            <div class="">
                <div class="header">Danh sách Dịch vụ</div>

                <div class="form-body">
                    <% if (message != null) { %>
                    <div class="error-message" style="text-align:center; color:red; font-weight:bold;">
                        <%= message %>
                    </div>
                    <% } %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên</th>
                                <th>Mô tả</th>
                                <th>Giá (VNĐ)</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int stt = 1;
                                for (Service s : services) {
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td><%= s.getServiceName() %></td>
                                <td><%= s.getDescription() %></td>
                                <td><%= priceFormat.format(s.getPrice().intValue()) %> VNĐ</td>
                                <td><%= s.isStatus() ? "Hoạt động" : "Ngừng" %></td>
                                <td class="action-links">
                                    <a href="EditServiceServlet?id=<%= s.getServiceId() %>" class="btn btn-action"><i class="fas fa-edit"></i></a>
                                    <a href="DeleteServiceServlet?id=<%= s.getServiceId() %>" class="btn-r btn-action"
                                       onclick="return confirm('Xác nhận xóa dịch vụ?');"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <%
                        Integer totalPagesVal = (Integer) request.getAttribute("totalPages");
                        Integer currentPageVal = (Integer) request.getAttribute("currentPage");
                        if (totalPagesVal != null && totalPagesVal > 1) {
                    %>
                    <div class="pagination-container">
                        <% if (currentPageVal > 1) { %>
                        <a href="ListServiceServlet?page=1&keyword=<%= keyword %>&sort=<%= sort %>">&laquo;</a>
                        <a href="ListServiceServlet?page=<%= currentPageVal - 1 %>&keyword=<%= keyword %>&sort=<%= sort %>">Trước</a>
                        <% } %>
                        <%
                            for (int i = 1; i <= totalPagesVal; i++) {
                                if (i == 1 || i == totalPagesVal || (i >= currentPageVal - 1 && i <= currentPageVal + 1)) {
                        %>
                        <a class="<%= (i == currentPageVal) ? "active" : "" %>" href="ListServiceServlet?page=<%= i %>&keyword=<%= keyword %>&sort=<%= sort %>"><%= i %></a>
                        <% } else if (i == currentPageVal - 2 || i == currentPageVal + 2) { %>
                        <span>...</span>
                        <% } } %>
                        <% if (currentPageVal < totalPagesVal) { %>
                        <a href="ListServiceServlet?page=<%= currentPageVal + 1 %>&keyword=<%= keyword %>&sort=<%= sort %>">Sau</a>
                        <a href="ListServiceServlet?page=<%= totalPagesVal %>&keyword=<%= keyword %>&sort=<%= sort %>">&raquo;</a>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>
        <script>
            function onSortChange() {
                const sortValue = document.getElementById('sort').value;
                const keyword = document.getElementById('keyword').value.trim();
                window.location.href = "ListServiceServlet?keyword=" + encodeURIComponent(keyword) + "&sort=" + sortValue;
            }
        </script>
    </body>
</html>