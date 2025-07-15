<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dashboardUrl = "#";
    switch (user.getRoleId()) {
        case 1: dashboardUrl = "customer/dashboard.jsp"; break;
        case 2: dashboardUrl = "staff/dashboard.jsp"; break;
        case 3: dashboardUrl = "doctor/dashboard.jsp"; break;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật thông tin cá nhân</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f9ff;
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .banner {
                background-color: #d0f0fd;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 12px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                flex-shrink: 0;
            }

            .banner img {
                width: 60px;
                height: 60px;
                object-fit: contain;
            }
            .banner a:not(.logo-box a) {
                font-weight: bold;
                color: #0078B4;
                text-decoration: none;
                border: 1px solid #64ccff;
                padding: 8px 16px;
                border-radius: 8px;
                background-color: white;
                transition: all 0.3s ease;
            }
            .banner a:not(.logo-box a):hover {
                background-color: #64ccff;
                color: white;
            }
            .content {
                flex: 1 0 auto;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .form-container {
                width: 100%;
                max-width: 800px;
                background-color: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            .header {
                background-color: #64ccff;
                color: white;
                padding: 15px;
                text-align: center;
                font-weight: bold;
                font-size: 20px;
                margin: 0;
            }

            .form-body {
                padding: 20px;
            }

            .form-group {
                display: flex;
                align-items: flex-start;
                padding: 10px 0;
                font-size: 16px;
                margin: 0;
            }

            .form-group label {
                width: 150px;
                color: #0078B4;
                font-weight: 600;
                flex-shrink: 0;
                text-align: right;
                padding-right: 20px;
                padding-top: 8px;
            }

            .input-container {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .form-group input,
            .form-group select {
                padding: 8px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background-color: #f9f9f9;
                transition: all 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus {
                background-color: #fff;
                border-color: #64ccff;
                outline: none;
            }

            .form-group:hover {
                background-color: #e0f7ff;
            }

            .is-invalid {
                border-color: #dc3545;
                box-shadow: 0 0 6px rgba(220, 53, 69, 0.2);
            }

            .invalid-feedback,
            .server-error {
                color: #dc3545;
                font-size: 0.85rem;
                font-weight: 500;
            }

            .invalid-feedback {
                display: none;
            }

            .confirm-dob {
                margin-top: 10px;
            }

            .button-group {
                display: flex;
                justify-content: center;
                gap: 12px;
                padding: 20px 0;
                flex-wrap: wrap;
            }

            .button-group button,
            .button-group a {
                background-color: white;
                color: #0078B4;
                border: 1px solid #64ccff;
                border-radius: 8px;
                padding: 10px 20px;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .button-group button:hover,
            .button-group a:hover {
                background-color: #64ccff;
                color: white;
            }

            .button-group button[type="reset"]:hover,
            .button-group .confirm-dob button[type="button"]:hover {
                background-color: #ff6b6b;
                border: 1px solid #ff6b6b;
                color: white;
            }

            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 6px;
                text-align: center;
                font-weight: 500;
                font-size: 15px;
                background-color: #e7f5ff;
                color: #0078B4;
            }

            footer {
                background-color: #d0f0fd;
                text-align: center;
                padding: 15px;
                font-weight: bold;
                color: #0078B4;
                border-top: 1px solid #ccc;
                flex-shrink: 0;
            }

            @media (max-width: 600px) {
                .banner {
                    flex-direction: column;
                    gap: 16px;
                    padding: 12px;
                }

                .form-body {
                    padding: 15px;
                }

                .form-group {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 8px;
                }

                .form-group label {
                    width: auto;
                    text-align: left;
                    padding-right: 0;
                    padding-top: 0;
                }

                .input-container {
                    width: 100%;
                }

                .form-group input,
                .form-group select {
                    width: 100%;
                }

                .header {
                    font-size: 18px;
                    padding: 12px;
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
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <a href="<%= dashboardUrl %>" class="btn">
                    <i class="fas fa-home"></i>
                </a>
            </div>
        </div>
        <div class="content">
            <div class="form-container">
                <div class="header">Cập nhật thông tin cá nhân</div>
                <div class="form-body">
                    <c:if test="${not empty message}">
                        <p class="message">${message}</p>
                    </c:if>

                    <form id="updateProfileForm" action="<c:url value='/UpdateProfileServlet' />" method="post">
                        <input type="hidden" name="userId" value="${user.userId}" />


                        <div class="form-group">
                            <label>Họ và tên:</label>
                            <div class="input-container">
                                <input type="text" name="fullName" id="fullName" value="${user.fullName}" required>
                                <div class="invalid-feedback" id="fullNameError">Họ và tên chỉ được chứa chữ cái và khoảng trắng, ký tự đầu tiên phải là chữ cái, tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau.</div>
                                <c:if test="${not empty fullNameError}">
                                    <div class="server-error">${fullNameError}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại:</label>
                            <div class="input-container">
                                <input type="text" name="phoneNumber" id="phoneNumber" value="${user.phoneNumber}">
                                <div class="invalid-feedback" id="phoneNumberError">Số điện thoại phải bắt đầu bằng số 0, có đúng 10 số và không được chứa ký tự nào khác ngoài số.</div>
                                <c:if test="${not empty phoneNumberError}">
                                    <div class="server-error">${phoneNumberError}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Địa chỉ:</label>
                            <div class="input-container">
                                <input type="text" name="address" id="address" value="${user.address}">
                                <div class="invalid-feedback" id="addressError">Địa chỉ phải từ 2 ký tự trở lên, chỉ chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số.</div>
                                <c:if test="${not empty addressError}">
                                    <div class="server-error">${addressError}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh:</label>
                            <div class="input-container">
                                <input type="date" name="dateOfBirth" id="dateOfBirth" value="${user.dateOfBirth != null ? user.dateOfBirth : ''}">
                                <div class="invalid-feedback" id="dateOfBirthError">Ngày sinh không hợp lệ hoặc là ngày trong tương lai.</div>
                                <c:if test="${not empty dateOfBirthError}">
                                    <div class="server-error">${dateOfBirthError}</div>
                                </c:if>
                                <c:if test="${showConfirmDob}">
                                    <div class="button-group confirm-dob">
                                        <button type="submit" name="confirmDob" value="true">Có</button>
                                        <button type="button" onclick="resetDob()">Không</button>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Giới tính:</label>
                            <div class="input-container">
                                <select name="gender" id="gender">
                                    <option value="" ${empty user.gender || user.gender == '' ? 'selected' : ''}>Khác</option>
                                    <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit">Cập nhật</button>
                            <a href="updateProfile.jsp">Quay lại</a>
                            <button type="reset" onclick="cleanForm()">Xoá tất cả</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <footer>
            Nụ cười của bạn – Sứ mệnh của chúng tôi!
        </footer>

        <script>
            function cleanForm() {
                const form = document.getElementById("updateProfileForm");
                form.reset();
                document.querySelectorAll(".invalid-feedback").forEach(error => error.style.display = "none");
                document.querySelectorAll(".is-invalid").forEach(input => input.classList.remove("is-invalid"));
            }

            function resetDob() {
                const form = document.getElementById("updateProfileForm");
                const dateOfBirthInput = document.getElementById("dateOfBirth");
                dateOfBirthInput.value = "";
                document.getElementById("dateOfBirthError").style.display = "none";
                dateOfBirthInput.classList.remove("is-invalid");
                // Gửi form với confirmDob = false để reset ngày sinh
                const confirmDobInput = document.createElement("input");
                confirmDobInput.type = "hidden";
                confirmDobInput.name = "confirmDob";
                confirmDobInput.value = "false";
                form.appendChild(confirmDobInput);
                form.submit();
            }

            const fullNameInput = document.getElementById("fullName");
            const fullNameError = document.getElementById("fullNameError");
            if (fullNameInput) {
                fullNameInput.addEventListener("input", function () {
                    const fullNameRegex = /^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]*$/;
                    const maxLength = 50;
                    let hasThreeConsecutive = false;
                    for (let i = 0; i < fullNameInput.value.length - 2; i++) {
                        if (fullNameInput.value[i] === fullNameInput.value[i + 1] && fullNameInput.value[i] === fullNameInput.value[i + 2]) {
                            hasThreeConsecutive = true;
                            break;
                        }
                    }
                    if (!fullNameRegex.test(fullNameInput.value) && fullNameInput.value !== "") {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.style.display = "block";
                    } else if (fullNameInput.value.length > maxLength) {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.textContent = "Họ và tên chứa tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau.";
                        fullNameError.style.display = "block";
                    } else if (hasThreeConsecutive) {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.textContent = "Họ và tên không được có 3 ký tự liên tiếp trùng nhau.";
                        fullNameError.style.display = "block";
                    } else {
                        fullNameInput.classList.remove("is-invalid");
                        fullNameError.style.display = "none";
                    }
                });
            }

            const phoneNumberInput = document.getElementById("phoneNumber");
            const phoneNumberError = document.getElementById("phoneNumberError");
            if (phoneNumberInput) {
                phoneNumberInput.addEventListener("input", function () {
                    const phoneRegex = /^0\d{9}$/;
                    if (!phoneRegex.test(phoneNumberInput.value) && phoneNumberInput.value !== "") {
                        phoneNumberInput.classList.add("is-invalid");
                        phoneNumberError.style.display = "block";
                    } else {
                        phoneNumberInput.classList.remove("is-invalid");
                        phoneNumberError.style.display = "none";
                    }
                });
            }

            const addressInput = document.getElementById("address");
            const addressError = document.getElementById("addressError");
            if (addressInput) {
                addressInput.addEventListener("input", function () {
                    const addressRegex = /^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,/]*$/;
                    if (addressInput.value.length < 2 && addressInput.value !== "") {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = "Địa chỉ phải từ 2 ký tự trở lên.";
                        addressError.style.display = "block";
                    } else if (!addressRegex.test(addressInput.value) && addressInput.value !== "") {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = "Địa chỉ chỉ được chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số.";
                        addressError.style.display = "block";
                    } else {
                        addressInput.classList.remove("is-invalid");
                        addressError.style.display = "none";
                    }
                });
            }

            const dateOfBirthInput = document.getElementById("dateOfBirth");
            const dateOfBirthError = document.getElementById("dateOfBirthError");
            if (dateOfBirthInput) {
                dateOfBirthInput.addEventListener("change", function () {
                    const dob = new Date(dateOfBirthInput.value);
                    const now = new Date();
                    if (isNaN(dob.getTime()) || dob > now || dob.getFullYear() < 1) {
                        dateOfBirthInput.classList.add("is-invalid");
                        dateOfBirthError.style.display = "block";
                    } else {
                        dateOfBirthInput.classList.remove("is-invalid");
                        dateOfBirthError.style.display = "none";
                    }
                });
            }

            const form = document.getElementById("updateProfileForm");
            if (form) {
                form.addEventListener("submit", function (e) {
                    e.preventDefault();
                    let isValid = true;
                    const fullNameRegex = /^[A-Za-zÀ-ỹ][A-Za-zÀ-ỹ\s]*$/;
                    const maxLength = 50;
                    let hasThreeConsecutive = false;
                    for (let i = 0; i < fullNameInput.value.length - 2; i++) {
                        if (fullNameInput.value[i] === fullNameInput.value[i + 1] && fullNameInput.value[i] === fullNameInput.value[i + 2]) {
                            hasThreeConsecutive = true;
                            break;
                        }
                    }
                    if (!fullNameRegex.test(fullNameInput.value)) {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.style.display = "block";
                        isValid = false;
                    } else if (fullNameInput.value.length > maxLength) {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.textContent = "Họ và tên chứa tối đa 50 ký tự, không được có 3 ký tự liên tiếp trùng nhau.";
                        fullNameError.style.display = "block";
                        isValid = false;
                    } else if (hasThreeConsecutive) {
                        fullNameInput.classList.add("is-invalid");
                        fullNameError.textContent = "Họ và tên không được có 3 ký tự liên tiếp trùng nhau.";
                        fullNameError.style.display = "block";
                        isValid = false;
                    }

                    const phoneRegex = /^0\d{9}$/;
                    if (phoneNumberInput.value && !phoneRegex.test(phoneNumberInput.value)) {
                        phoneNumberInput.classList.add("is-invalid");
                        phoneNumberError.style.display = "block";
                        isValid = false;
                    }

                    const addressRegex = /^[A-Za-zÀ-ỹ0-9][A-Za-zÀ-ỹ0-9\s,/]*$/;
                    if (addressInput.value && (addressInput.value.length < 2 || !addressRegex.test(addressInput.value))) {
                        addressInput.classList.add("is-invalid");
                        addressError.textContent = addressInput.value.length < 2 ?
                                "Địa chỉ phải từ 2 ký tự trở lên." :
                                "Địa chỉ chỉ được chứa chữ cái, số, khoảng trắng, dấu phẩy hoặc dấu gạch chéo, và bắt đầu bằng chữ cái hoặc số.";
                        addressError.style.display = "block";
                        isValid = false;
                    }

                    if (dateOfBirthInput.value) {
                        const dob = new Date(dateOfBirthInput.value);
                        const now = new Date();
                        if (isNaN(dob.getTime()) || dob > now || dob.getFullYear() < 1) {
                            dateOfBirthInput.classList.add("is-invalid");
                            dateOfBirthError.style.display = "block";
                            isValid = false;
                        }
                    }

                    if (isValid) {
                        form.submit();
                    }
                });
            }
        </script>
    </body>
</html>