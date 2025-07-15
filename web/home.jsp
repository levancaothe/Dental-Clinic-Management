<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Phòng khám nha khoa SWP</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet"/>
        <style>
            .footer {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
                margin-top: auto;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">

            <div class="section1">
                <div class="logo">
                    <img src="image/Logo.png" alt="logo"/>
                </div>

                <h2>Hotline: 0987654321</h2>

                <div class="actions">

                    <form action="login.jsp" method="get" style="display:inline;">
                        <button type="submit">Đăng nhập</button>
                    </form>

                    <form action="register.jsp" method="get" style="display:inline;">
                        <button type="submit">Đăng ký</button>
                    </form>
                </div>
            </div>


            <div class="body-content">
                <div class="body-flex">
                    <div class="image">
                        <img src="image/home_swp.jpg" alt="Hình ảnh nha khoa">
                    </div>
                    <div class="text">
                        <h1>Nha khoa SmileCare</h1>
                        <p>Chúng tôi mang đến giải pháp chăm sóc răng miệng toàn diện:</p>
                        <ul>
                            <li>Bác sĩ chuyên môn cao</li>
                            <li>Công nghệ hiện đại</li>
                            <li>Dịch vụ đa dạng: chỉnh nha, Implant, răng sứ</li>
                            <li>Không gian thân thiện, vô trùng</li>
                            <li>Chăm sóc tận tâm</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="footer">
                Nụ cười của bạn – Sứ mệnh của chúng tôi!
            </div>
        </div>
    </body>
</html>
