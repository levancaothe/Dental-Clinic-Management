<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lỗi hệ thống</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="container p-5 text-center">
        <h2 class="text-danger">Đã xảy ra lỗi:</h2>
        <p><%= exception != null ? exception.getMessage() : "Không có thông tin lỗi." %></p>
        <pre><%= exception != null ? exception : "N/A" %></pre>
        <a href="home.jsp" class="btn btn-secondary">Quay lại trang chủ</a>
    </body>
</html>
