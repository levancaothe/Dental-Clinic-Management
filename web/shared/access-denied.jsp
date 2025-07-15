<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>403 - Truy cập bị từ chối</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="text-center p-5">
        <h1 class="text-danger">403 - Truy cập bị từ chối</h1>
        <p>Bạn không có quyền truy cập vào trang này.</p>
        <a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-primary">Về trang chủ</a>
    </body>
</html>
