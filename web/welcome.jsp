<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chào mừng - Phòng khám nha khoa SmileCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3>Chào mừng đến với Phòng khám nha khoa SmileCare</h3>
                    </div>
                    <div class="card-body">
                        <h5>Xin chào!, <%= user.getFullName() %>!</h5>
                        <p><strong>Vai trò:</strong> <%= user.getRole().getRoleName() %></p>
                        <p><strong>Email:</strong> <%= user.getEmail() %></p>
                        
                        <% if (session.getAttribute("loginSuccess") != null) { %>
                        <div class="alert alert-success">
                            <%= session.getAttribute("loginSuccess") %>
                        </div>
                        <% session.removeAttribute("loginSuccess"); %>
                        <% } %>
                        
                        <div class="mt-3">
                            <a href="logout" class="btn btn-danger">Đăng xuất</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
