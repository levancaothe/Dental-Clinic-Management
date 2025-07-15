<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="utils.AuthUtil" %>
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
<%
    User user = (User) session.getAttribute("user");
%>
<%
    Integer totalPagesVal = (Integer) request.getAttribute("totalPages");
    Integer currentPageVal = (Integer) request.getAttribute("currentPage");
    String searchVal = (String) request.getAttribute("search");
    String sortByVal = (String) request.getAttribute("sortBy");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông tin khách hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="./css/style_k.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .banner {
                justify-content: space-between;
                align-items: center;
                padding: 15px 30px;
                flex-wrap: wrap;
                gap: 10px;
            }


            .banner .search-sort-container {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-left: auto;
            }

            .banner .search-form, .banner .sort-form {
                display: flex;
                align-items: center;
            }

            .banner .search-form {
                order: 2;
            }

            .banner .sort-form {
                order: 3;
            }

            .banner a {
                order: 4;
                margin-left: 10px;
            }

            .banner .search-form input {
                flex: 1;
                min-width: 200px;
                border-radius: 6px;
                border: 1px solid #ccc;
                padding: 8px;
            }

            .banner .search-form button {
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: 600;
            }

            .banner .sort-form select {
                padding: 8px 16px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-weight: 600;
            }

            .bn{
                display: flex;
                gap: 10px;
                justify-content: end;
                margin-right: 2%;
                margin-top: 15px;
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
        </style>
    </head>
    <body>
        <% 
            if (request.getAttribute("customerList") == null) {
                response.sendRedirect(request.getContextPath() + "/ViewCustomerAccountServlet?page=1");
                return;
            }
        %>

        <div class="banner">
            <div class="logo-box">
                <a href="<%= dashboardUrl %>">
                    <img src="https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474089BGn/mau-logo-rang-vang-tach-nen_045001529.png" alt="Logo"/>
                </a>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="<%= dashboardUrl %>" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>

        <div class="bn">
            <div class="search-form">
                <form action="ViewCustomerAccountServlet" method="post">
                    <input type="hidden" name="page" value="1"/>
                    <input type="text" name="search" placeholder="Tìm kiếm theo tên hoặc email" value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>"/>
                    <button type="submit">Tìm kiếm</button>
                </form>
            </div>

            <div class="sort-form">
                <form action="ViewCustomerAccountServlet" method="post">
                    <input type="hidden" name="page" value="1"/>
                    <input type="hidden" name="search" value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>"/>
                    <select name="sortBy" onchange="this.form.submit()">
                        <option value="default" <%= "default".equals(request.getAttribute("sortBy")) ? "selected" : "" %>>Xếp Tự Động</option>
                        <option value="name" <%= "name".equals(request.getAttribute("sortBy")) ? "selected" : "" %>>Xếp Theo Tên</option>
                    </select>
                </form>
            </div>
        </div>   

        <div class="content">
            <div class="table-container">
                <div style="margin: 15px 0px 10px auto; display: flex; justify-content: flex-end;">
                    <a href="AddCustomerServlet">
                        <button class="btn btn-success">+ Thêm tài khoản khách hàng</button>
                    </a>
                </div>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên Khách hàng</th>
                            <th>Giới tính</th>
                            <th>Ngày sinh</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Địa chỉ</th>
                            <th>Tùy chọn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<User> customerList = (List<User>) request.getAttribute("customerList");
                            Integer currentPage = (Integer) request.getAttribute("currentPage");
                            Integer totalPages = (Integer) request.getAttribute("totalPages");
                            Integer pageSize = (Integer) request.getAttribute("pageSize");
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                            if (customerList == null || customerList.isEmpty()) { 
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center;">Không có dữ liệu khách hàng.</td>
                        </tr>
                        <% 
                            } else {
                                int stt = (currentPage != null && pageSize != null) ? (currentPage - 1) * pageSize + 1 : 1;
                                for (User u : customerList) { 
                        %>
                        <tr>
                            <td><%= stt++ %></td>
                            <td><%= u.getFullName() != null ? u.getFullName() : "" %></td>
                            <td><%= u.getGender() != null ? u.getGender() : "" %></td>
                            <td><%= u.getDateOfBirth() != null ? dateFormat.format(u.getDateOfBirth()) : "" %></td>
                            <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
                            <td><%= u.getPhoneNumber() != null ? u.getPhoneNumber() : "" %></td>
                            <td><%= u.getAddress() != null ? u.getAddress() : "" %></td>
                            <td>
                                <a class="btn" href="EditCustomerServlet?id=<%= u.getUserId() %>">
                                    <i class="fas fa-edit"></i>
                                </a>
                            </td>
                        </tr>
                        <% 
                                }
                            } 
                        %>
                    </tbody>
                </table>
            </div>

            <div class="pagination-container">
                <%
                    if (totalPagesVal != null && totalPagesVal > 0) {
                        if (currentPageVal > 1) {
                %>
                <a href="ViewCustomerAccountServlet?page=1&search=<%= searchVal != null ? searchVal : "" %>&sortBy=<%= sortByVal != null ? sortByVal : "default" %>">&laquo;</a>
                <a href="ViewCustomerAccountServlet?page=<%= currentPageVal - 1 %>&search=<%= searchVal != null ? searchVal : "" %>&sortBy=<%= sortByVal != null ? sortByVal : "default" %>">Trước</a>
                <%
                        }

                        boolean leftDots = false, rightDots = false;
                        for (int i = 1; i <= totalPagesVal; i++) {
                            if (i == 1 || i == totalPagesVal || (i >= currentPageVal - 1 && i <= currentPageVal + 1)) {
                %>
                <a class="<%= (i == currentPageVal) ? "active" : "" %>" href="ViewCustomerAccountServlet?page=<%= i %>&search=<%= searchVal != null ? searchVal : "" %>&sortBy=<%= sortByVal != null ? sortByVal : "default" %>"><%= i %></a>
                <%
                            } else if (!leftDots && i < currentPageVal - 1) {
                                leftDots = true;
                %>
                <span>...</span>
                <%
                            } else if (!rightDots && i > currentPageVal + 1) {
                                rightDots = true;
                %>
                <span>...</span>
                <%
                            }
                        }

                        if (currentPageVal < totalPagesVal) {
                %>
                <a href="ViewCustomerAccountServlet?page=<%= currentPageVal + 1 %>&search=<%= searchVal != null ? searchVal : "" %>&sortBy=<%= sortByVal != null ? sortByVal : "default" %>">Sau</a>
                <a href="ViewCustomerAccountServlet?page=<%= totalPagesVal %>&search=<%= searchVal != null ? searchVal : "" %>&sortBy=<%= sortByVal != null ? sortByVal : "default" %>">&raquo;</a>
                <%
                        }
                    } else {
                %>
                <span>Không có trang</span>
                <%
                    }
                %>
            </div>
        </div>

        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>

    </body>
</html>