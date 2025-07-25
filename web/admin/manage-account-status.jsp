<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%
    List<User> employees = (List<User>) request.getAttribute("employees");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý trạng thái tài khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="p-4 bg-light">
        <h3 class="mb-4 text-center text-primary">Quản lý nhân sự nội bộ</h3>

        <form class="row justify-content-end mb-3" method="get" action="ManageAccountStatusServlet" id="filterForm">
            <div class="col-auto">
                <input type="text" name="keyword" value="${param.keyword}" class="form-control form-control-sm"
                       placeholder="Tìm kiếm..." onkeypress="handleEnter(event)" style="width: 180px;">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-sm btn-primary">🔍</button>
            </div>
            <div class="col-auto">
                <select name="sortBy" class="form-select form-select-sm" onchange="document.getElementById('filterForm').submit();" style="width: 160px;">
                    <option value="">Xếp Tự Động</option>
                    <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Xếp Theo Tên</option>
                </select>
            </div>
        </form>

        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-info">
                <tr>
                    <th>STT</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>SĐT</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${employees}" varStatus="loop">
                    <tr>
                        <td>
                            <c:out value="${(currentPage - 1) * pageSize + loop.index + 1}" />
                        </td>
                        <td>${u.fullName}</td>
                        <td>${u.email}</td>
                        <td>${u.phoneNumber}</td>
                        <td>${u.roleName}</td>
                        <td>
                            <span class="badge bg-${u.status ? 'success' : 'secondary'}">
                                ${u.status ? 'Đang hoạt động' : 'Đã khóa'}
                            </span>
                        </td>
                        <td>
                            <form method="post" action="ManageAccountStatusServlet" style="display:inline-block;">
                                <input type="hidden" name="userId" value="${u.userId}" />
                                <input type="hidden" name="status" value="${!u.status}" />

                                <input type="hidden" name="page" value="${currentPage}" />
                                <input type="hidden" name="keyword" value="${param.keyword}" />
                                <input type="hidden" name="sortBy" value="${param.sortBy}" />

                                <button type="submit" class="btn btn-${u.status ? 'danger' : 'success'} btn-sm">
                                    ${u.status ? 'Khóa' : 'Mở'}
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <nav class="mt-3">
            <ul class="pagination justify-content-center">
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="?page=1&keyword=${param.keyword}&sortBy=${param.sortBy}">&laquo;</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&sortBy=${param.sortBy}">Trước</a>
                    </li>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&keyword=${param.keyword}&sortBy=${param.sortBy}">${i}</a>
                            </li>
                        </c:when>
                        <c:when test="${i == currentPage - 2 || i == currentPage + 2}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&sortBy=${param.sortBy}">Sau</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=${totalPages}&keyword=${param.keyword}&sortBy=${param.sortBy}">&raquo;</a>
                    </li>
                </c:if>
            </ul>
        </nav>

        <script>
            function handleEnter(event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    document.getElementById('filterForm').submit();
                }
            }
        </script>
    </body>
</html>