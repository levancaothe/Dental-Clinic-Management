
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Phòng khám nha khoa SmileCare - Cổng thông tin bệnh nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css">
    </head>
    <body>
        <div class="dental-background">
            <div class="dental-cross"></div>

            <i class="fas fa-tooth floating-dental-icon" style="top: 15%; left: 8%; font-size: 40px; animation-duration: 18s;"></i>
            <i class="fas fa-user-md floating-dental-icon" style="top: 25%; right: 12%; font-size: 35px; animation-duration: 22s;"></i>
            <i class="fas fa-heartbeat floating-dental-icon" style="bottom: 20%; left: 10%; font-size: 32px; animation-duration: 20s;"></i>
            <i class="fas fa-shield-alt floating-dental-icon" style="bottom: 35%; right: 15%; font-size: 30px; animation-duration: 16s;"></i>
            <i class="fas fa-stethoscope floating-dental-icon" style="top: 60%; left: 5%; font-size: 28px; animation-duration: 24s;"></i>
            <i class="fas fa-tooth floating-dental-icon" style="top: 45%; right: 8%; font-size: 38px; animation-duration: 14s;"></i>
        </div>

        <div class="container-fluid d-flex align-items-center justify-content-center h-100">
            <div class="login-container">
                <div class="clinic-logo">
                    <div class="logo-container">
                        <i class="fas fa-tooth"></i>
                    </div>
                    <h1 class="clinic-name">SmileCare</h1>
                    <p class="clinic-tagline">Sự xuất sắc của nha khoa</p>
                </div>

                <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= request.getAttribute("successMessage") %>
                </div>
                <% } %>

                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
                <% } %>

                <form action="login" method="post">
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope"></i>Địa chỉ Email
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="Enter your registered email" 
                                   value="<%= request.getAttribute("rememberedEmail") != null ? request.getAttribute("rememberedEmail") : "" %>" 
                                   required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock"></i>Mật khẩu
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-key"></i></span>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Enter your secure password" 
                                   value="<%= request.getAttribute("rememberedPassword") != null ? request.getAttribute("rememberedPassword") : "" %>" 
                                   required>
                        </div>
                    </div>
                    <div class="form-options">
                        <a href="forgot-password.jsp" class="forgot-password">Quên mật khẩu?</a>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                        </button>
                    </div>
                </form>

                <div class="signup-link">
                    <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký Cổng thông tin bệnh nhân</a>
                </div>
            </div>
        </div>
    </body>
</html>
