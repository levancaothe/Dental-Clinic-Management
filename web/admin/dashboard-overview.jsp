<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thống kê người dùng hệ thống</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            .overview-title {
                font-size: 24px;
                font-weight: 600;
                color: #007acc;
                margin-bottom: 30px;
            }
            .overview-card {
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s ease;
            }
            .overview-card:hover {
                transform: translateY(-5px);
            }
            .overview-icon {
                font-size: 32px;
                margin-bottom: 10px;
            }
            .overview-value {
                font-size: 36px;
                font-weight: bold;
            }
            .card-body {
                padding: 25px 20px;
            }
        </style>
    </head>
    <body class="p-4 bg-light">
        <h3 class="overview-title">Thống kê người dùng</h3>
        <div class="row g-4">

            <div class="col-md-6 col-lg-3">
                <div class="card text-white bg-primary overview-card">
                    <div class="card-body text-center">
                        <div class="overview-icon"><i class="fas fa-users"></i></div>
                        <div class="overview-value">${totalUsers}</div>
                        <div>Tổng người dùng</div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-3">
                <div class="card text-white bg-success overview-card">
                    <div class="card-body text-center">
                        <div class="overview-icon"><i class="fas fa-user-tie"></i></div>
                        <div class="overview-value">${staffCount}</div>
                        <div>Nhân viên</div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-3">
                <div class="card text-white bg-info overview-card">
                    <div class="card-body text-center">
                        <div class="overview-icon"><i class="fas fa-user-md"></i></div>
                        <div class="overview-value">${doctorCount}</div>
                        <div>Bác sĩ</div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-3">
                <div class="card text-white bg-warning overview-card">
                    <div class="card-body text-center">
                        <div class="overview-icon"><i class="fas fa-user"></i></div>
                        <div class="overview-value">${customerCount}</div>
                        <div>Bệnh nhân</div>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>