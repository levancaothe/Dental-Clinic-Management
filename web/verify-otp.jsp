<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Phòng khám nha khoa SmileCare - Xác minh OTP</title>
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
                    <i class="fas fa-shield-check"></i>
                </div>
                <h1 class="clinic-name">Xác minh OTP</h1>
                <p class="clinic-tagline">Bảo mật SmileCare</p>
            </div>
            
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= session.getAttribute("successMessage") %>
                    <% session.removeAttribute("successMessage"); %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <p class="text-muted mb-3 text-center">
               Vui lòng nhập mã OTP gồm 6 chữ số được gửi đến địa chỉ email của bạn.
            </p>
            
            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <input type="hidden" name="action" value="verifyOTP">
                
                <div class="mb-3">
                    <label for="otp" class="form-label">
                        <i class="fas fa-key"></i>Mã OTP
                    </label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="text" class="form-control text-center" id="otp" name="otp" 
                               maxlength="6" pattern="[0-9]{6}" required 
                               style="font-size: 1.5em; letter-spacing: 0.5em;"
                               placeholder="000000">
                    </div>
                    <div class="form-text text-center">Nhập mã xác minh gồm 6 chữ số</div>
                </div>
                
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-2"></i>Xác minh OTP
                    </button>
                </div>
            </form>
            
            <div class="signup-link">
                Không nhận được mã? <a href="${pageContext.request.contextPath}/forgot-password">Gửi lại OTP</a>
            </div>
        </div>
    </div>
    
    <script>
        document.getElementById('otp').focus();       
        document.getElementById('otp').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>
